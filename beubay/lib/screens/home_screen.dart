import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/widgets/common_header.dart';
import 'package:beubay/widgets/common_promotional_banner.dart';
import 'package:beubay/widgets/common_bottom_nav_bar.dart';
import 'package:beubay/widgets/common_gradient_container.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/screens/location_picker_screen.dart';
import 'package:beubay/screens/settings_screen.dart';
import 'package:beubay/screens/search_results_screen.dart';
import 'package:beubay/screens/appointments_screen.dart';

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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDataFromApi() async {
    // Load promotional banners from API
    final banners = await ApiClient.getPromotionalBanners();
    if (banners.isNotEmpty) {
      setState(() {
        _promotionalBanners = banners;
      });
    } else {
      // Fallback placeholder data
      setState(() {
        _promotionalBanners = [
          {
            'title': 'Welcome to Beubay',
            'subtitle': 'Your Beauty & Wellness Partner',
            'buttonText': 'Explore Now',
            'footerText': 'Book your first appointment',
            'imageUrl': null,
          },
        ];
      });
    }

    // Load service categories from API
    final categories = await ApiClient.getServiceCategories();
    if (categories.isNotEmpty) {
      setState(() {
        _serviceCategories = categories;
      });
    }

    // TODO: Load salons and products from API
    // _loadSalonsNearYou();
    // _loadBeautyProducts();
  }

  Future<void> _handleLocationTap() async {
    final selectedLocation = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          currentLocation: _selectedLocation,
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        ),
      ),
    );
    if (selectedLocation != null) {
      setState(() {
        _selectedLocation = selectedLocation;
      });
    }
  }

  Future<void> _handleProfileTap() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(searchQuery: query),
        ),
      );
    }
  }

  void _handleAppointmentsTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
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
      backgroundColor: const Color(
        0xFFF8F8F8,
      ), // Exact light grey background from design
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Purple Gradient (Header, Search, Banner, Categories)
            CommonGradientContainer(
              colors: [
                const Color(0xFF9370DB), // Exact purple at top
                const Color(0xFF9370DB), // Exact purple continues
                const Color(0xFF9370DB).withOpacity(0.95),
                const Color(0xFF9370DB).withOpacity(0.9),
                const Color(0xFF9370DB).withOpacity(0.7),
                const Color(0xFF9370DB).withOpacity(0.5),
                const Color(0xFF9370DB).withOpacity(0.3),
                const Color(
                  0xFFF8F8F8,
                ), // Background color starts after first two containers
              ],
              stops: const [0.0, 0.15, 0.25, 0.4, 0.55, 0.75, 0.9, 1.0],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Section - inside gradient
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: CommonHeader(
                      selectedLocation: _selectedLocation,
                      onLocationTap: _handleLocationTap,
                      onRightIconTap: _handleProfileTap,
                    ),
                  ),

                  // Search and Appointments
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          // Search Bar - White with shadow
                          Flexible(
                            flex: 2,
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
                              child: TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: 'Search for a place or service',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                onSubmitted: (_) => _handleSearch(),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // My Appointments Field
                          GestureDetector(
                            onTap: _handleAppointmentsTap,
                            child: Container(
                              width: 140,
                              height: 50,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'My Appointments',
                                    style: TextStyle(
                                      color: Color(0xFF1A1A1A),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Small tail image (doctors/patients icon)
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF9370DB,
                                      ).withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.people,
                                      size: 14,
                                      color: Color(0xFF9370DB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Promotional Banner (Red Container)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CommonPromotionalBanner(
                      banner: _promotionalBanners.isNotEmpty
                          ? _promotionalBanners[0]
                          : null,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // What Are You Looking For Section - Title and First Two Containers Only
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Transform.translate(
                            offset: const Offset(0, 15),
                            child: const Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              child: Text(
                                'WHAT ARE YOU LOOKING FOR?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          // First row with only 2 containers - using GridView to maintain original size
                          GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 0,
                                  childAspectRatio:
                                      1.1, // Increased size - smaller ratio = larger containers
                                ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _serviceCategories.isNotEmpty
                                ? (_serviceCategories.length >= 2 ? 2 : 1)
                                : 2,
                            itemBuilder: (context, index) {
                              if (_serviceCategories.isNotEmpty) {
                                return _buildCategoryCard(
                                  _serviceCategories[index],
                                );
                              }
                              // Placeholder while loading
                              return _buildCategoryCardPlaceholder();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Remaining Service Categories (outside gradient)
            if ((_serviceCategories.isNotEmpty &&
                    _serviceCategories.length > 2) ||
                (_serviceCategories.isEmpty))
              Transform.translate(
                offset: const Offset(0, -40),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Remaining containers in grid
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 0,
                              childAspectRatio: 1.1,
                            ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _serviceCategories.isNotEmpty
                            ? (_serviceCategories.length > 2
                                  ? _serviceCategories.length - 2
                                  : 0)
                            : 2, // Show 2 placeholders for remaining
                        itemBuilder: (context, index) {
                          if (_serviceCategories.isNotEmpty &&
                              _serviceCategories.length > 2) {
                            return _buildCategoryCard(
                              _serviceCategories[index + 2],
                            );
                          }
                          return _buildCategoryCardPlaceholder();
                        },
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Salons Near You Section
            _buildSalonsNearYou(),

            const SizedBox(height: 30),

            // Beauty Product Section
            _buildBeautyProducts(),

            const SizedBox(height: 100), // Extra padding for bottom navigation
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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
}
