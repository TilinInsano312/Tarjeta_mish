import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/features/auth_pin/presentation/frames/pin_frame.dart';
import 'package:frontend/src/features/dashboard/presentation/frames/home_frame.dart';
import 'package:frontend/src/features/login/presentation/frames/login_frame.dart';
import 'package:frontend/src/features/welcome/presentation/frames/welcome_frame.dart';
import 'package:frontend/src/features/register/presentation/frames/register_frame.dart';
import 'package:frontend/src/domain/services/auth_service.dart';
import 'package:frontend/src/features/transfers/presentation/frames/contact_list.dart';
import 'package:frontend/src/core/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tarjeta Mish Demo',
        theme: ThemeData(primaryColor: Colors.tealAccent),
        home: const AuthWrapper(), 
        routes: {
          '/welcome': (_) => const WelcomeFrame(),
          '/register': (_) => const RegisterFrame(),
          '/login': (_) => const LoginFrame(),
          '/pin': (_) => const PinFrame(),
          '/home': (_) => const HomeFrame(),
          '/contacts': (_) => const ContactListFrame(),
        },
      ),
    );
  }
}


class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    try {
      final isAuthenticated = await authService.isAuthenticated();
      final userRut = await authService.getUserRut();
      
      if (mounted) {
        if (isAuthenticated && userRut != null && userRut.isNotEmpty) {

          Navigator.pushReplacementNamed(context, '/pin');
        } else {

          Navigator.pushReplacementNamed(context, '/welcome');
        }
      }
    } catch (e) {
      if (mounted) {

        Navigator.pushReplacementNamed(context, '/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.primaryLight,
              AppColors.primary.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo Mish.png',
                  width: 120,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                
                const SizedBox(height: 32),
              
                Text(
                  'Cargando...',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.neutralWhite,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutralWhite),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}