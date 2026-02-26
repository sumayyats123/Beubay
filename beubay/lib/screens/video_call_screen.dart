import 'package:flutter/material.dart';
import 'package:beubay/screens/review_screen.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';
import 'dart:async';

class VideoCallScreen extends StatefulWidget {
  final StylistOption doctor;
  final DateTime appointmentDate;
  final String appointmentTime;

  const VideoCallScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Timer? _callTimer;
  int _callDuration = 300; // 5 minutes in seconds
  bool _isVideoEnabled = true;
  bool _isMuted = false;
  bool _showChat = false;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_callDuration > 0) {
        setState(() {
          _callDuration--;
        });
      } else {
        timer.cancel();
        _endCall();
      }
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _endCall() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewScreen(
          doctor: widget.doctor,
          appointmentDate: widget.appointmentDate,
          appointmentTime: widget.appointmentTime,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Video Feed (Doctor)
          Center(
            child: Container(
              color: Colors.grey[900],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Doctor Image Placeholder
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final avatarSize = ResponsiveHelper.isMobile(context) ? 200.0 : ResponsiveHelper.isTablet(context) ? 240.0 : 280.0;
                      return Container(
                        width: avatarSize,
                        height: avatarSize,
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: avatarSize * 0.5,
                          color: Colors.white70,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                  Text(
                    widget.doctor.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.doctor.title != null) ...[
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                    Text(
                      widget.doctor.title!,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // User Video Feed (Picture in Picture)
          Positioned(
            bottom: ResponsiveHelper.isMobile(context) ? 100.0 : ResponsiveHelper.isTablet(context) ? 120.0 : 140.0,
            left: ResponsiveHelper.responsiveSpacing(context, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final pipWidth = ResponsiveHelper.isMobile(context) ? 120.0 : ResponsiveHelper.isTablet(context) ? 140.0 : 160.0;
                final pipHeight = ResponsiveHelper.isMobile(context) ? 160.0 : ResponsiveHelper.isTablet(context) ? 180.0 : 200.0;
                return Container(
                  width: pipWidth,
                  height: pipHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.person,
                    size: pipWidth * 0.5,
                    color: Colors.white70,
                  ),
                );
              },
            ),
          ),
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.doctor.title != null)
                          Text(
                            widget.doctor.title!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.responsiveSpacing(context, 12),
                        vertical: ResponsiveHelper.responsiveSpacing(context, 6),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDuration(_callDuration),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Control Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Video Toggle
                    _buildControlButton(
                      icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                      label: 'Video',
                      onPressed: () {
                        setState(() {
                          _isVideoEnabled = !_isVideoEnabled;
                        });
                      },
                    ),
                    // Mute Toggle
                    _buildControlButton(
                      icon: _isMuted ? Icons.mic_off : Icons.mic,
                      label: 'Mute',
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                    ),
                    // Chat
                    _buildControlButton(
                      icon: Icons.chat_bubble_outline,
                      label: 'Chat',
                      onPressed: () {
                        setState(() {
                          _showChat = !_showChat;
                        });
                      },
                    ),
                    // End Call
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final btnSize = ResponsiveHelper.isMobile(context) ? 56.0 : ResponsiveHelper.isTablet(context) ? 64.0 : 72.0;
                        return Container(
                          width: btnSize,
                          height: btnSize,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: btnSize * 0.5,
                            ),
                            onPressed: _endCall,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Chat Panel (if shown)
          if (_showChat)
            Positioned(
              right: ResponsiveHelper.responsiveSpacing(context, 16),
              top: ResponsiveHelper.responsiveSpacing(context, 100),
              bottom: ResponsiveHelper.responsiveSpacing(context, 100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final chatWidth = ResponsiveHelper.isMobile(context) ? MediaQuery.of(context).size.width * 0.85 : ResponsiveHelper.isTablet(context) ? 350.0 : 400.0;
                  return Container(
                    width: chatWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.responsiveSpacing(context, 12),
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF9370DB),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showChat = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(
                              ResponsiveHelper.responsiveSpacing(context, 12),
                            ),
                            children: const [
                              // Chat messages would go here
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.responsiveSpacing(context, 12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                                      vertical: ResponsiveHelper.responsiveSpacing(context, 8),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                                ),
                                onPressed: () {
                                  // Send message
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: ResponsiveHelper.responsiveFontSize(context, mobile: 28),
          ),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            padding: EdgeInsets.all(
              ResponsiveHelper.responsiveSpacing(context, 12),
            ),
          ),
        ),
        SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
          ),
        ),
      ],
    );
  }
}
