import 'package:beubay/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:beubay/utils/responsive_helper.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA020F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.spa,
              size: ResponsiveHelper.isMobile(context) ? 90.0 : ResponsiveHelper.isTablet(context) ? 110.0 : 130.0,
              color: Colors.white,
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
            Text(
              "BEUBAY",
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 36),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 10)),
            Text(
              "Beauty at Your Doorstep",
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
