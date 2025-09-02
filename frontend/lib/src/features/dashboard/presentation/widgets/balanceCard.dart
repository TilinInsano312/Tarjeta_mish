import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/domain/services/account_service.dart';
import 'package:frontend/src/domain/models/Account.dart';
import 'package:frontend/src/domain/appConfig.dart';

class BalanceCard extends HookWidget {
  const BalanceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    final repository = useMemoized(() => AccountService(
      baseUrl: AppConfig.baseUrl, 
    ));

    final snapshot = useFuture(useMemoized(() => repository.getAccount()));

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final info = snapshot.hasData
        ? snapshot.data
        : Account(
            id: 0,
            balance: 0,
            accountNumber: '0000-0000-0000-0000',
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapshot.hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Error al cargar la información: ${snapshot.error}',
              style: TextStyle(
                color: AppColors.errorColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$ ${info?.balance ?? 0}',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.blackLetter,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.blackLetter,
                        ),
                        children: [
                          const TextSpan(
                            text: 'N° de cuenta: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          TextSpan(
                            text: info?.accountNumber ?? 'N/A',
                            style: const TextStyle(
                              color: AppColors.blackLetter,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined, size: 30),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}