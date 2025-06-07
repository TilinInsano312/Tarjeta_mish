import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/core/services/authService.dart';

class WelcomeFrame extends HookWidget {
  const WelcomeFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rutController = useTextEditingController();
    final pinController = useTextEditingController();
    final isLoading = useState(false);
    final authService = AuthService();


    useEffect(() {
      void _checkAuthStatus() async {
        final isAuthenticated = await authService.isAuthenticated();
        if (isAuthenticated) {

          Navigator.pushReplacementNamed(context, '/pin');
        }
      }
      
      _checkAuthStatus();
      return null;
    }, []);

    Future<void> _handleLogin() async {
      final rut = rutController.text.trim();
      final pinText = pinController.text.trim();
      final pin = int.tryParse(pinText);


      if (rut.isEmpty || pinText.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, completa todos los campos'),
            backgroundColor: AppColors.errorColor,
          ),
        );
        return;
      }

      if (pin == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El PIN debe ser un número válido'),
            backgroundColor: AppColors.errorColor,
          ),
        );
        return;
      }

      if (pinText.length != 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El PIN debe tener 4 dígitos'),
            backgroundColor: AppColors.errorColor,
          ),
        );
        return;
      }

      isLoading.value = true;

      try {
        final loginSuccess = await authService.login(rut, pin);
        
        if (loginSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login exitoso'),
              backgroundColor: AppColors.successColor,
            ),
          );
          

          Navigator.pushReplacementNamed(context, '/pin');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Credenciales incorrectas'),
              backgroundColor: AppColors.errorColor,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: $e'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Bienvenido a Mish',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 48),

              // RUT Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackLetter,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    label: 'Ingresa tu RUT',
                    controller: rutController,
                    obscureText: false,
                    enabled: !isLoading.value,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // PIN Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PIN',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackLetter,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildField(
                    label: 'Ingresa tu PIN (4 dígitos)',
                    controller: pinController,
                    obscureText: true,
                    enabled: !isLoading.value,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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
                          'Continuar',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.neutralWhite,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required bool enabled,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: obscureText ? TextInputType.number : TextInputType.text,
      maxLength: obscureText ? 4 : null,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: enabled ? AppColors.whiteCard : AppColors.whiteCard.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        counterText: '', // Ocultar contador de caracteres
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.neutralBlack,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.borderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
    );
  }
}