import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/models/Account.dart';
import 'package:frontend/src/domain/services/contact_service.dart';
import 'package:frontend/src/domain/services/account_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
import 'package:frontend/src/domain/appConfig.dart';
import 'dart:convert';
import 'package:frontend/src/domain/services/base_service.dart';

class TransferFrame extends HookWidget {
  final Contact? preselectedContact;
  
  const TransferFrame({Key? key, this.preselectedContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedContact = useState<Contact?>(null);
    final amountController = useTextEditingController();
    final messageController = useTextEditingController();
    final isLoading = useState(false);
    final isTransferring = useState(false);
    
    final userAccount = useState<Account?>(null);
    final contacts = useState<List<Contact>>([]);
    
    final contactService = useMemoized(() => ContactService(baseUrl: AppConfig.baseUrl));
    final accountService = useMemoized(() => AccountService(baseUrl: AppConfig.baseUrl));
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

    bool isValidAmount() {
      final amount = int.tryParse(amountController.text.replaceAll(',', ''));
      return amount != null && amount > 0 && 
             userAccount.value != null && 
             amount <= userAccount.value!.balance;
    }

    bool isFormValid() {
      return selectedContact.value != null &&
             amountController.text.trim().isNotEmpty &&
             isValidAmount();
    }

    String formatCurrency(int amount) {
      return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }

    Future<void> processTransfer() async {
      isTransferring.value = true;
      try {
        final currentUser = await userService.getCurrentUser();
        final amount = int.parse(amountController.text.replaceAll(',', ''));
        
        final transactionData = {
          'amount': amount,
          'name': selectedContact.value!.name,
          'description': messageController.text.isNotEmpty 
              ? messageController.text 
              : 'Transferencia a ${selectedContact.value!.alias}',
          'rutDestination': selectedContact.value!.rut,
          'accountDestination': selectedContact.value!.accountNumber.toString(),
          'rutOrigin': currentUser.rut,
          'accountOrigin': userAccount.value!.accountNumber,
          'typeTransaction': 'TRANSFERENCIA',
          'bank': selectedContact.value!.bank.name,
          'idAccount': userAccount.value!.id,
        };

        final baseService = _TransactionService(baseUrl: AppConfig.baseUrl);
        await baseService.createTransaction(transactionData);
        
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

    Future<void> showTransferConfirmation() async {
      if (!isFormValid()) {
        showMessage('Por favor completa todos los campos correctamente', isError: true);
        return;
      }

      final amount = int.parse(amountController.text.replaceAll(',', ''));
      
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar Transferencia'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Destinatario: ${selectedContact.value!.alias}'),
                Text('Nombre: ${selectedContact.value!.name}'),
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

      if (confirmed == true) {
        await processTransfer();
      }
    }

    useEffect(() {
      Future<void> loadData() async {
        isLoading.value = true;
        try {
          print('Loading transfer data...');
          
          final account = await accountService.getAccount();
          final contactsList = await contactService.getContacts();
          
          print('Account loaded: ${account.accountNumber}, Balance: ${account.balance}');
          print('Contacts loaded: ${contactsList.length} contacts');
          
          userAccount.value = account;
          contacts.value = contactsList;
          
          // Si hay un contacto preseleccionado, establecerlo
          if (preselectedContact != null) {
            selectedContact.value = preselectedContact;
            print('Preselected contact: ${preselectedContact!.alias}');
          }
        } catch (e) {
          print('Error in loadData: $e');
          showMessage('Error al cargar datos: $e', isError: true);
        } finally {
          isLoading.value = false;
        }
      }
      
      loadData();
      return null;
    }, []);

    if (isLoading.value) {
      return Scaffold(
        backgroundColor: AppColors.whiteBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text('Transferir'),
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Transferir'),
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
            
            // Información de Origen
            Text(
              'Origen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuenta Mish  ${userAccount.value?.accountNumber ?? ""}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Saldo Disponible  \$${userAccount.value != null ? formatCurrency(userAccount.value!.balance) : "0"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Selección de Destinatario
            Text(
              'Destinatario',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            
            if (contacts.value.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  'No tienes contactos agregados. Agrega un contacto primero.',
                  style: TextStyle(
                    color: Colors.orange.shade800,
                    fontSize: 14,
                  ),
                ),
              )
            else
              DropdownButtonFormField<Contact>(
                value: selectedContact.value,
                hint: const Text('Selecciona un contacto'),
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
                items: contacts.value.toSet().toList().map((contact) {
                  return DropdownMenuItem<Contact>(
                    value: contact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          contact.alias,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${contact.name} - ${contact.bank.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (Contact? contact) {
                  selectedContact.value = contact;
                },
              ),
            
            if (selectedContact.value != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedContact.value!.alias,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${selectedContact.value!.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${selectedContact.value!.typeAccount.name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      'Cuenta ${selectedContact.value!.bank.name}  ${selectedContact.value!.accountNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Monto
            Text(
              'Monto',
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TextInputFormatter.withFunction((oldValue, newValue) {
                  if (newValue.text.isEmpty) return newValue;
                  final int value = int.tryParse(newValue.text) ?? 0;
                  final formatted = formatCurrency(value);
                  return TextEditingValue(
                    text: formatted,
                    selection: TextSelection.collapsed(offset: formatted.length),
                  );
                }),
              ],
              decoration: InputDecoration(
                hintText: 'Ingresa un monto',
                prefixText: '\$ ',
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
            
            if (amountController.text.isNotEmpty && !isValidAmount())
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  userAccount.value != null && 
                  int.tryParse(amountController.text.replaceAll(',', '')) != null &&
                  int.parse(amountController.text.replaceAll(',', '')) > userAccount.value!.balance
                      ? 'Monto excede el saldo disponible'
                      : 'Ingresa un monto válido',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
            
            const SizedBox(height: 20),
            
            // Mensaje
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
                hintText: 'Deja un mensaje',
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
            
            ElevatedButton(
              onPressed: isTransferring.value || !isFormValid() 
                  ? null 
                  : showTransferConfirmation,
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
                      'Continuar',
                      style: TextStyle(
                        color: AppColors.neutralWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
            
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: isTransferring.value ? null : () => Navigator.pop(context),
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
        '/api/transaction',
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
