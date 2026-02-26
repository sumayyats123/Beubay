import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/screens/waiting_room_screen.dart';

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
        title: const Text(
          'Confirmation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Confirmation Icon
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF9370DB),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            // Confirmation Message
            const Text(
              'Appointment Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Your appointment has been successfully booked. We look forward to serving you at our salon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Appointment Details Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
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
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedStylist.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.selectedStylist.title ?? 'Service Provider',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'CONFIRMED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEE, MMM dd, yyyy').format(widget.selectedDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Time
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.selectedTimes.isNotEmpty
                            ? '${widget.selectedTimes.first} AM - ${widget.selectedTimes.first.split(':')[0]}:${int.parse(widget.selectedTimes.first.split(':')[1]) + 30} AM'
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Type
                  Row(
                    children: [
                      const Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Online Video Call',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          icon: const Icon(Icons.schedule, size: 18),
                          label: const Text('Reschedule'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF9370DB),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        onPressed: () {
                          _showCancelDialog();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          padding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
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
                  // TODO: Navigate to payment screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Payment functionality coming soon'),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: Colors.green),
                ),
                child: const Text(
                  'Make Payment',
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Go to Dashboard',
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

