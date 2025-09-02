import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';

class WelcomeFrame extends StatelessWidget {
  const WelcomeFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gradientTop,
              AppColors.gradientMiddle,
              AppColors.gradientBottom,
            ],
            stops: const [0.25, 0.75, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralWhite,
                    ),
                  ),
                ),
                
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                
                Column(
                  children: [
                    Image.asset(
                      'assets/images/Logo Mish.png',
                      width: 280,
                      height: 160,
                      fit: BoxFit.contain,
                    ),
                    
                    const SizedBox(height: 60),

                    Text(
                      'La tarjeta para todos los chilenos, sin cobros extra.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutralWhite,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 6),
                    
                    Text(
                      'fácil y rápida de usar.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.neutralWhite,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                
                const Expanded(
                  flex: 2,
                  child: SizedBox(),
                ),
                
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neutralWhite,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Crear cuenta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.neutralWhite,
                          side: BorderSide(
                            color: AppColors.neutralWhite,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
