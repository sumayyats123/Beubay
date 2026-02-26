import 'package:flutter/material.dart';
import 'dart:async';
import 'package:beubay/screens/video_call_screen.dart';
import 'package:beubay/models/booking_models.dart';

class WaitingRoomScreen extends StatefulWidget {
  final StylistOption doctor;
  final DateTime appointmentDate;
  final String appointmentTime;

  const WaitingRoomScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  Timer? _timer;
  int _minutes = 4;
  int _seconds = 30;
  bool _notifyWhenReady = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else if (_minutes > 0) {
        setState(() {
          _minutes--;
          _seconds = 59;
        });
      } else {
        timer.cancel();
        // Auto-join when countdown reaches zero
        _joinVideoCall();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _joinVideoCall() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          doctor: widget.doctor,
          appointmentDate: widget.appointmentDate,
          appointmentTime: widget.appointmentTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Waiting Room',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Doctor Information
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Doctor Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.doctor.title != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.doctor.title!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _joinVideoCall,
                      icon: const Icon(Icons.videocam, size: 20),
                      label: const Text('VIDEO CALL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9370DB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Countdown
              Column(
                children: [
                  const Text(
                    'You are up next!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$_minutes mins $_seconds secs',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9370DB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please stay on this screen',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Notification Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notify me when ready',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Switch(
                      value: _notifyWhenReady,
                      onChanged: (value) {
                        setState(() {
                          _notifyWhenReady = value;
                        });
                      },
                      activeColor: const Color(0xFF9370DB),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Connection Check
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Connection Check',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Text(
                        'Signal strength good',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Test audio and video
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Testing audio and video...'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.videocam, size: 18),
                        label: const Text('Test Audio & Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9370DB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF9370DB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFF9370DB)),
                ),
                child: const Text(
                  'Leave Queue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _joinVideoCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9370DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Video Call',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
