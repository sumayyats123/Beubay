import 'package:flutter/material.dart';
import 'package:beubay/screens/booking_management_screen.dart';
import 'package:beubay/models/booking_models.dart';

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
        title: const Text(
          'Stylists',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Question
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Who would you like to book with?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
          // Stylist Options
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _stylistOptions.length,
              itemBuilder: (context, index) {
                final stylist = _stylistOptions[index];
                return _buildStylistCard(stylist);
              },
            ),
          ),
          // Footer Buttons
          Container(
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
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
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
        ],
      ),
    );
  }

  Widget _buildStylistCard(StylistOption stylist) {
    final isSelected = _selectedStylistId == stylist.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
            Container(
              width: 24,
              height: 24,
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
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            // Stylist Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stylist.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (stylist.title != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          stylist.title!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        if (stylist.rating != null) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${stylist.rating} rating',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (stylist.availability != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Available ${stylist.availability}',
                      style: TextStyle(
                        fontSize: 12,
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

