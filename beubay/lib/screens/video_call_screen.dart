import 'package:flutter/material.dart';
import 'package:beubay/screens/review_screen.dart';
import 'package:beubay/models/booking_models.dart';
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
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.doctor.title != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.doctor.title!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // User Video Feed (Picture in Picture)
          Positioned(
            bottom: 100,
            left: 16,
            child: Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Colors.white70,
              ),
            ),
          ),
          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.doctor.title != null)
                          Text(
                            widget.doctor.title!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _formatDuration(_callDuration),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
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
                padding: const EdgeInsets.all(20),
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
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.call_end, color: Colors.white),
                        onPressed: _endCall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Chat Panel (if shown)
          if (_showChat)
            Positioned(
              right: 16,
              top: 100,
              bottom: 100,
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
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
                          const Text(
                            'Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
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
                        padding: const EdgeInsets.all(12),
                        children: const [
                          // Chat messages would go here
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Type a message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () {
                              // Send message
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          icon: Icon(icon, color: Colors.white, size: 28),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.2),
            padding: const EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
