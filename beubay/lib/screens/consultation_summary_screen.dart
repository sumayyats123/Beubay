import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/models/booking_models.dart';

class ConsultationSummaryScreen extends StatefulWidget {
  final StylistOption doctor;
  final DateTime appointmentDate;
  final String appointmentTime;
  final int rating;
  final String feedback;

  const ConsultationSummaryScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.rating,
    required this.feedback,
  });

  @override
  State<ConsultationSummaryScreen> createState() =>
      _ConsultationSummaryScreenState();
}

class _ConsultationSummaryScreenState
    extends State<ConsultationSummaryScreen> {
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
          'Summary',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFF9370DB),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Completion Icon
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
            // Completion Message
            const Text(
              'Consultation Completed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Today, ${DateFormat('h:mm a').format(DateTime.now())}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            // Doctor's Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Doctor\'s Note',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Based on our consultation, I recommend following a regular skincare routine. The salon and spa services we discussed will help maintain your skin health. Please follow up in 2 weeks for a progress check.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Prescription
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prescription',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Based on the consultation, here are the recommended treatments and products for your skin care routine. Please follow the instructions provided during the session.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
