import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:frontend/src/core/services/authService.dart';
import 'package:frontend/src/domain/repository/loginRepository.dart';
import 'package:frontend/src/domain/appConfig.dart';

//const
const Color backgroundColor = Color(0xFF39c7c4);
const Color digitColor = Color(0xff3D5165);
const double keySize = 80.0;
const int digitFontSize = 32;
const double spacingH = 40.0;
const double spacingV = 40.0;

class PinFrame extends HookWidget {
  const PinFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pin = useState<String>('');
    final isLoading = useState<bool>(false);
    final errorMessage = useState<String?>(null);
    

    Future<void> verifyPin() async {
   
      isLoading.value = true;
      errorMessage.value = null;

      try {

        final authService = Provider.of<AuthService>(context, listen: false);
        
     
        final userRut = await authService.getUserRut();
        
        if (userRut == null || userRut.isEmpty) {
          errorMessage.value = 'No hay sesión activa. Inicie sesión nuevamente.';
          isLoading.value = false;
          

          if (!context.mounted) return;
          

          Future.delayed(Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/welcome');
            }
          });
          return;
        }
        
        if (pin.value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(pin.value)) {
          errorMessage.value = 'PIN debe tener exactamente 4 dígitos';
          pin.value = '';
          isLoading.value = false;
          return;
        }
        
      
        final loginRepository = LoginRepository(baseUrl: AppConfig.baseUrl + '/api/auth');
        
        try {
       
          final pinInt = int.parse(pin.value);
          
          final loginResponse = await loginRepository.login(userRut, pinInt);

          await authService.saveToken(loginResponse.token);

          if (!context.mounted) return;
          
          Navigator.pushReplacementNamed(context, '/home');
        } catch (e) {

          errorMessage.value = 'PIN incorrecto. Intente nuevamente.';
          pin.value = '';
        }
      } catch (e) {

        errorMessage.value = 'Error de conexión. Intente nuevamente.';
        pin.value = '';
        print('Error en verifyPin: $e');
      } finally {

        isLoading.value = false;
      }
    }
    
    void onKeyPress(String key) {

      if (isLoading.value) return;
      
      if (errorMessage.value != null) {
        errorMessage.value = null;
      }
      
      if (key == '←') {
        if (pin.value.isNotEmpty) {
          pin.value = pin.value.substring(0, pin.value.length - 1);
        }
      } else if (RegExp(r'^[0-9]$').hasMatch(key)) {

        if (pin.value.length < 4) {
          pin.value = pin.value + key;
          if (pin.value.length == 4) {

            Future.delayed(Duration(milliseconds: 100), () {
              verifyPin();
            });
          }
        }
      }
    }
    

    Widget buildKey({String? digit, IconData? icon}) {
      return InkWell(
        borderRadius: BorderRadius.circular(keySize / 2),
        onTap: isLoading.value ? null : () {
          if (digit != null) {
            onKeyPress(digit);
          } else if (icon != null) {

            onKeyPress('←');
          }
        },
        child: Container(
          width: keySize,
          height: keySize,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: icon != null
              ? Icon(icon, size: digitFontSize.toDouble(), color: digitColor)
              : (digit != null
                  ? Text(
                      digit,
                      style: TextStyle(
                        fontSize: digitFontSize.toDouble(),
                        color: digitColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SizedBox.shrink()),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Ingresa tu PIN',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            

            if (errorMessage.value != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    errorMessage.value!,
                    style: TextStyle(color: Colors.red[100], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            
            SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < pin.value.length ? Colors.white : Colors.white38,
                  ),
                );
              }),
            ),
            Spacer(),

            if (isLoading.value)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Verificando PIN...',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

            Center(
              child: SizedBox(
                width: keySize * 3 + spacingH * 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var row in [
                      ['1','2','3'],
                      ['4','5','6'],
                      ['7','8','9'],
                      ['←','0',''],
                    ])
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: spacingV/2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: row.map((key) {
                            return SizedBox(
                              width: keySize,
                              height: keySize,
                              child: key == ''
                                  ? SizedBox.shrink()
                                  : key == '←'
                                      ? buildKey(icon: Icons.backspace)
                                      : buildKey(digit: key),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Spacer(),

            TextButton(
              onPressed: isLoading.value ? null : () {
                Navigator.pushReplacementNamed(context, '/welcome');
              },
              child: Text(
                'Olvidé mi PIN',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}