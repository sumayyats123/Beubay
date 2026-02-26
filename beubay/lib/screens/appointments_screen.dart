import 'package:flutter/material.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/utils/responsive_helper.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() {
      _isLoading = true;
    });

    final appointments = await ApiClient.getUserAppointments();
    
    setState(() {
      _appointments = appointments;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Appointments',
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _appointments.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: ResponsiveHelper.isMobile(context) ? 64.0 : ResponsiveHelper.isTablet(context) ? 80.0 : 96.0,
                        color: Colors.grey,
                      ),
                      SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                      Text(
                        'No appointments found',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: ResponsiveHelper.responsivePadding(context),
                  itemCount: _appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = _appointments[index];
                    return Card(
                      margin: EdgeInsets.only(
                        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
                      ),
                      child: Padding(
                        padding: ResponsiveHelper.responsivePadding(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    appointment['serviceName'] ?? 'Service',
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveHelper.responsiveSpacing(context, 12),
                                    vertical: ResponsiveHelper.responsiveSpacing(context, 6),
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      appointment['status'] ?? 'pending',
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    appointment['status'] ?? 'Pending',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                  color: Colors.grey,
                                ),
                                SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                                Text(
                                  appointment['date'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                  ),
                                ),
                                SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 16)),
                                Icon(
                                  Icons.access_time,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                  color: Colors.grey,
                                ),
                                SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                                Text(
                                  appointment['time'] ?? 'N/A',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                  color: Colors.grey,
                                ),
                                SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 8)),
                                Expanded(
                                  child: Text(
                                    appointment['location'] ?? 'N/A',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
