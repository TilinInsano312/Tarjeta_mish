import 'package:flutter/material.dart';

//const
const Color backgroundColor = Color(0xFF39c7c4);
const Color digitColor = Color(0xff3D5165);
const double keySize = 80.0;
const int digitFontSize = 32;
const double spacingH = 32.0;
const double spacingV = 32.0;


class PinFrame extends StatefulWidget{
  const PinFrame({super.key});

  @override
  PinFrameState createState() => PinFrameState();
}

class PinFrameState extends State<PinFrame>{
  String _pin = '';

  void _onKeyPress(String key){
    setState(() {
      if(key == '←'){
        if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
      }else{
        if (_pin.length < 4) _pin += key;
        if (_pin.length == 4){
          //create a function to handle the pin
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    });
  }

  Widget _buildKey({ String? digit, IconData? icon }) {
    return InkWell(
      borderRadius: BorderRadius.circular(keySize / 2),
      onTap: () {
        if (digit != null) {
          _onKeyPress(digit);
        }
      },
      child: Container(
        width: keySize,
        height: keySize,
        alignment: Alignment.center,
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
 



 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text(
              'Ingresa tu PIN',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i < _pin.length ? Colors.white : Colors.white38,
                  ),
                );
              }),
            ),
            Spacer(),

            //BLOQUE DE TECLAS
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
                                      ? _buildKey(icon: Icons.backspace, digit: '←')
                                      : _buildKey(digit: key),
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
              onPressed: () {/* Olvidé mi PIN */},
              child: Text(
                'Olvidé mi PIN',
                style: TextStyle(
                  color: Colors.white,
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