import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/domain/models/card.dart' as domain_card;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/domain/repository/cardRepository.dart';
import 'package:frontend/src/domain/appConfig.dart';

class CardMishInfo extends HookWidget {
  const CardMishInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repository = useMemoized(() => CardRepository(
          baseUrl: AppConfig.baseUrl,
        ));

    final snapshot = useFuture(useMemoized(() => repository.getCard()));

   
    final showSensitive = useState(false);
    Timer? timer;

    void toggleShow() {

      showSensitive.value = !showSensitive.value;

      if (showSensitive.value) {
        timer?.cancel();
        timer = Timer(const Duration(seconds: 30), () {
          showSensitive.value = false;
        });
      } else {
        timer?.cancel();
      }
    }

    useEffect(() {
      return () => timer?.cancel();
    }, []);

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    final domain_card.Card info = snapshot.hasData && snapshot.data is domain_card.Card
        ? snapshot.data as domain_card.Card
        : domain_card.Card(
            cardNumber: '1234 5678 9012 3456',
            cardCVV: '369',
            expirationDate: '02/29', 
            cardHolderName: 'John Doe',
          );

    String displayCardNumber() {
      if (showSensitive.value) return info.cardNumber;

      final digitsOnly = info.cardNumber.replaceAll(' ', '');
      final last4 = digitsOnly.substring(digitsOnly.length - 4);
      return '**** **** **** $last4';
    }

    String displayCvv() => showSensitive.value ? info.cardCVV : '***';

    String displayExpiration() => showSensitive.value ? info.expirationDate : '**/**';

    return GestureDetector(
      onTap: toggleShow,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.neutralWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi tarjeta Mish',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.blackLetter,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayCardNumber(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: AppColors.blackLetter,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Expira: ${displayExpiration()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.blackLetter,
                          ),
                    ),
                    const SizedBox(width: 32),
                    Text(
                      'CVV: ${displayCvv()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.blackLetter,
                          ),
                    ),
                  ],
                ),
              ],
            ),


            Positioned(
              top: 4,
              right: 4,
              child: Image.asset(
                'assets/images/VisaTransparent.png',
                width: 53,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
