import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/domain/repository/AccountRepository.dart';
import 'package:frontend/src/domain/models/Account.dart';



class BalanceCard extends HookWidget {
    const BalanceCard ({Key? key}) : super(key: key);

    Widget build(BuildContext context) {
    
        final repository = useMemoized(() => AccountRepository(
            baseUrl: 'https://api.example.com', // Change this with api url
            token: 'token' //Change with token
        ));

        final snapshot = useFuture(useMemoized(() => repository.fetchBalance()));

        if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(
                child: CircularProgressIndicator(), 
            );
        }

        final info = snapshot.hasData
            ? snapshot.data
            : Account(
                balance: 0,
                acountNumber: '0000-0000-0000-0000',
            );

        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            if(snapshot.hasError)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        'Error al cargar la informacion',
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
                            blurRadius:8,
                            offset: const Offset(0, 4),
                        ),
                    ],
                ),
            
                child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            '\$ ${info?.balance}',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                                                const TextSpan( text: 'N de cuenta:  '),
                                                TextSpan(
                                                    text: info?.acountNumber,
                                                    style: const TextStyle(
                                                        color: AppColors.accent,
                                                        fontWeight: FontWeight.bold,
                                                    )
                                                ),
                                            ],
                                        ),
                                    ),
                                ),
            
                                IconButton(
                                        icon: const Icon(Icons.share_outlined, size: 30,),
                                        onPressed: () {
                                            //Share account
                                        },
                                    ),
                            ] 
                        )
                    ],
                ),
            ),
          ],
        );
    }
}