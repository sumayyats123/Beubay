import 'package:flutter/material.dart';
import 'package:beubay/screens/consultation_summary_screen.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';

class ReviewScreen extends StatefulWidget {
  final StylistOption doctor;
  final DateTime appointmentDate;
  final String appointmentTime;

  const ReviewScreen({
    super.key,
    required this.doctor,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
          'Review',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.responsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Info
            Container(
              padding: ResponsiveHelper.responsivePadding(context),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Doctor Image
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final avatarSize = ResponsiveHelper.isMobile(context) ? 80.0 : ResponsiveHelper.isTablet(context) ? 100.0 : 120.0;
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
                  SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 16)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
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
                        SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                        Text(
                          '25 min session',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Rating Question
            Text(
              'How was your appointment?',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.responsiveSpacing(context, 8),
                    ),
                    child: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      size: ResponsiveHelper.isMobile(context) ? 48.0 : ResponsiveHelper.isTablet(context) ? 56.0 : 64.0,
                      color: index < _rating ? Colors.amber : Colors.grey[400],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Feedback Text Area
            Text(
              'Care to share more details?',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
            TextField(
              controller: _feedbackController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Share your experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF9370DB),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding: ResponsiveHelper.responsivePadding(context),
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating > 0
                    ? () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultationSummaryScreen(
                              doctor: widget.doctor,
                              appointmentDate: widget.appointmentDate,
                              appointmentTime: widget.appointmentTime,
                              rating: _rating,
                              feedback: _feedbackController.text,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9370DB),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.responsiveSpacing(context, 16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                    fontWeight: FontWeight.bold,
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
