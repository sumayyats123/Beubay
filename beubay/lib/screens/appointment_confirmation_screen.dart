import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/screens/waiting_room_screen.dart';
import 'package:beubay/utils/responsive_helper.dart';

class AppointmentConfirmationScreen extends StatefulWidget {
  final List<String> selectedServices;
  final StylistOption selectedStylist;
  final DateTime selectedDate;
  final List<String> selectedTimes;
  final List<String> selectedPurposes;

  const AppointmentConfirmationScreen({
    super.key,
    required this.selectedServices,
    required this.selectedStylist,
    required this.selectedDate,
    required this.selectedTimes,
    required this.selectedPurposes,
  });

  @override
  State<AppointmentConfirmationScreen> createState() =>
      _AppointmentConfirmationScreenState();
}

class _AppointmentConfirmationScreenState
    extends State<AppointmentConfirmationScreen> {
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
          'Confirmation',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 40)),
            // Confirmation Icon
            LayoutBuilder(
              builder: (context, constraints) {
                final iconSize = ResponsiveHelper.isMobile(context) ? 120.0 : ResponsiveHelper.isTablet(context) ? 140.0 : 160.0;
                return Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9370DB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: iconSize * 0.5,
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
            // Confirmation Message
            Text(
              'Appointment Confirmed!',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 32),
              ),
              child: Text(
                'Your appointment has been successfully booked. We look forward to serving you at our salon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Appointment Details Card
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              padding: ResponsiveHelper.responsivePadding(context),
              decoration: BoxDecoration(
                color: const Color(0xFF9370DB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Doctor Image
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final avatarSize = ResponsiveHelper.isMobile(context) ? 60.0 : ResponsiveHelper.isTablet(context) ? 70.0 : 80.0;
                          return Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: avatarSize * 0.5,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedStylist.name,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.selectedStylist.title ?? 'Service Provider',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.responsiveSpacing(context, 12),
                          vertical: ResponsiveHelper.responsiveSpacing(context, 6),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'CONFIRMED',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 10),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      ),
                      SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(widget.selectedDate),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      ),
                      SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                      Text(
                        widget.selectedTimes.isNotEmpty
                            ? '${widget.selectedTimes.first} AM - ${widget.selectedTimes.first.split(':')[0]}:${int.parse(widget.selectedTimes.first.split(':')[1]) + 30} AM'
                            : 'N/A',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  // Type
                  Row(
                    children: [
                      Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      ),
                      SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                      Text(
                        'Online Video Call',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement reschedule
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reschedule functionality coming soon'),
                              ),
                            );
                          },
                          icon: Icon(Icons.schedule, size: ResponsiveHelper.responsiveFontSize(context, mobile: 18)),
                          label: Text('Reschedule'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF9370DB),
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.responsiveSpacing(context, 12),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
                      IconButton(
                        onPressed: () {
                          _showCancelDialog();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: EdgeInsets.all(
                            ResponsiveHelper.responsiveSpacing(context, 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 40)),
          ],
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
                  // TODO: Navigate to payment screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment functionality coming soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.responsiveSpacing(context, 14),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.green),
                ),
                child: Text(
                  'Make Payment',
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaitingRoomScreen(
                        doctor: widget.selectedStylist,
                        appointmentDate: widget.selectedDate,
                        appointmentTime: widget.selectedTimes.isNotEmpty
                            ? widget.selectedTimes.first
                            : '10:00',
                      ),
                    ),
                  );
                },
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
                  'Go to Dashboard',
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

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text(
          'Are you sure you want to cancel this appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled successfully'),
                ),
              );
            },
            child: const Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

