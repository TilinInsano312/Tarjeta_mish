import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/contact.dart';
import 'package:frontend/src/domain/models/bank.dart';
import 'package:frontend/src/domain/models/type_account.dart';
import 'package:frontend/src/domain/services/contact_service.dart';
import 'package:frontend/src/domain/services/user_service.dart';
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
    
    final selectedBank = useState<Bank?>(null);
    final selectedAccountType = useState<TypeAccount?>(null);
    final isLoading = useState(false);
    final isAliasChecking = useState(false);
    final isAliasAvailable = useState<bool?>(null);

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
      return RegExp(r'^\d{7,8}-[\dkK]$').hasMatch(rut);
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
            
            const SizedBox(height: 40),
            
            ElevatedButton(
              onPressed: isLoading.value || !isFormValid() ? null : handleCreateContact,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading.value
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
              onPressed: isLoading.value ? null : () => Navigator.pop(context),
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
