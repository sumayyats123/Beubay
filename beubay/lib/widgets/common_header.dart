import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String selectedLocation;
  final VoidCallback? onLocationTap;
  final Widget? rightIcon;
  final VoidCallback? onRightIconTap;

  const CommonHeader({
    super.key,
    required this.selectedLocation,
    this.onLocationTap,
    this.rightIcon,
    this.onRightIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        top: statusBarHeight + 15,
        bottom: 15,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          // Beubay Logo and Location Dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beubay Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF87CEEB), // Light blue
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Beubay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Location Dropdown
                GestureDetector(
                  onTap: onLocationTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          selectedLocation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Right Icon (Profile or Menu)
          rightIcon != null
              ? GestureDetector(
                  onTap: onRightIconTap,
                  child: rightIcon!,
                )
              : GestureDetector(
                  onTap: onRightIconTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
        ],
      ),
    );
  }
}
