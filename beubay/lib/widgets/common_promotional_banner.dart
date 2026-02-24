import 'package:flutter/material.dart';

class CommonPromotionalBanner extends StatelessWidget {
  final Map<String, dynamic>? banner;
  final double? height;
  final double? width;

  const CommonPromotionalBanner({
    super.key,
    this.banner,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bannerHeight = height ?? 220.0;
    final bannerWidth = width ?? (MediaQuery.of(context).size.width - 40);

    return Container(
      height: bannerHeight,
      width: width != null ? bannerWidth : double.infinity,
      margin: width != null ? const EdgeInsets.only(right: 15) : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: banner != null && banner!['gradientColors'] != null
            ? LinearGradient(
                colors: (banner!['gradientColors'] as List)
                    .map((c) => Color(c))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFFDC143C), // Red background
                  Color(0xFFC41E3A),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: Stack(
        children: [
          // Left side - Text content
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner?['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner?['subtitle'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFDC143C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    banner?['buttonText'] ?? 'Get a Free Consultation',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner?['footerText'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),

          // Right side - Image
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: banner != null && banner!['imageUrl'] != null
                    ? Image.network(
                        banner!['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white70,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.face_retouching_natural,
                          size: 80,
                          color: Colors.white70,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
