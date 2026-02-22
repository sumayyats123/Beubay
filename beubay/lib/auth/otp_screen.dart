import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/auth/register_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPScreen({super.key, required this.phoneNumber});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  int _currentFocusedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Focus first field initially
    _focusNodes[0].requestFocus();
    _currentFocusedIndex = 0;

    // Listen to focus changes
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          setState(() {
            _currentFocusedIndex = i;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onKeypadPressed(String value) {
    if (_currentFocusedIndex < 6) {
      _otpControllers[_currentFocusedIndex].text = value;
      if (_currentFocusedIndex < 5) {
        _focusNodes[_currentFocusedIndex + 1].requestFocus();
        _currentFocusedIndex++;
      }
    }
  }

  void _verifyOTP() {
    // Implement OTP verification logic here
    // Navigate to register screen after OTP verification
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract phone number from the full string (remove country code if present)
    final phoneNumber = widget.phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    final displayPhone = phoneNumber.length > 10
        ? phoneNumber.substring(phoneNumber.length - 10)
        : phoneNumber;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5), // Light pale pink background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top content section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // "Enter the OTP sent to" text with underlined phone number
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enter the OTP sent to',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1A1A1A),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(
                              0xFF2196F3,
                            ), // Blue underline
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          displayPhone,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1A1A1A),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(
                              0xFF2196F3,
                            ), // Blue underline
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        final isFocused = _currentFocusedIndex == index;
                        return SizedBox(
                          width: 50,
                          height: 60,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType:
                                TextInputType.none, // Hide system keyboard
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isFocused
                                      ? const Color(0xFF9370DB)
                                      : Colors.grey[300]!,
                                  width: isFocused ? 2 : 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: isFocused
                                      ? const Color(0xFF9370DB)
                                      : Colors.grey[300]!,
                                  width: isFocused ? 2 : 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9370DB),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                                _currentFocusedIndex = index + 1;
                              }
                            },
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 30),

                    // Resend Code text
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive code? ",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP resent successfully'),
                                  backgroundColor: Color(0xFF9370DB),
                                ),
                              );
                            },
                            child: const Text(
                              'Resend Code',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Verify Code button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9370DB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Verify Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Numeric Keypad
            _buildNumericKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      color: const Color(0xFFFFF5F5), // Light pale pink background
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Top row: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('1', ''),
              _buildKeypadButton('2', 'ABC'),
              _buildKeypadButton('3', 'DEF'),
            ],
          ),
          const SizedBox(height: 15),
          // Second row: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('4', 'GHI'),
              _buildKeypadButton('5', 'JKL'),
              _buildKeypadButton('6', 'MNO'),
            ],
          ),
          const SizedBox(height: 15),
          // Third row: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeypadButton('7', 'PQRS'),
              _buildKeypadButton('8', 'TUV'),
              _buildKeypadButton('9', 'WXYZ'),
            ],
          ),
          const SizedBox(height: 15),
          // Bottom row: 0
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildKeypadButton('0', '+')],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadButton(String number, String letters) {
    return GestureDetector(
      onTap: () {
        if (number == '0' && letters == '+') {
          _onKeypadPressed('0');
        } else {
          _onKeypadPressed(number);
        }
      },
      onLongPress: () {
        if (number == '0' && letters == '+') {
          _onKeypadPressed('+');
        }
      },
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5F5), // Light pale pink
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9370DB), // Dark purple
              ),
            ),
            if (letters.isNotEmpty)
              Text(
                letters,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
