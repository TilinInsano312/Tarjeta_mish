import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:convert';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/models/bank.dart';
import 'package:frontend/src/domain/models/type_account.dart';
import 'package:frontend/src/domain/services/contact_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
import 'package:frontend/src/domain/services/base_service.dart';
import 'package:frontend/src/domain/appConfig.dart';

class AddContactFrame extends HookWidget {
  const AddContactFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final accountNumberController = useTextEditingController();
    final aliasController = useTextEditingController();
    final rutController = useTextEditingController();
    final amountController = useTextEditingController();
    final messageController = useTextEditingController();
    
    // Agregar listener para debug del amountController
    useEffect(() {
      void listener() {
        // Comentado para producción
        // print('AMOUNT CONTROLLER CHANGED: "${amountController.text}" (length: ${amountController.text.length})');
      }
      amountController.addListener(listener);
      return () => amountController.removeListener(listener);
    }, [amountController]);
    
    final selectedBank = useState<Bank?>(null);
    final selectedAccountType = useState<TypeAccount?>(null);
    final isLoading = useState(false);
    final isAliasChecking = useState(false);
    final isAliasAvailable = useState<bool?>(null);
    final isTransferring = useState(false);
    
    // Estado para forzar reconstrucción cuando cambien los campos
    final formVersion = useState(0);
    
    // Listener para actualizar el estado cuando cambien los campos importantes
    useEffect(() {
      void updateForm() {
        formVersion.value = formVersion.value + 1;
      }
      
      nameController.addListener(updateForm);
      rutController.addListener(updateForm);
      accountNumberController.addListener(updateForm);
      amountController.addListener(updateForm);
      
      return () {
        nameController.removeListener(updateForm);
        rutController.removeListener(updateForm);
        accountNumberController.removeListener(updateForm);
        amountController.removeListener(updateForm);
      };
    }, [nameController, rutController, accountNumberController, amountController]);

    final contactService = useMemoized(() => ContactService(baseUrl: AppConfig.baseUrl));
    final userService = useMemoized(() => UserService(baseUrl: AppConfig.baseUrl));

    void showMessage(String message, {required bool isError}) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    Future<void> checkAliasAvailability(String alias) async {
      if (alias.isEmpty) {
        isAliasAvailable.value = null;
        return;
      }

      isAliasChecking.value = true;
      try {
        final available = await contactService.isAliasAvailable(alias);
        isAliasAvailable.value = available;
      } catch (e) {
        isAliasAvailable.value = true;
      } finally {
        isAliasChecking.value = false;
      }
    }

    bool isValidEmail(String email) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    }

    bool isValidRut(String rut) {
      // Validación básica de formato RUT chileno (xxxxxxxx-x)
      final isValid = RegExp(r'^\d{7,8}-[\dkK]$').hasMatch(rut.trim());
      print('Validando RUT: "$rut" -> $isValid');
      return isValid;
    }

    bool isFormValid() {
      return nameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          isValidEmail(emailController.text.trim()) &&
          rutController.text.trim().isNotEmpty &&
          isValidRut(rutController.text.trim()) &&
          accountNumberController.text.trim().isNotEmpty &&
          aliasController.text.trim().isNotEmpty &&
          selectedBank.value != null &&
          selectedAccountType.value != null &&
          (isAliasAvailable.value == true || isAliasAvailable.value == null);
    }

    Future<void> handleCreateContact() async {
      if (!isFormValid()) {
        showMessage('Por favor completa todos los campos correctamente', isError: true);
        return;
      }

      isLoading.value = true;
      try {
        final currentUser = await userService.getCurrentUser();
        
        final newContact = Contact(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          accountNumber: int.parse(accountNumberController.text.trim()),
          alias: aliasController.text.trim(),
          rut: rutController.text.trim(),
          bank: selectedBank.value!,
          typeAccount: selectedAccountType.value!,
          idUser: currentUser.id,
        );

        await contactService.createContact(newContact);
        
        showMessage('Contacto agregado exitosamente', isError: false);
        
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        showMessage('Error al crear contacto: $e', isError: true);
      } finally {
        isLoading.value = false;
      }
    }

    bool isFormValidForTransfer() {
      final name = nameController.text.trim().isNotEmpty;
      final rut = rutController.text.trim().isNotEmpty;
      final account = accountNumberController.text.trim().isNotEmpty;
      final amount = amountController.text.trim().isNotEmpty;
      final bankSelected = selectedBank.value != null;
      final typeSelected = selectedAccountType.value != null;
      
      return name && rut && account && amount && bankSelected && typeSelected;
    }

    // Función para asegurar que el RUT tenga el formato correcto con guión
    String ensureRutFormat(String rut) {
      final cleaned = rut.replaceAll('-', '').trim();
      if (cleaned.length >= 8) {
        final body = cleaned.substring(0, cleaned.length - 1);
        final dv = cleaned.substring(cleaned.length - 1);
        return '$body-$dv';
      }
      return rut; // Si no se puede formatear, devolver original
    }

    String formatCurrency(int amount) {
      return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }

    Future<void> handleDirectTransfer() async {
      if (!isFormValidForTransfer()) {
        showMessage('Por favor completa todos los campos necesarios para la transferencia', isError: true);
        return;
      }

      // Limpiar el monto: quitar $, espacios y comas para obtener solo números
      final cleanAmount = amountController.text.replaceAll('\$', '').replaceAll(' ', '').replaceAll(',', '');
      final amount = int.tryParse(cleanAmount) ?? 0;
      
      if (amount <= 0) {
        showMessage('El monto debe ser mayor a 0', isError: true);
        return;
      }
      
      // Mostrar confirmación
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Transferencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destinatario: ${nameController.text.trim()}'),
                Text('RUT: ${rutController.text.trim()}'),
                Text('Banco: ${selectedBank.value!.displayName}'),
                Text('Cuenta: ${accountNumberController.text.trim()}'),
                Text('Monto: \$${formatCurrency(amount)}'),
                if (messageController.text.isNotEmpty)
                  Text('Mensaje: ${messageController.text}'),
                const SizedBox(height: 16),
                const Text(
                  '¿Confirmas esta transferencia?',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'Confirmar',
                  style: TextStyle(color: AppColors.neutralWhite),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;

      isTransferring.value = true;
      try {
        final currentUser = await userService.getCurrentUser();
        
        // Asegurar formato exacto de RUTs
        final rutDestinationClean = rutController.text.trim().replaceAll('-', '').replaceAll(' ', '');
        final rutOriginFormatted = ensureRutFormat(currentUser.rut);
        
        // Crear el JSON de transferencia directa según el nuevo formato del backend
        final transactionData = {
          'id': null,
          'amount': amount,
          'name': nameController.text.trim(),
          'date': null,
          'description': messageController.text.isNotEmpty 
              ? messageController.text 
              : 'Transferencia a ${nameController.text.trim()}',
          'rutDestination': rutDestinationClean, // SIN guión - limpio
          'accountDestination': accountNumberController.text.trim(),
          'rutOrigin': rutOriginFormatted, // CON guión
          'accountOrigin': "8152003680781377", 
          'typeTransaction': 1, 
          'bank': selectedBank.value!.id, 
          'idAccount': 11 
        };

        print('=== JSON QUE SE VA A ENVIAR ===');
        print('rutDestination CLEAN: "$rutDestinationClean"');
        print('rutOrigin FORMATTED: "$rutOriginFormatted"');
        print('JSON: $transactionData');
        print('===============================');

        // Crear servicio de transacciones
        final transactionService = _TransactionService(baseUrl: AppConfig.baseUrl);
        await transactionService.createTransaction(transactionData);
        
        showMessage('Transferencia realizada exitosamente', isError: false);
        
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        showMessage('Error al procesar la transferencia: $e', isError: true);
      } finally {
        isTransferring.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Agrega Contacto'),
        titleTextStyle: TextStyle(
          color: AppColors.neutralWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.neutralWhite),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            
            Text(
              'Nombre',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Ingresa nombre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'RUT',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rutController,
              decoration: InputDecoration(
                hintText: 'Ingresa RUT (ej: 12345678-9)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            if (rutController.text.isNotEmpty && !isValidRut(rutController.text))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'RUT inválido. Formato: 12345678-9',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            Text(
              'Banco',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Bank>(
              value: selectedBank.value,
              hint: const Text('Selecciona un banco'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              items: Bank.values.map((bank) {
                return DropdownMenuItem<Bank>(
                  value: bank,
                  child: Text(bank.displayName),
                );
              }).toList(),
              onChanged: (Bank? bank) {
                selectedBank.value = bank;
              },
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Tipo de cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<TypeAccount>(
              value: selectedAccountType.value,
              hint: const Text('Selecciona un tipo de cuenta'),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              items: TypeAccount.values.map((type) {
                return DropdownMenuItem<TypeAccount>(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (TypeAccount? type) {
                selectedAccountType.value = type;
              },
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Número de cuenta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: accountNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingresa número de cuenta',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Alias',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: aliasController,
              decoration: InputDecoration(
                hintText: 'Ingresa alias único',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isAliasAvailable.value == false 
                        ? Colors.red 
                        : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                suffixIcon: isAliasChecking.value
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : isAliasAvailable.value == true
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : isAliasAvailable.value == false
                            ? const Icon(Icons.error, color: Colors.red)
                            : null,
              ),
              onChanged: (value) {
                if (value.length >= 4) {
                  // Debounce: solo verificar después de que el usuario deje de escribir
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (aliasController.text == value && value.length >= 4) {
                      checkAliasAvailability(value);
                    }
                  });
                } else {
                  isAliasAvailable.value = null;
                }
              },
            ),
            if (isAliasAvailable.value == false)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Este alias ya está en uso',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            Text(
              'E-mail',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Ingresa un e-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Monto (opcional para transferencia directa)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '\$ 10000 (solo números)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              // Quitamos el onChanged problemático por ahora
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Mensaje (opcional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.blackLetter,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Mensaje para la transferencia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botón Transferir Ahora
            ElevatedButton(
              onPressed: isTransferring.value || !isFormValidForTransfer() 
                  ? null 
                  : handleDirectTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isTransferring.value
                  ? CircularProgressIndicator(
                      color: AppColors.neutralWhite,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Transferir Ahora (v${formVersion.value})',
                      style: TextStyle(
                        color: AppColors.neutralWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            
            const SizedBox(height: 12),
            
            // Botón Guardar Contacto
            OutlinedButton(
              onPressed: isLoading.value || !isFormValid() ? null : handleCreateContact,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.primary),
              ),
              child: isLoading.value
                  ? CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    )
                  : Text(
                      'Solo Guardar Contacto',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: (isLoading.value || isTransferring.value) ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionService extends BaseService {
  _TransactionService({required String baseUrl}) : super(baseUrl: baseUrl);

  Future<void> createTransaction(Map<String, dynamic> transactionData) async {
    try {
      print('Creating transaction: ${jsonEncode(transactionData)}');
      
      final response = await authenticatedPost(
        '/transaction', // Solo el endpoint, sin /api porque baseUrl ya lo incluye
        jsonEncode(transactionData),
      );
      
      print('Transaction response: Status ${response.statusCode}, Body: ${response.body}');
      
      switch (response.statusCode) {
        case 200:
        case 201:
          // Transacción exitosa
          break;
        case 400:
          throw Exception('Datos de transacción inválidos');
        case 401:
          throw Exception('No autorizado');
        case 403:
          throw Exception('Fondos insuficientes');
        case 404:
          throw Exception('Cuenta no encontrada');
        case 500:
          throw Exception('Error interno del servidor');
        default:
          throw Exception('Error en la transferencia: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createTransaction: $e');
      throw Exception('Error al crear transacción: $e');
    }
  }
}
