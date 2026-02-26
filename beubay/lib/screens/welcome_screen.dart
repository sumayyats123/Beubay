import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:beubay/auth/verify_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of welcome images - add your asset images here
  final List<String> _welcomeImages = [
    'assets/images/buebay welcom1.png',
    'assets/images/buebay welcom1.png', // Replace with your second image
    'assets/images/buebay welcom1.png', // Replace with your third image
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _nextPage() {
    if (_currentPage < _welcomeImages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to verify screen (OTP screen) after current frame completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VerifyScreen()),
          );
        }
      });
    }
  }

  void _skipOnboarding() {
    // Navigate to verify screen (OTP screen) after current frame completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VerifyScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pre-calculate responsive values outside LayoutBuilder to avoid layout conflicts
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final topSpacing = isMobile ? 20.0 : isTablet ? 24.0 : 28.0;
    final buttonSpacing = isMobile ? 20.0 : isTablet ? 24.0 : 28.0;
    final bottomSpacing = isMobile ? 30.0 : isTablet ? 36.0 : 42.0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: topSpacing),
            // Beubay Logo with gradient
            _buildBeubayLogo(isMobile, isTablet),
            SizedBox(height: topSpacing),
            // PageView for welcome screens
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _welcomeImages.length,
                itemBuilder: (context, index) {
                  return _buildWelcomePage(index, isMobile, isTablet);
                },
              ),
            ),
            // Page indicator
            _buildPageIndicator(),
            SizedBox(height: buttonSpacing),
            // Navigation buttons
            _buildNavigationButtons(isMobile, isTablet),
            SizedBox(height: bottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildBeubayLogo(bool isMobile, bool isTablet) {
    final fontSize = isMobile ? 32.0 : isTablet ? 36.0 : 40.0;
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Color(0xFF87CEEB), // Light blue
          Color(0xFF9370DB), // Medium purple
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        'Beubay',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildWelcomePage(int index, bool isMobile, bool isTablet) {
    final horizontalPadding = isMobile ? 20.0 : isTablet ? 24.0 : 28.0;
    final topSpacing = isMobile ? 20.0 : isTablet ? 24.0 : 28.0;
    final middleSpacing = isMobile ? 30.0 : isTablet ? 36.0 : 42.0;
    final bottomSpacing = isMobile ? 15.0 : isTablet ? 18.0 : 21.0;
    final titleFontSize = isMobile ? 28.0 : isTablet ? 32.0 : 36.0;
    final descFontSize = isMobile ? 14.0 : isTablet ? 16.0 : 18.0;
    final iconSize = isMobile ? 50.0 : isTablet ? 60.0 : 70.0;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: topSpacing),
          // Illustration area with water wave background
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Water wave background behind the image
                Positioned.fill(
                  child: CustomPaint(
                    painter: WaterWavePainter(pageIndex: index),
                  ),
                ),
                // Image on top
                Center(
                  child: Image.asset(
                    _welcomeImages[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: iconSize,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: middleSpacing),
          // Welcome text
          Text(
            'Welcome to Beubay',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: bottomSpacing),
          // Description text
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              'Invest in your skin. It\'s going to represent you for a long time.Invest in your skin. It\'s going to represent you for a long time',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: descFontSize,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _welcomeImages.length,
      effect: const WormEffect(
        activeDotColor: Color(0xFF9370DB),
        dotColor: Color(0xFFE0E0E0),
        dotHeight: 8,
        dotWidth: 8,
        spacing: 8,
      ),
    );
  }

  Widget _buildNavigationButtons(bool isMobile, bool isTablet) {
    final isLastPage = _currentPage == _welcomeImages.length - 1;
    final horizontalPadding = isMobile ? 20.0 : isTablet ? 24.0 : 28.0;
    final buttonFontSize = isMobile ? 16.0 : isTablet ? 18.0 : 20.0;
    final buttonHorizontalPadding = isMobile ? 32.0 : isTablet ? 40.0 : 48.0;
    final buttonVerticalPadding = isMobile ? 14.0 : isTablet ? 16.0 : 18.0;
    final btnSize = isMobile ? 60.0 : isTablet ? 70.0 : 80.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          TextButton(
            onPressed: _skipOnboarding,
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: buttonFontSize,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Next/Get Start button
          isLastPage
              ? ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9370DB),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonHorizontalPadding,
                      vertical: buttonVerticalPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Get Start',
                    style: TextStyle(
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    width: btnSize,
                    height: btnSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9370DB),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9370DB).withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: btnSize * 0.47,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// Custom painter for purple water wave background
class WaterWavePainter extends CustomPainter {
  final int pageIndex;

  WaterWavePainter({required this.pageIndex});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9370DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          200.0 // More width for smooth curves
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Draw divided wave portions - each screen shows 1/3 of the wave
    _drawWavePortion(canvas, size, paint, pageIndex);
  }

  void _drawWavePortion(Canvas canvas, Size size, Paint paint, int portion) {
    final path = Path();
    final curveHeight = 25.0; // Small gentle curve amplitude
    final waveLength = size.width / 1.5; // Wavelength for 2 small smooth curves

    // Flow direction based on portion
    final upward =
        (portion == 0 || portion == 2); // First and third: down to up
    final startY = upward ? size.height * 0.75 : size.height * 0.25;
    final endY = upward ? size.height * 0.25 : size.height * 0.75;

    // Calculate starting and ending points for this portion
    // Make first screen (portion 0) match third screen (portion 2) position
    double portionStartY, portionEndY;
    if (portion == 0) {
      // First screen: use same position as third screen
      portionStartY = startY + ((endY - startY) * (2 / 3.0));
      portionEndY = startY + ((endY - startY) * (3 / 3.0));
    } else {
      portionStartY = upward
          ? startY + ((endY - startY) * (portion / 3.0))
          : startY - ((startY - endY) * (portion / 3.0));
      portionEndY = upward
          ? startY + ((endY - startY) * ((portion + 1) / 3.0))
          : startY - ((startY - endY) * ((portion + 1) / 3.0));
    }

    // Global X offset for this portion
    final startX = portion * size.width;

    // Start from left edge
    final startWaveY =
        portionStartY +
        curveHeight * math.sin((startX / waveLength) * 2 * math.pi);
    path.moveTo(0, startWaveY);

    // Create one slow, gentle curve with vertical progression
    final segments = 30; // Fewer segments for one smooth curve
    final segmentWidth = size.width / segments;
    final verticalRange = (portionEndY - portionStartY) / segments;

    for (int i = 1; i <= segments; i++) {
      final localX = i * segmentWidth;
      final globalX = startX + localX;

      // Vertical progression for this portion
      final verticalProgress = portionStartY + (verticalRange * i);
      // One slow, gentle curve
      final curveOffset =
          curveHeight * math.sin((globalX / waveLength) * 2 * math.pi);
      final y = verticalProgress + curveOffset;

      if (i == 1) {
        path.lineTo(localX, y);
      } else {
        // Use quadratic bezier for smooth single curve
        final prevLocalX = (i - 1) * segmentWidth;
        final controlX = (prevLocalX + localX) / 2;
        final controlGlobalX = startX + controlX;
        final controlVerticalProgress =
            portionStartY + (verticalRange * (i - 0.5));
        final controlCurveOffset =
            curveHeight * math.sin((controlGlobalX / waveLength) * 2 * math.pi);
        final controlY = controlVerticalProgress + controlCurveOffset;
        path.quadraticBezierTo(controlX, controlY, localX, y);
      }
    }

    // Draw the path as a stroke (one slow gentle curve), static
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WaterWavePainter oldDelegate) =>
      oldDelegate.pageIndex != pageIndex;
}
