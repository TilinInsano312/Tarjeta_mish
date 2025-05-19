import 'package:flutter/material.dart';
import 'package:frontend/src/features/auth_pin/presentation/frames/pin_frame.dart';
import 'package:frontend/src/features/dashboard/presentation/frames/home_frame.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarjeta Mish Demo',
      theme: ThemeData(primaryColor: Colors.tealAccent),
      initialRoute: '/pin',
      
      routes:{
        '/pin': (_) => PinFrame(),
        '/home': (_) => HomeFrame()
      }
    );
  }
}