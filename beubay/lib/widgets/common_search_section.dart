import 'package:flutter/material.dart';

class CommonSearchSection extends StatelessWidget {
  final String? hintText;
  final Widget? rightButton;
  final VoidCallback? onRightButtonTap;
  final bool showRightButton;

  const CommonSearchSection({
    super.key,
    this.hintText,
    this.rightButton,
    this.onRightButtonTap,
    this.showRightButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Search Bar - White with shadow
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: hintText ?? 'Search for a place or service',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          // Right Button (Appointments or Custom) - only show if showRightButton is true
          if (showRightButton) ...[
            const SizedBox(width: 12),
            rightButton != null
                ? GestureDetector(
                    onTap: onRightButtonTap,
                    child: rightButton!,
                  )
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9370DB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_today, color: Colors.white),
                  ),
          ],
        ],
      ),
    );
  }
}
