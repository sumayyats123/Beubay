import 'package:flutter/material.dart';
import 'package:beubay/screens/stylist_selection_screen.dart';

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
        title: const Text(
          'Services',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
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
              child: const Text(
                'Next',
                style: TextStyle(
                  color: Color(0xFF9370DB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Row(
        children: [
          // Left Sidebar - Categories
          Container(
            width: 120,
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
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
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
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
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
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      _buildGenderButton('Men', 'Men'),
                      const SizedBox(width: 12),
                      _buildGenderButton('Women', 'Women'),
                    ],
                  ),
                ),
                // Services List
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildServiceGroup('Hair Cut(s)'),
                      const SizedBox(height: 16),
                      _buildServiceGroup('Styling(s)'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
          padding: const EdgeInsets.symmetric(vertical: 12),
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
                fontSize: 14,
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ...groupServices.map((service) => _buildServiceItem(service)),
      ],
    );
  }

  Widget _buildServiceItem(ServiceItem service) {
    final serviceKey = '${service.category}_${service.name}_${service.price}';
    final isSelected = _selectedServices.contains(serviceKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            '${service.price}${service.hasGST ? ' + GST' : ''}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 12),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
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
                  fontSize: 12,
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
