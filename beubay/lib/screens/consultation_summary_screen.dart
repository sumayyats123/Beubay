import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';

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
        title: Text(
          'Summary',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Text(
              'Done',
              style: TextStyle(
                color: const Color(0xFF9370DB),
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.responsivePadding(context),
        child: Column(
          children: [
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
            // Completion Icon
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
            // Completion Message
            Text(
              'Consultation Completed',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
            Text(
              'Today, ${DateFormat('h:mm a').format(DateTime.now())}',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 40)),
            // Doctor's Note
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.responsivePadding(context),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doctor\'s Note',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  Text(
                    'Based on our consultation, I recommend following a regular skincare routine. The salon and spa services we discussed will help maintain your skin health. Please follow up in 2 weeks for a progress check.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
            // Prescription
            Container(
              width: double.infinity,
              padding: ResponsiveHelper.responsivePadding(context),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescription',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  Text(
                    'Based on the consultation, here are the recommended treatments and products for your skin care routine. Please follow the instructions provided during the session.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 40)),
          ],
        ),
      ),
    );
  }
}
