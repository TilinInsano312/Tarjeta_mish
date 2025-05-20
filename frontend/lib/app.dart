import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';                 // ①
import 'package:frontend/src/features/auth_pin/presentation/frames/pin_frame.dart';
import 'package:frontend/src/features/dashboard/presentation/frames/home_frame.dart';
import 'package:frontend/src/features/welcome/presentation/frames/welcome_frame.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();                    

  await Hive.initFlutter();                                     
  await Hive.openBox('userBox');                                

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});                                       

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarjeta Mish Demo',
      theme: ThemeData(primaryColor: Colors.tealAccent),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (_) => const WelcomeFrame(),
        '/pin': (_) => const PinFrame(),
        '/home': (_) => const HomeFrame(),
      },
    );
  }
}
