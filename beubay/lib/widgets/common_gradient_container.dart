import 'package:flutter/material.dart';

class CommonGradientContainer extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final List<double>? stops;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const CommonGradientContainer({
    super.key,
    required this.child,
    this.colors,
    this.stops,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              [
                const Color(0xFF9370DB), // Exact purple at top
                const Color(0xFF9370DB), // Exact purple continues
                const Color(0xFF9370DB).withOpacity(0.95),
                const Color(0xFF9370DB).withOpacity(0.9),
                const Color(0xFF9370DB).withOpacity(0.7),
                const Color(0xFF9370DB).withOpacity(0.5),
                const Color(0xFF9370DB).withOpacity(0.3),
                const Color(0xFFF8F8F8), // White/background color
              ],
          stops: stops ??
              const [
                0.0,
                0.15,
                0.25,
                0.35,
                0.5,
                0.65,
                0.8,
                1.0,
              ],
        ),
      ),
      child: child,
    );
  }
}
