import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/services/auth_service.dart';

class LoginFrame extends HookWidget {
  const LoginFrame({Key? key}) : super(key: key);

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
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/pin');
          }
        }
      }
      
      _checkAuthStatus();
      return null;
    }, []);

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

    Future<void> _handleLogin() async {
      final rut = rutController.text.trim();
      final pinText = pinController.text.trim();
      final pin = int.tryParse(pinText);

      if (rut.isEmpty || pinText.isEmpty) {
        _showMessage('Por favor, completa todos los campos', isError: true);
        return;
      }

      if (!_isValidRut(rut)) {
        _showMessage('Formato de RUT inválido. Ingresa tu RUT completo', isError: true);
        return;
      }

      if (pin == null) {
        _showMessage('El PIN debe ser un número válido', isError: true);
        return;
      }

      if (pinText.length != 4) {
        _showMessage('El PIN debe tener exactamente 4 dígitos', isError: true);
        return;
      }

      isLoading.value = true;

      try {
        final loginSuccess = await authService.login(rut, pin);
        
        if (loginSuccess) {
          _showMessage('Inicio de sesión exitoso', isError: false);
          
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/pin');
          }
        } else {
          _showMessage('Credenciales incorrectas. Verifica tu RUT y PIN', isError: true);
        }
      } catch (e) {
        _showMessage('Error al iniciar sesión: ${e.toString()}', isError: true);
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/welcome'),
        ),
        title: Text(
          'Iniciar sesión',
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
                  'Bienvenido de vuelta',
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
                  'Ingresa tus credenciales para continuar',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.blackLetter.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 40),

              _buildFieldSection(
                label: 'RUT',
                controller: rutController,
                hint: 'Ingresa tu RUT (con o sin formato)',
                enabled: !isLoading.value,
              ),

              const SizedBox(height: 24),

              _buildFieldSection(
                label: 'PIN',
                controller: pinController,
                hint: 'Ingresa tu PIN de 4 dígitos',
                obscureText: true,
                maxLength: 4,
                enabled: !isLoading.value,
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading.value ? null : _handleLogin,
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
                          'Iniciar sesión',
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
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.blackLetter.withOpacity(0.7),
                      ),
                      children: [
                        const TextSpan(text: '¿No tienes cuenta? '),
                        TextSpan(
                          text: 'Crear cuenta',
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
          keyboardType: obscureText ? TextInputType.number : TextInputType.text,
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
          ),
        ),
      ],
    );
  }
}