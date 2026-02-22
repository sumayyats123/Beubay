import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/screens/spa_screen.dart';
import 'package:beubay/screens/salon_screen.dart';
import 'package:beubay/screens/clinic_screen.dart';
import 'package:beubay/screens/cosmetic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedLocation = 'Bangalore, Karnataka...';

  // API data placeholders - will be populated from API
  List<Map<String, dynamic>> _promotionalBanners = [];
  List<Map<String, dynamic>> _serviceCategories = [];
  List<Map<String, dynamic>> _salonsNearYou = [];
  List<Map<String, dynamic>> _beautyProducts = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load data from API
    // _loadPromotionalBanners();
    // _loadServiceCategories();
    // _loadSalonsNearYou();
    // _loadBeautyProducts();

    // Placeholder data for home screen
    _promotionalBanners = [
      {
        'title': 'Welcome to Beubay',
        'subtitle': 'Your Beauty & Wellness Partner',
        'buttonText': 'Explore Now',
        'footerText': 'Book your first appointment',
        'imageUrl': null,
      },
    ];
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
      backgroundColor: const Color(
        0xFFF8F8F8,
      ), // Exact light grey background from design
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Purple Gradient (Header, Search, Banner, What Are You Looking For)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF9370DB), // Exact purple at top
                    const Color(0xFF9370DB), // Exact purple continues
                    const Color(
                      0xFF9370DB,
                    ).withOpacity(0.9), // Gradually decreasing
                    const Color(0xFF9370DB).withOpacity(0.7), // More decrease
                    const Color(
                      0xFF9370DB,
                    ).withOpacity(0.5), // Further decrease
                    const Color(0xFF9370DB).withOpacity(
                      0.3,
                    ), // Light purple spreading through top containers
                    const Color(
                      0xFFF8F8F8,
                    ), // White/background color starts at bottom containers
                  ],
                  stops: const [
                    0.0,
                    0.2, // Keep exact purple through header/search
                    0.35, // Start decreasing at banner
                    0.45, // Continue decreasing
                    0.55, // More decrease
                    0.72, // Light purple spreads more through top containers
                    0.78, // White starts for bottom containers
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Header Section - inside gradient
                  _buildHeader(),

                  // Search and Appointments
                  _buildSearchSection(),

                  // Promotional Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildPromotionalBanner(),
                  ),

                  const SizedBox(height: 20),

                  // What Are You Looking For Section - inside same gradient
                  _buildServiceCategories(),

                  const SizedBox(height: 10), // Extra padding at bottom
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Salons Near You Section
            _buildSalonsNearYou(),

            const SizedBox(height: 30),

            // Beauty Product Section
            _buildBeautyProducts(),

            const SizedBox(height: 50), // Extra padding to prevent overflow
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
      color: Colors
          .transparent, // Transparent since it's inside gradient container
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

          // Profile Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Search Bar - White with shadow
          Expanded(
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
          ),

          const SizedBox(width: 12),

          // My Appointments Button
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF9370DB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_today, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    // Use first banner from API, or show placeholder if empty
    final banner = _promotionalBanners.isNotEmpty
        ? _promotionalBanners[0]
        : null;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: banner != null && banner['gradientColors'] != null
            ? LinearGradient(
                colors: (banner['gradientColors'] as List)
                    .map((c) => Color(c))
                    .toList(),
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : const LinearGradient(
                colors: [
                  Color(0xFFDC143C), // Red background
                  Color(0xFFC41E3A),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
      ),
      child: Stack(
        children: [
          // Left side - Text content from API
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  banner?['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner?['subtitle'] ?? '',
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
                    banner?['buttonText'] ?? 'Get a Free Consultation',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  banner?['footerText'] ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
              ],
            ),
          ),

          // Right side - Image from API
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
                child: banner != null && banner['imageUrl'] != null
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

  Widget _buildServiceCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'WHAT ARE YOU LOOKING FOR?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.3, // Adjusted for image space
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _serviceCategories.isNotEmpty
                ? _serviceCategories.length
                : 4,
            itemBuilder: (context, index) {
              if (_serviceCategories.isNotEmpty) {
                return _buildCategoryCard(_serviceCategories[index]);
              }
              // Placeholder while loading
              return _buildCategoryCardPlaceholder();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image from API
          if (category['imageUrl'] != null)
            Container(
              height: 60,
              width: 60,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  category['imageUrl'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.image_not_supported,
                        size: 30,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            )
          else
            Icon(Icons.category, size: 40, color: const Color(0xFF9370DB)),
          const SizedBox(height: 4),
          Text(
            category['title'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            category['subtitle'] ?? '',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCardPlaceholder() {
    return Container(
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
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildSalonsNearYou() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SALONS NEAR YOU',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9370DB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF9370DB),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 240, // Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _salonsNearYou.isNotEmpty ? _salonsNearYou.length : 3,
            itemBuilder: (context, index) {
              if (_salonsNearYou.isNotEmpty) {
                return _buildSalonCard(_salonsNearYou[index]);
              }
              return _buildSalonCardPlaceholder();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSalonCard(Map<String, dynamic> salon) {
    return Container(
      width: 180, // Increased width for bigger container
      margin: const EdgeInsets.only(right: 15),
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
          // Image from API
          Container(
            height: 140, // Increased image height
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: salon['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      salon['imageUrl'],
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
                    child: Icon(Icons.image, color: Colors.grey, size: 40),
                  ),
          ),

          // Salon details from API
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        salon['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        salon['type'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          salon['distance'] ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalonCardPlaceholder() {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBeautyProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'BEAUTY PRODUCT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: 0.5,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9370DB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF9370DB),
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 250, // Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _beautyProducts.isNotEmpty ? _beautyProducts.length : 3,
            itemBuilder: (context, index) {
              if (_beautyProducts.isNotEmpty) {
                return _buildProductCard(_beautyProducts[index]);
              }
              return _buildProductCardPlaceholder();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      width: 160, // Increased width for bigger container
      margin: const EdgeInsets.only(right: 15),
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
          // Product image from API
          Container(
            height: 150, // Increased image height
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: product['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      product['imageUrl'],
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
                    child: Icon(
                      Icons.shopping_bag,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
          ),

          // Product details from API
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product['brand'] ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    product['price'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9370DB),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCardPlaceholder() {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 15),
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
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.content_cut, 'Salon', 1),
              _buildNavItem(Icons.spa, 'Spa', 2),
              _buildNavItem(Icons.medical_services, 'Clinic', 3),
              _buildNavItem(Icons.shopping_bag, 'Cosmetic', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    Widget? targetScreen;
    if (index == 1) {
      targetScreen = const SalonScreen();
    } else if (index == 2) {
      targetScreen = const SpaScreen();
    } else if (index == 3) {
      targetScreen = const ClinicScreen();
    } else if (index == 4) {
      targetScreen = const CosmeticScreen();
    }

    return GestureDetector(
      onTap: () {
        if (targetScreen != null && index != _currentIndex) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => targetScreen!),
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
