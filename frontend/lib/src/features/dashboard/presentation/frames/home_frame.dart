
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';
import 'package:frontend/src/features/dashboard/presentation/widgets/balanceCard.dart';
import 'package:frontend/src/features/dashboard/presentation/widgets/movementsCard.dart';
import 'package:frontend/src/features/widgets/bottom_nav.dart';
import 'package:frontend/src/features/dashboard/presentation/widgets/cardMishInfo.dart';

class HomeFrame extends HookWidget {
  const HomeFrame({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = useState(0);


final pages = [
  Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary,             
          AppColors.primaryOpacity50,    
          AppColors.whiteBackground,     
        ],
      ),
    ),
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: const [
        BalanceCard(),
        SizedBox(height: 16),
        MovementsCard(),
        SizedBox(height: 16),
        CardMishInfo(),
      ],
    ),
  ),
];

    return Scaffold(
      backgroundColor: AppColors.whiteBackground ,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
          ),
          child: AppBar(
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(Icons.menu, size:40),
              onPressed: () {
                // Lógica de menú
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_sharp, size: 40),
                onPressed: () {
                  // Lógica perfil
                },
              ),
            ],
          ),
        ),
      ),
      body: pages[currentIndex.value],
      bottomNavigationBar: BottomNav(
        index: currentIndex.value,
        onTap: (index) => currentIndex.value = index,
      ),
    );
  }
}

