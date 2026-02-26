import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/screens/appointment_confirmation_screen.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';

class BookingManagementScreen extends StatefulWidget {
  final List<String> selectedServices;
  final StylistOption selectedStylist;

  const BookingManagementScreen({
    super.key,
    required this.selectedServices,
    required this.selectedStylist,
  });

  @override
  State<BookingManagementScreen> createState() => _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  Set<String> _selectedTimes = {};
  Set<String> _selectedPurposes = {'Hair Cut'};

  final List<String> _purposes = ['Hair Cut', 'Hair wash', 'Hair cut and Share'];
  final List<String> _timeSlots = [
    '9:00',
    '9:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '1:00',
    '1:30',
    '2:00',
    '2:30',
    '3:00',
    '3:30',
    '4:00',
    '4:30',
  ];

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
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {
              // TODO: Show help/support
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consultation Details Section
            _buildConsultationDetails(),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
            // Purposes of Visit
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Purposes of Visit',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  Wrap(
                    spacing: ResponsiveHelper.responsiveSpacing(context, 8),
                    runSpacing: ResponsiveHelper.responsiveSpacing(context, 8),
                    children: _purposes.map((purpose) {
                      final isSelected = _selectedPurposes.contains(purpose);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedPurposes.remove(purpose);
                            } else {
                              _selectedPurposes.add(purpose);
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                            vertical: ResponsiveHelper.responsiveSpacing(context, 8),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF9370DB)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected)
                                Icon(
                                  Icons.check,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                  color: Colors.white,
                                ),
                              if (isSelected) SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 4)),
                              Text(
                                purpose,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
            // Select Date
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Date',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_selectedDate),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month - 1,
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _selectedDate = DateTime(
                                  _selectedDate.year,
                                  _selectedDate.month + 1,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  _buildCalendar(),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 24)),
            // Select Time
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Time',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: ResponsiveHelper.isMobile(context) ? 50.0 : ResponsiveHelper.isTablet(context) ? 60.0 : 70.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _timeSlots.length,
                          itemBuilder: (context, index) {
                            final time = _timeSlots[index];
                            final isSelected = _selectedTimes.contains(time);
                            return Padding(
                              padding: EdgeInsets.only(
                                right: ResponsiveHelper.responsiveSpacing(context, 8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedTimes.remove(time);
                                    } else {
                                      _selectedTimes.add(time);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                                    vertical: ResponsiveHelper.responsiveSpacing(context, 12),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF9370DB)
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 100)), // Space for footer
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
                child: TextButton(
                onPressed: () => _showCancelDialog(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
            Expanded(
              child: ElevatedButton(
                onPressed: _selectedTimes.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentConfirmationScreen(
                              selectedServices: widget.selectedServices,
                              selectedStylist: widget.selectedStylist,
                              selectedDate: _selectedDate,
                              selectedTimes: _selectedTimes.toList(),
                              selectedPurposes: _selectedPurposes.toList(),
                            ),
                          ),
                        );
                      }
                    : null,
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
                  'Book Now',
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

  Widget _buildConsultationDetails() {
    return Container(
      margin: ResponsiveHelper.responsivePadding(context),
      padding: ResponsiveHelper.responsivePadding(context),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
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
                      color: Colors.grey[200],
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
              SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONSULTATION WITH ${widget.selectedStylist.name.toUpperCase()}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                    Text(
                      widget.selectedStylist.title ?? 'Service Provider',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
          // Contact Options
          Row(
            children: [
              Expanded(
                child: _buildContactOption(
                  Icons.phone,
                  'Phone',
                  false,
                  () {
                    // TODO: Make phone call
                  },
                ),
              ),
              SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
              Expanded(
                child: _buildContactOption(
                  Icons.chat,
                  'Chat',
                  false,
                  () {
                    // TODO: Open chat
                  },
                ),
              ),
              SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
              Expanded(
                child: _buildContactOption(
                  Icons.videocam,
                  'Video Call',
                  true,
                  () {
                    // Video call is selected by default
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.responsiveSpacing(context, 12),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF9370DB).withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF9370DB)
                : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF9370DB)
                  : Colors.grey[600],
              size: ResponsiveHelper.isMobile(context) ? 24.0 : ResponsiveHelper.isTablet(context) ? 28.0 : 32.0,
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF9370DB)
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final firstDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.responsiveSpacing(context, 8),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((day) {
                  final daySize = ResponsiveHelper.isMobile(context) ? 40.0 : ResponsiveHelper.isTablet(context) ? 48.0 : 56.0;
                  return SizedBox(
                    width: daySize,
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                })
                .toList(),
          ),
          SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
          // Calendar days
          ...List.generate(6, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;
                final daySize = ResponsiveHelper.isMobile(context) ? 40.0 : ResponsiveHelper.isTablet(context) ? 48.0 : 56.0;
                
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return SizedBox(width: daySize, height: daySize);
                }

                final dayDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  dayNumber,
                );
                final isSelected = dayDate.year == _selectedDate.year &&
                    dayDate.month == _selectedDate.month &&
                    dayDate.day == _selectedDate.day;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDate = dayDate;
                    });
                  },
                  child: Container(
                    width: daySize,
                    height: daySize,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9370DB)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$dayNumber',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
          'Are you sure you want to cancel your Appointment?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'NO',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF9370DB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Success!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your appointment is cancelled successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9370DB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Yes',
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

