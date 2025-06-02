import 'package:flutter/material.dart';               // ①
import 'package:provider/provider.dart';
import 'package:frontend/src/features/auth_pin/presentation/frames/pin_frame.dart';
import 'package:frontend/src/features/dashboard/presentation/frames/home_frame.dart';
import 'package:frontend/src/features/welcome/presentation/frames/welcome_frame.dart';


class LoginRepository {
  final String baseUrl;
  LoginRepository({required this.baseUrl});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});                                       

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginRepository>(
          create: (_) => LoginRepository(
            baseUrl: 'http://localhost:8080/api/auth'
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tarjeta Mish Demo',
        theme: ThemeData(primaryColor: Colors.tealAccent),
        initialRoute: '/welcome',
        routes: {
          '/welcome': (_) => const WelcomeFrame(),
          '/pin': (_) => const PinFrame(),
          '/home': (_) => const HomeFrame(),
        },
      ),
    );
  }
}
