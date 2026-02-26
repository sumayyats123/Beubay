import 'package:flutter/material.dart';
import 'package:beubay/screens/stylist_selection_screen.dart';
import 'package:beubay/utils/responsive_helper.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  String _selectedGender = 'Women';
  String _selectedCategory = 'Hair Care';
  Set<String> _selectedServices = {};

  final List<ServiceCategory> _categories = [
    ServiceCategory(name: 'Hair Care', icon: Icons.content_cut),
    ServiceCategory(name: 'Hair Color', icon: Icons.palette),
    ServiceCategory(name: 'Face Care', icon: Icons.face),
    ServiceCategory(name: 'Spa', icon: Icons.spa),
    ServiceCategory(name: 'Grooming', icon: Icons.face_retouching_natural),
  ];

  final Map<String, List<ServiceItem>> _services = {
    'Hair Care': [
      ServiceItem(
        name: 'Hair Cut',
        price: 200,
        hasGST: true,
        category: 'Hair Cut(s)',
      ),
      ServiceItem(
        name: 'Hair Cut',
        price: 200,
        hasGST: true,
        category: 'Hair Cut(s)',
      ),
      ServiceItem(
        name: 'Hair Cut',
        price: 200,
        hasGST: true,
        category: 'Hair Cut(s)',
      ),
    ],
    'Hair Color': [],
    'Face Care': [],
    'Spa': [],
    'Grooming': [],
  };

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
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedServices.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StylistSelectionScreen(
                      selectedServices: _selectedServices.toList(),
                    ),
                  ),
                );
              },
              child: Text(
                'Next',
                style: TextStyle(
                  color: const Color(0xFF9370DB),
                  fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = ResponsiveHelper.isMobile(context);
          final sidebarWidth = isMobile ? 0.0 : (ResponsiveHelper.isTablet(context) ? 140.0 : 160.0);
          
          return Row(
            children: [
              // Left Sidebar - Categories (hidden on mobile)
              if (!isMobile)
                Container(
                  width: sidebarWidth,
                  color: Colors.grey[50],
                  child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category.name == _selectedCategory;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category.name;
                    });
                  },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.responsiveSpacing(context, 16),
                        horizontal: ResponsiveHelper.responsiveSpacing(context, 8),
                      ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF9370DB).withOpacity(0.1)
                          : Colors.transparent,
                      border: Border(
                        right: BorderSide(
                          color: isSelected
                              ? const Color(0xFF9370DB)
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category.icon,
                          color: isSelected
                              ? const Color(0xFF9370DB)
                              : Colors.grey[600],
                          size: ResponsiveHelper.isMobile(context) ? 20.0 : ResponsiveHelper.isTablet(context) ? 24.0 : 28.0,
                        ),
                        SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF9370DB)
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
                  ),
                ),
              // Main Content - Services
              Expanded(
                child: Column(
                  children: [
                    // Gender Filter
                    Padding(
                      padding: ResponsiveHelper.responsivePadding(context),
                      child: Row(
                        children: [
                          _buildGenderButton('Men', 'Men'),
                          SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
                          _buildGenderButton('Women', 'Women'),
                        ],
                      ),
                    ),
                    // Services List
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                        ),
                        children: [
                          _buildServiceGroup('Hair Cut(s)'),
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                          _buildServiceGroup('Styling(s)'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedGender = value;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.responsiveSpacing(context, 12),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF9370DB)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGroup(String groupName) {
    final services = _services[_selectedCategory] ?? [];
    final groupServices = services
        .where((s) => s.category == groupName)
        .toList();

    if (groupServices.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 12)),
        ...groupServices.map((service) => _buildServiceItem(service)),
      ],
    );
  }

  Widget _buildServiceItem(ServiceItem service) {
    final serviceKey = '${service.category}_${service.name}_${service.price}';
    final isSelected = _selectedServices.contains(serviceKey);

    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.responsiveSpacing(context, 12),
      ),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF9370DB).withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF9370DB)
              : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              service.name,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            '${service.price}${service.hasGST ? ' + GST' : ''}',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
          InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedServices.remove(serviceKey);
                } else {
                  _selectedServices.add(serviceKey);
                }
              });
            },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                  vertical: ResponsiveHelper.responsiveSpacing(context, 6),
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF9370DB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF9370DB)
                        : Colors.grey[400]!,
                  ),
                ),
                child: Text(
                  isSelected ? 'ADDED' : 'ADD+',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey[700],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ServiceCategory {
  final String name;
  final IconData icon;

  ServiceCategory({required this.name, required this.icon});
}

class ServiceItem {
  final String name;
  final double price;
  final bool hasGST;
  final String category;

  ServiceItem({
    required this.name,
    required this.price,
    required this.hasGST,
    required this.category,
  });
}
