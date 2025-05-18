import 'package:flutter/material.dart';
import 'package:frontend/src/core/app_colors.dart';


class BottomNav extends StatefulWidget {
  final int index;
  final Function(int) onTap;

  const BottomNav({
    Key? key,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  _BottomNav createState() => _BottomNav();
}

class _BottomNav extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    
    const double centerButtonSize = 80;

    return SizedBox(
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            
          top: 10,
          child: Container(
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 _buildNavItem(
                    icon: Icons.home,
                    label: 'Inicio',
                    index: 0,
                  ),
              
                  const SizedBox(width: centerButtonSize,),
              
                  _buildNavItem(
                    icon: Icons.book,
                    label: 'Libreta',
                    index: 2,
                  ),
                  
                ],
              ),
            ),
          ),
          ),

          Positioned(
            top: -20,
            left: MediaQuery.of(context).size.width / 2 - centerButtonSize / 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => widget.onTap(1),
                child: Container(
                  width: centerButtonSize,
                  height: centerButtonSize,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: 45 * 3.141592653589793 / 180,
                    child: Icon(
                      Icons.swap_vert,
                      size: centerButtonSize * 0.6,
                      color: widget.index == 1 ? AppColors.whiteCard : AppColors.iconColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Transferir',
                style: TextStyle(
                  color: AppColors.whiteCard,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        
      ),
    ]
    )
    );
    // Close Stack
    // Close SizedBox
  }



// Build the navigation item
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = widget.index == index;
    final Color color = isSelected ? AppColors.whiteCard : AppColors.iconColor;
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 45),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

  }
}