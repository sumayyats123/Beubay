import 'package:flutter/material.dart';
import 'package:beubay/screens/booking_management_screen.dart';
import 'package:beubay/models/booking_models.dart';
import 'package:beubay/utils/responsive_helper.dart';

class StylistSelectionScreen extends StatefulWidget {
  final List<String> selectedServices;

  const StylistSelectionScreen({
    super.key,
    required this.selectedServices,
  });

  @override
  State<StylistSelectionScreen> createState() => _StylistSelectionScreenState();
}

class _StylistSelectionScreenState extends State<StylistSelectionScreen> {
  String? _selectedStylistId;

  final List<StylistOption> _stylistOptions = [
    StylistOption(
      id: 'no_preference',
      name: 'No Preference',
      title: null,
      rating: null,
      availability: null,
      isNoPreference: true,
    ),
    StylistOption(
      id: 'nikhil_1',
      name: 'Nikhil Vishwan',
      title: 'Master Stylist',
      rating: 4.2,
      availability: '10:00 am',
      isNoPreference: false,
    ),
    StylistOption(
      id: 'nikhil_2',
      name: 'Nikhil Vishwan',
      title: 'Master Stylist',
      rating: 4.2,
      availability: '10:30 am',
      isNoPreference: false,
    ),
    StylistOption(
      id: 'nikhil_3',
      name: 'Nikhil Vishwan',
      title: 'Master Stylist',
      rating: 4.2,
      availability: '11:00 am',
      isNoPreference: false,
    ),
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
          'Stylists',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Question
          Padding(
            padding: ResponsiveHelper.responsivePadding(context),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Who would you like to book with?',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          // Stylist Options
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              itemCount: _stylistOptions.length,
              itemBuilder: (context, index) {
                final stylist = _stylistOptions[index];
                return _buildStylistCard(stylist);
              },
            ),
          ),
          // Footer Buttons
          Container(
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
                    onPressed: () => Navigator.pop(context),
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
                    onPressed: _selectedStylistId != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingManagementScreen(
                                  selectedServices: widget.selectedServices,
                                  selectedStylist: _stylistOptions.firstWhere(
                                    (s) => s.id == _selectedStylistId,
                                  ),
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
                      'Continue',
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
        ],
      ),
    );
  }

  Widget _buildStylistCard(StylistOption stylist) {
    final isSelected = _selectedStylistId == stylist.id;

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
      ),
      padding: ResponsiveHelper.responsivePadding(context),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF9370DB).withOpacity(0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF9370DB)
              : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedStylistId = stylist.id;
          });
        },
        child: Row(
          children: [
            // Radio Button
            LayoutBuilder(
              builder: (context, constraints) {
                final radioSize = ResponsiveHelper.isMobile(context) ? 24.0 : ResponsiveHelper.isTablet(context) ? 28.0 : 32.0;
                return Container(
                  width: radioSize,
                  height: radioSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF9370DB)
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected
                        ? const Color(0xFF9370DB)
                        : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: radioSize * 0.67,
                          color: Colors.white,
                        )
                      : null,
                );
              },
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 16)),
            // Stylist Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stylist.name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (stylist.title != null) ...[
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                    Row(
                      children: [
                        Text(
                          stylist.title!,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                            color: Colors.grey[700],
                          ),
                        ),
                        if (stylist.rating != null) ...[
                          SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                          Icon(
                            Icons.star,
                            size: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                            color: Colors.amber,
                          ),
                          SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 4)),
                          Text(
                            '${stylist.rating} rating',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (stylist.availability != null) ...[
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                    Text(
                      'Available ${stylist.availability}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

