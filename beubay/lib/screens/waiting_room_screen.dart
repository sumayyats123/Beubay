import 'package:flutter/material.dart';
import 'dart:async';
import 'package:beubay/screens/video_call_screen.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';

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
        title: Text(
          'Waiting Room',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ResponsiveHelper.responsivePadding(context),
          child: Column(
            children: [
              // Doctor Information
              Container(
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Doctor Image
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final avatarSize = ResponsiveHelper.isMobile(context) ? 100.0 : ResponsiveHelper.isTablet(context) ? 120.0 : 140.0;
                        return Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: avatarSize * 0.5,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                    Text(
                      widget.doctor.name,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    if (widget.doctor.title != null) ...[
                      SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                      Text(
                        widget.doctor.title!,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                    ElevatedButton.icon(
                      onPressed: _joinVideoCall,
                      icon: Icon(
                        Icons.videocam,
                        size: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                      ),
                      label: Text('VIDEO CALL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9370DB),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.responsiveSpacing(context, 32),
                          vertical: ResponsiveHelper.responsiveSpacing(context, 12),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
              // Countdown
              Column(
                children: [
                  Text(
                    'You are up next!',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                  Text(
                    '$_minutes mins $_seconds secs',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 32),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF9370DB),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                  Text(
                    'Please stay on this screen',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
              // Notification Toggle
              Container(
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notify me when ready',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
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
              SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
              // Connection Check
              Container(
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                        ),
                        SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
                        Text(
                          'Connection Check',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ResponsiveHelper.responsiveSpacing(context, 36),
                      ),
                      child: Text(
                        'Signal strength good',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
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
                        icon: Icon(
                          Icons.videocam,
                          size: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                        ),
                        label: Text('Test Audio & Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9370DB),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveHelper.responsiveSpacing(context, 12),
                          ),
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
        padding: ResponsiveHelper.responsivePadding(context),
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
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.responsiveSpacing(context, 14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Color(0xFF9370DB)),
                ),
                child: Text(
                  'Leave Queue',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
            Expanded(
              child: ElevatedButton(
                onPressed: _joinVideoCall,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9370DB),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.responsiveSpacing(context, 14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Video Call',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
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
