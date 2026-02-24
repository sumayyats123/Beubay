import 'package:flutter/material.dart';
import 'package:beubay/screens/home_screen.dart';
import 'package:beubay/screens/salon_screen.dart';
import 'package:beubay/screens/spa_screen.dart';
import 'package:beubay/screens/clinic_screen.dart';
import 'package:beubay/screens/cosmetic_screen.dart';

class CommonBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, Icons.home, 'Home', 0),
              _buildNavItem(context, Icons.content_cut, 'Salon', 1),
              _buildNavItem(context, Icons.spa, 'Spa', 2),
              _buildNavItem(context, Icons.medical_services, 'Clinic', 3),
              _buildNavItem(context, Icons.shopping_bag, 'Cosmetic', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
  ) {
    final isSelected = currentIndex == index;
    Widget? targetScreen;

    if (index == 0) {
      targetScreen = const HomeScreen();
    } else if (index == 1) {
      targetScreen = const SalonScreen();
    } else if (index == 2) {
      targetScreen = const SpaScreen();
    } else if (index == 3) {
      targetScreen = const ClinicScreen();
    } else if (index == 4) {
      targetScreen = const CosmeticScreen();
    }

    return GestureDetector(
      onTap: () {
        if (targetScreen != null && index != currentIndex) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => targetScreen!),
          );
        } else {
          onTap(index);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF9370DB) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF9370DB) : Colors.grey[600],
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
