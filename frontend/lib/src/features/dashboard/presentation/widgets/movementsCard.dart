import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/src/domain/models/movement.dart';
import 'package:frontend/src/domain/services/movement_service.dart';
import 'package:frontend/src/domain/appConfig.dart';

class MovementsCard extends HookWidget {
  const MovementsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final repository = useMemoized(() => MovementService(
        baseUrl: AppConfig.baseUrl,
     ));
    

    final snapshot = useFuture(
      useMemoized(() => repository.getMovements(), [repository])
    );

    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(), 
      );
    
    
    }
    
    if(snapshot.hasError) {
      return Column(
        crossAxisAlignment : CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Error al cargar la informacion: ${snapshot.error}',
              style: TextStyle(
                color: AppColors.errorColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        _buildCard(context, []),

        ],
      );
    }
    return _buildCard(context, snapshot.data ?? []);
    }
    
  Widget _buildCard(BuildContext context, List<Movement> movements) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:AppColors.whiteBackground,
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
              'Ultimos Movimientos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.blackLetter,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (movements.isEmpty)
              Center(
                child: Text(
                  'No hay movimientos',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.blackLetter,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
            ...movements.asMap().entries.map((entry) {
              final index = entry.key;
              final movement = entry.value;
              final isNegative = movement.amount < 0;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movement.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.blackLetter,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${isNegative ? '-' : '+'} \$ ${movement.amount.toString()}',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: isNegative ? AppColors.errorColor : AppColors.successColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (index != movements.length - 1) ...[
                    const SizedBox(height: 8),
                    Divider(
                      color: AppColors.blackLetter.withOpacity(0.1),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              );
            }),



          ],
        ),

      );

  

  }
}