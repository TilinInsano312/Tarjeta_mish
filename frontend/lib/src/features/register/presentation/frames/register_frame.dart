import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/services/register_service.dart';
import 'package:frontend/src/domain/appConfig.dart';

class RegisterFrame extends HookWidget {
  const RegisterFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rutController = useTextEditingController();
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final pinController = useTextEditingController();
    final confirmPinController = useTextEditingController();
    
    final isLoading = useState(false);
    final registerService = RegisterService(baseUrl: AppConfig.baseUrl + AppConfig.apiAuthEndpoint);

    bool _isValidRut(String rut) {
      if (rut.isEmpty) return false;
      
      final cleanRut = rut.replaceAll('.', '').replaceAll(' ', '').replaceAll('-', '');
      
      if (cleanRut.length < 8 || cleanRut.length > 9) return false;
      
      final numbers = cleanRut.substring(0, cleanRut.length - 1);
      if (!RegExp(r'^\d+$').hasMatch(numbers)) return false;
      
      final dv = cleanRut.substring(cleanRut.length - 1);
      if (!RegExp(r'^[0-9kK]$').hasMatch(dv)) return false;
      
      return true;
    }

    bool _isValidEmail(String email) {
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      return emailRegex.hasMatch(email);
    }
    void _showMessage(String message, {required bool isError}) {
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

    Future<void> _handleRegister() async {
      final rut = rutController.text.trim();
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final pin = pinController.text.trim();
      final confirmPin = confirmPinController.text.trim();

      if (rut.isEmpty || name.isEmpty || email.isEmpty || pin.isEmpty || confirmPin.isEmpty) {
        _showMessage('Por favor, completa todos los campos', isError: true);
        return;
      }

      if (!_isValidRut(rut)) {
        _showMessage('Formato de RUT inválido. Ingresa tu RUT completo', isError: true);
        return;
      }

      if (!_isValidEmail(email)) {
        _showMessage('Formato de email inválido', isError: true);
        return;
      }

      if (pin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin)) {
        _showMessage('El PIN debe tener exactamente 4 dígitos', isError: true);
        return;
      }

      if (pin != confirmPin) {
        _showMessage('Los PINs no coinciden', isError: true);
        return;
      }

      if (name.length < 2) {
        _showMessage('El nombre debe tener al menos 2 caracteres', isError: true);
        return;
      }

      isLoading.value = true;

      try {
        final success = await registerService.register(rut, name, email, pin);
        
        if (success) {
          _showMessage('Registro exitoso. Ahora puedes iniciar sesión', isError: false);
          
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      } catch (e) {
        _showMessage('Error en el registro: ${e.toString()}', isError: true);
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.blackLetter),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Crear cuenta',
          style: TextStyle(
            color: AppColors.blackLetter,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              
              
              Center(
                child: Text(
                  'Regístrate en Mish',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Center(
                child: Text(
                  'Completa tus datos para crear tu cuenta',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.blackLetter.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 32),

              _buildFieldSection(
                label: 'RUT',
                controller: rutController,
                hint: 'Ingresa tu RUT (con o sin formato)',
                keyboardType: TextInputType.text,
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 20),

              _buildFieldSection(
                label: 'Nombre completo',
                controller: nameController,
                hint: 'Ingresa tu nombre completo',
                keyboardType: TextInputType.text,
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 20),

              _buildFieldSection(
                label: 'Email',
                controller: emailController,
                hint: 'tu@email.com',
                keyboardType: TextInputType.emailAddress,
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 20),

              _buildFieldSection(
                label: 'PIN (4 dígitos)',
                controller: pinController,
                hint: 'Crea tu PIN de 4 dígitos',
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 20),

              _buildFieldSection(
                label: 'Confirmar PIN',
                controller: confirmPinController,
                hint: 'Confirma tu PIN',
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.neutralWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.neutralWhite,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.blackLetter.withOpacity(0.7),
                      ),
                      children: [
                        const TextSpan(text: '¿Ya tienes cuenta? '),
                        TextSpan(
                          text: 'Inicia sesión',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldSection({
    required String label,
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    bool obscureText = false,
    int? maxLength,
    required bool enabled,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.blackLetter,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: enabled ? AppColors.whiteCard : AppColors.whiteCard.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            counterText: '', 
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.borderColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.errorColor,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
