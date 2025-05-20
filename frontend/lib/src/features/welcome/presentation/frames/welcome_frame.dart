import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/login.dart';
import 'package:frontend/src/domain/repository/loginRepository.dart';
import 'package:hive/hive.dart';


class WelcomeFrame extends HookWidget {

  const WelcomeFrame({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final rutController = useTextEditingController();
    final pinController = useTextEditingController();

    final loginRepository = Loginrepository(baseUrl: 'http://localhost:8080/api/auth');

    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Title
              Text(
                'Bienvenido a Mish',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary
                ),
              ), 

              const SizedBox(height: 48),


              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackLetter
                    ),
                  ),
                  //Input pin
                  const SizedBox(height: 8),
                  //Input rut
                  _buildField(label: 'Ingresa tu rut', controller: rutController, obscureText:false),
                ],
              ),

              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackLetter
                    ),
                  ),
                  //Input pin
                  const SizedBox(height: 8),
                  _buildField(label: 'Ingresa tu pin', controller: pinController, obscureText: true),
                ],
              ),
              const SizedBox(height:32),
              //Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(onPressed: () async {
                  final rut = rutController.text;
                  final pinText = pinController.text;
                  final pin = int.tryParse(pinText);

                  if(rut.isEmpty || pinText.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, completa todos los campos'),
                      ),
                    );
                    return;
                  }

                  try{
                    

                    if(true){

                      Navigator.pushNamed(context, '/pin');
                    
                    }

                  }catch (e){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al iniciar sesión'),
                      ),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),

                child: const Text('Continuar'
                ,
                style: TextStyle(fontSize: 16,
                color: AppColors.neutralWhite),
                ),

                ),
              )

            ]
            
          ),
        ),
      ),
    );

  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
  }){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Input field
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: AppColors.whiteCard,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
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
                color: AppColors.borderColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );

  }

}
