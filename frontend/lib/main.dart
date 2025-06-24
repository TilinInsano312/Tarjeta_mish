import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/features/auth_pin/presentation/frames/pin_frame.dart';
import 'package:frontend/src/features/dashboard/presentation/frames/home_frame.dart';
import 'package:frontend/src/features/welcome/presentation/frames/welcome_frame.dart';
import 'package:frontend/src/domain/services/auth_service.dart';
import 'package:frontend/src/features/transfers/presentation/frames/contact_list.dart';

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
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}