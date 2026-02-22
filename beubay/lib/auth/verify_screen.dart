import 'package:flutter/material.dart';
import 'package:beubay/auth/otp_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+91';
  String _countryFlag = '🇮🇳';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _getOTP() {
    if (_phoneController.text.length == 10) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OTPScreen(phoneNumber: '$_countryCode ${_phoneController.text}'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _skip() {
    // Navigate to home or next screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with brand logos
            Expanded(flex: 2, child: _buildBrandLogosSection()),

            // Bottom section with form
            Expanded(flex: 2, child: _buildFormSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogosSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Brand logos grid - scrollable
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.5,
              ),
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              itemCount: 12, // More items for scrolling
              itemBuilder: (context, index) {
                final brands = [
                  'assets/images/Lakeme.png',
                  'assets/images/NYKAA.png',
                  'assets/images/mamaearth.png',
                  'assets/images/revlon.png',
                  'assets/images/kama.png',
                  'assets/images/Lakeme.png',
                  'assets/images/NYKAA.png',
                  'assets/images/mamaearth.png',
                  'assets/images/revlon.png',
                  'assets/images/kama.png',
                  'assets/images/Lakeme.png',
                  'assets/images/NYKAA.png',
                ];
                return _buildBrandLogo(brands[index % brands.length]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandLogo(String imagePath, {bool hasBorder = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: hasBorder
            ? Border.all(color: const Color(0xFF87CEEB), width: 2)
            : null,
      ),
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFFE4E1), // Light pink background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Beubay Logo
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xFF87CEEB), // Light blue
                  Color(0xFF9370DB), // Medium purple
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'Beubay',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Mobile Number heading
          const Text(
            'Mobile Number',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),

          const SizedBox(height: 8),

          // Description text
          const Text(
            'To get started, tell us who you are.',
            style: TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
          ),

          const SizedBox(height: 25),

          // Phone number input field
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Country code selector
                GestureDetector(
                  onTap: () {
                    // Show country code picker
                    _showCountryCodePicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _countryFlag,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _countryCode,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF1A1A1A),
                        ),
                      ],
                    ),
                  ),
                ),

                // Divider
                Container(width: 1, height: 30, color: Colors.grey[400]),

                // Phone number input
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Number',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      counterText: '',
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Bottom buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip button
              TextButton(
                onPressed: _skip,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Get OTP button
              ElevatedButton(
                onPressed: _getOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9370DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Get OTP',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Text('🇮🇳', style: TextStyle(fontSize: 24)),
                title: const Text('India'),
                subtitle: const Text('+91'),
                onTap: () {
                  setState(() {
                    _countryCode = '+91';
                    _countryFlag = '🇮🇳';
                  });
                  Navigator.pop(context);
                },
              ),
              // Add more countries as needed
            ],
          ),
        );
      },
    );
  }
}
