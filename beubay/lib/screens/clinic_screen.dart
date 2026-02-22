import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/screens/home_screen.dart';
import 'package:beubay/screens/spa_screen.dart';
import 'package:beubay/screens/salon_screen.dart';
import 'package:beubay/screens/cosmetic_screen.dart';

class ClinicScreen extends StatefulWidget {
  const ClinicScreen({super.key});

  @override
  State<ClinicScreen> createState() => _ClinicScreenState();
}

class _ClinicScreenState extends State<ClinicScreen> {
  int _currentIndex = 3; // Clinic is selected
  String _selectedLocation = 'Bangalore, Karnataka...';

  // API data placeholders - will be populated from API
  List<Map<String, dynamic>> _promotionalBanners = [];
  List<Map<String, dynamic>> _clinicServices = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load data from API
    // _loadPromotionalBanners();
    // _loadClinicServices();
    
    // Placeholder data for clinic screen
    _promotionalBanners = [
      {
        'title': 'Expert Skin Care',
        'subtitle': 'Professional Dermatology',
        'buttonText': 'Get Consultation',
        'footerText': 'Free consultation available',
        'imageUrl': null,
      },
    ];
  }

  void _showSortFilterMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.sort, color: Color(0xFF9370DB)),
              title: const Text('Sort'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show sort options
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_list, color: Color(0xFF9370DB)),
              title: const Text('Filter'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show filter options
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent with light content
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Same background as home screen
      body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section with Purple Gradient (Header, Search, Banner)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF9370DB), // Exact purple at top
                      const Color(0xFF9370DB), // Exact purple continues
                      const Color(0xFF9370DB).withOpacity(0.9), // Gradually decreasing
                      const Color(0xFF9370DB).withOpacity(0.7), // More decrease
                      const Color(0xFF9370DB).withOpacity(0.5), // Further decrease
                      const Color(0xFF9370DB).withOpacity(0.3), // Light purple spreading through top containers
                      const Color(0xFFF8F8F8), // White/background color starts at bottom containers
                    ],
                    stops: const [
                      0.0,
                      0.2, // Keep exact purple through header/search
                      0.35, // Start decreasing at banner
                      0.45, // Continue decreasing
                      0.55, // More decrease
                      0.72, // Light purple spreads more through top containers
                      0.85, // Extended spread to match home screen coverage
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Header Section - inside gradient
                    _buildHeader(),

                    // Promotional Banner (Horizontally Scrollable)
                    _buildPromotionalBanners(),

                    // Search Section
                    _buildSearchSection(),

                    const SizedBox(height: 20),

                    // Clinics Section Title and First Container - inside gradient to spread purple
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'CLINICS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1A1A1A),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          // Only first container inside gradient
                          _buildFirstServiceItem(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Remaining Clinics Section Content
              _buildRemainingClinicsSection(),

              const SizedBox(height: 50), // Extra padding at bottom
            ],
          ),
        ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    // Get status bar height
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: Colors.transparent, // Transparent since it's inside gradient container
      padding: EdgeInsets.only(
        top: statusBarHeight + 15, // Add status bar height + padding
        bottom: 15,
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          // Beubay Logo and Location Dropdown
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Beubay Title
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF87CEEB), // Light blue
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Beubay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Location Dropdown
                GestureDetector(
                  onTap: () {
                    // TODO: Show location picker
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          _selectedLocation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Three Dots Menu
          GestureDetector(
            onTap: _showSortFilterMenu,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanners() {
    return SizedBox(
      height: 220,
      child: _promotionalBanners.isNotEmpty
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: _promotionalBanners.length,
              itemBuilder: (context, index) {
                return _buildPromotionalBanner(_promotionalBanners[index]);
              },
            )
          : _buildPromotionalBannerPlaceholder(),
    );
  }

  Widget _buildPromotionalBanner(Map<String, dynamic> banner) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: banner['gradientColors'] != null
            ? LinearGradient(
                colors: (banner['gradientColors'] as List)
                    .map((c) => Color(c))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFFDC143C),
                  Color(0xFFC41E3A),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner['subtitle'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFDC143C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    banner['buttonText'] ?? 'Get a Free Consultation',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner['footerText'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 120,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: banner['imageUrl'] != null
                    ? Image.network(
                        banner['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white.withOpacity(0.2),
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white70,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.2),
                        child: const Icon(
                          Icons.face_retouching_natural,
                          size: 80,
                          color: Colors.white70,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBannerPlaceholder() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFDC143C),
            Color(0xFFC41E3A),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for a place or service',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFirstServiceItem() {
    // Show only first container inside gradient
    if (_clinicServices.isNotEmpty) {
      return _buildServiceCard(_clinicServices[0]);
    }
    return _buildServiceCardPlaceholder();
  }

  Widget _buildRemainingClinicsSection() {
    // Show remaining items outside gradient
    if (_clinicServices.length <= 1) {
      // Show placeholder containers if no services or only one service
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            2,
            (index) => _buildServiceCardPlaceholder(),
          ),
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _clinicServices.length - 1,
            itemBuilder: (context, index) {
              return _buildServiceCard(_clinicServices[index + 1]);
            },
          ),
        ],
      ),
    );
  }


  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: service['imageUrl'] != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Image.network(
                          service['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.medical_services, color: Colors.grey, size: 40),
                      ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9370DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    service['discount'] ?? 'Get 20% off',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['description'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          service['distance'] ?? '0.10kms',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        const Icon(Icons.bolt, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          service['serviceType'] ?? 'Urban',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          service['rating'] ?? '4.4',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCardPlaceholder() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // White background
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0, const HomeScreen()),
              _buildNavItem(Icons.content_cut, 'Salon', 1, const SalonScreen()),
              _buildNavItem(Icons.spa, 'Spa', 2, const SpaScreen()),
              _buildNavItem(Icons.medical_services, 'Clinic', 3, null),
              _buildNavItem(Icons.shopping_bag, 'Cosmetic', 4, const CosmeticScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, Widget? screen) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (screen != null && index != _currentIndex) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF9370DB) // Purple when selected
                : Colors.grey[600], // Grey when not selected
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF9370DB) // Purple when selected
                  : Colors.grey[600], // Grey when not selected
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
