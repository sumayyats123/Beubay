import 'package:flutter/material.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/utils/responsive_helper.dart';

class LocationPickerScreen extends StatefulWidget {
  final String currentLocation;
  final Function(String) onLocationSelected;

  const LocationPickerScreen({
    super.key,
    required this.currentLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  List<Map<String, dynamic>> _locations = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    setState(() {
      _isLoading = true;
    });

    final locations = await ApiClient.getLocations();
    
    setState(() {
      _locations = locations;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredLocations {
    if (_searchQuery.isEmpty) {
      return _locations;
    }
    return _locations.where((location) {
      final name = (location['name'] ?? '').toString().toLowerCase();
      final city = (location['city'] ?? '').toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase()) ||
          city.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: ResponsiveHelper.responsivePadding(context),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                ),
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
                  borderSide: const BorderSide(color: Color(0xFF9370DB), width: 2),
                ),
              ),
            ),
          ),

          // Locations list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredLocations.isEmpty
                    ? Center(
                        child: Text(
                          'No locations found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredLocations.length,
                        itemBuilder: (context, index) {
                          final location = _filteredLocations[index];
                          final locationName =
                              '${location['city'] ?? ''}, ${location['state'] ?? ''}...';
                          final isSelected = locationName == widget.currentLocation;

                          return ListTile(
                            leading: Icon(
                              Icons.location_on,
                              color: const Color(0xFF9370DB),
                              size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                            ),
                            title: Text(
                              location['name'] ?? locationName,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF9370DB)
                                    : const Color(0xFF1A1A1A),
                                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                              ),
                            ),
                            subtitle: Text(
                              locationName,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check,
                                    color: const Color(0xFF9370DB),
                                    size: ResponsiveHelper.responsiveFontSize(context, mobile: 24),
                                  )
                                : null,
                            onTap: () {
                              widget.onLocationSelected(locationName);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
