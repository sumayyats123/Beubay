import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/widgets/common_header.dart';
import 'package:beubay/widgets/common_bottom_nav_bar.dart';
import 'package:beubay/widgets/common_gradient_container.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/screens/location_picker_screen.dart';
import 'package:beubay/screens/profile_screen.dart';
import 'package:beubay/screens/search_results_screen.dart';
import 'package:beubay/screens/cart_screen.dart';
import 'package:beubay/screens/category_subcategories_screen.dart';

class CosmeticScreen extends StatefulWidget {
  const CosmeticScreen({super.key});

  @override
  State<CosmeticScreen> createState() => _CosmeticScreenState();
}

class _CosmeticScreenState extends State<CosmeticScreen> {
  int _currentIndex = 4; // Cosmetic is selected
  String _selectedLocation = 'Bangalore, Karnataka...';
  final TextEditingController _searchController = TextEditingController();

  // API data placeholders - will be populated from API
  List<Map<String, dynamic>> _justArrivals = [];
  List<Map<String, dynamic>> _mostPopular = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

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
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data from API
      final justArrivals = await ApiClient.getJustArrivals();
      final mostPopular = await ApiClient.getMostPopular();
      final categories = await ApiClient.getCosmeticCategories();

      setState(() {
        _justArrivals = justArrivals;
        _mostPopular = mostPopular;
        _categories = categories.isNotEmpty
            ? categories
            : [
                // Fallback categories if API returns empty
                {'name': 'Makeup', 'icon': Icons.face},
                {'name': 'Skincare', 'icon': Icons.spa},
                {'name': 'Haircare', 'icon': Icons.content_cut},
                {'name': 'Fragrance', 'icon': Icons.local_florist},
                {'name': 'Bodycare', 'icon': Icons.self_improvement},
                {'name': 'Makeup', 'icon': Icons.face},
                {'name': 'Skincare', 'icon': Icons.spa},
                {'name': 'Haircare', 'icon': Icons.content_cut},
              ];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading cosmetic data: $e');
      setState(() {
        _isLoading = false;
        // Keep placeholder data on error
        _justArrivals = [
          {
            'name': 'Glow Serum',
            'brand': 'The Ordinary',
            'price': '₹1259',
            'imageUrl': null,
          },
        ];
        _mostPopular = [
          {
            'name': 'Glow Serum',
            'brand': 'The Ordinary',
            'price': '₹1299',
            'imageUrl': null,
          },
        ];
        _categories = [
          {'name': 'Makeup', 'icon': Icons.face},
          {'name': 'Skincare', 'icon': Icons.spa},
          {'name': 'Haircare', 'icon': Icons.content_cut},
          {'name': 'Fragrance', 'icon': Icons.local_florist},
          {'name': 'Bodycare', 'icon': Icons.self_improvement},
          {'name': 'Makeup', 'icon': Icons.face},
          {'name': 'Skincare', 'icon': Icons.spa},
          {'name': 'Haircare', 'icon': Icons.content_cut},
        ];
      });
    }
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
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
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

  void _handleCartTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Purple Gradient
            CommonGradientContainer(
              colors: [
                const Color(0xFF9370DB),
                const Color(0xFF9370DB),
                const Color(0xFF9370DB).withOpacity(0.95),
                const Color(0xFF9370DB).withOpacity(0.9),
                const Color(0xFF9370DB).withOpacity(0.7),
                const Color(0xFF9370DB).withOpacity(0.5),
                const Color(0xFF9370DB).withOpacity(0.3),
                Colors.white,
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
                      rightIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: _handleCartTap,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _handleProfileTap,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onRightIconTap: _handleProfileTap,
                    ),
                  ),

                  // Search Bar with Filter
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Container(
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
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search 'face wash'",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Filter action
                              },
                              child: const Icon(Icons.tune, color: Colors.grey),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: (_) => _handleSearch(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Main Banner - "SHOP THE BEAUTY TRENDS" - Vertical
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: _buildMainBanner(),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // Just Arrivals Section
            _buildJustArrivalsSection(),

            const SizedBox(height: 30),

            // Category Section
            _buildCategorySection(),

            const SizedBox(height: 30),

            // Most Popular Section
            _buildMostPopularSection(),

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

  Widget _buildMainBanner() {
    return Container(
      width: double.infinity,
      height:
          350, // Increased height significantly for more vertical appearance
      decoration: BoxDecoration(
        color: const Color(0xFF90EE90), // Light green background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Overlay text at top
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30),
            child: const Text(
              'SHOP THE BEAUTY TRENDS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w300,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const Spacer(),
          // Decorative elements arranged vertically
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.local_florist,
                  size: 60,
                  color: Colors.white.withOpacity(0.7),
                ),
                Icon(Icons.eco, size: 50, color: Colors.white.withOpacity(0.7)),
                Icon(
                  Icons.inventory_2_outlined,
                  size: 70,
                  color: Colors.white.withOpacity(0.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildJustArrivalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Just Arrivals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () {
                  // View all action
                },
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: Color(0xFF9370DB),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        // Horizontal Product List
        _isLoading
            ? const SizedBox(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF9370DB),
                    ),
                  ),
                ),
              )
            : _justArrivals.isEmpty
            ? const SizedBox(
                height: 220,
                child: Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              )
            : SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _justArrivals.length,
                  itemBuilder: (context, index) {
                    return _buildHorizontalProductCard(_justArrivals[index]);
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  final categoryName = _categories[index]['name'] ?? '';
                  if (categoryName.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategorySubcategoriesScreen(
                          categoryName: categoryName,
                        ),
                      ),
                    );
                  }
                },
                child: _buildCategoryCard(_categories[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMostPopularSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most Popular',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 15),
          _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF9370DB),
                      ),
                    ),
                  ),
                )
              : _mostPopular.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No products available',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mostPopular.length,
                  itemBuilder: (context, index) {
                    return _buildGridProductCard(_mostPopular[index]);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildHorizontalProductCard(Map<String, dynamic> product) {
    // Extract data from API (handle different field names)
    final imageUrl =
        product['imageUrl'] ??
        product['image_url'] ??
        product['image'] ??
        product['imageUrl'];
    final name =
        product['name'] ?? product['title'] ?? product['product_name'] ?? '';
    final brand =
        product['brand'] ??
        product['manufacturer'] ??
        product['brand_name'] ??
        '';
    final details =
        product['description'] ??
        product['details'] ??
        product['detail'] ??
        product['short_description'] ??
        '';
    final price = _formatPrice(
      product['price'] ??
          product['price_amount'] ??
          product['selling_price'] ??
          '',
    );

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          // Product Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: imageUrl != null && imageUrl.toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF9370DB),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (brand.isNotEmpty)
                  Text(
                    brand,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    // Extract category image from API
    final imageUrl =
        category['imageUrl'] ??
        category['image_url'] ??
        category['image'] ??
        category['icon_url'];
    final name = category['name'] ?? '';
    final icon = category['icon'] as IconData?;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9370DB).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Category Image or Icon
          if (imageUrl != null && imageUrl.toString().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl.toString(),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF9370DB),
                        ),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9370DB).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: icon != null
                        ? Icon(icon, size: 30, color: const Color(0xFF9370DB))
                        : const Icon(
                            Icons.category,
                            size: 30,
                            color: Color(0xFF9370DB),
                          ),
                  );
                },
              ),
            )
          else
            Icon(
              icon ?? Icons.category,
              size: 30,
              color: const Color(0xFF9370DB),
            ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGridProductCard(Map<String, dynamic> product) {
    // Extract data from API (handle different field names)
    final imageUrl =
        product['imageUrl'] ??
        product['image_url'] ??
        product['image'] ??
        product['imageUrl'];
    final name =
        product['name'] ?? product['title'] ?? product['product_name'] ?? '';
    final brand =
        product['brand'] ??
        product['manufacturer'] ??
        product['brand_name'] ??
        '';
    final details =
        product['description'] ??
        product['details'] ??
        product['detail'] ??
        product['short_description'] ??
        '';
    final price = _formatPrice(
      product['price'] ??
          product['price_amount'] ??
          product['selling_price'] ??
          '',
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
          // Product Image
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: imageUrl != null && imageUrl.toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF9370DB),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (brand.isNotEmpty)
                  Text(
                    brand,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to format price
  String _formatPrice(dynamic price) {
    if (price == null || price == '') {
      return '₹0';
    }

    // If price is a number, format it
    if (price is num) {
      return '₹${price.toStringAsFixed(0)}';
    }

    // If price is a string, check if it already has currency symbol
    final priceStr = price.toString().trim();
    if (priceStr.startsWith('₹') ||
        priceStr.startsWith('Rs') ||
        priceStr.startsWith('INR')) {
      return priceStr;
    }

    // Try to parse as number
    try {
      final numValue = double.parse(priceStr);
      return '₹${numValue.toStringAsFixed(0)}';
    } catch (e) {
      // If parsing fails, return as is or with currency symbol
      return priceStr.contains(RegExp(r'[0-9]')) ? '₹$priceStr' : '₹0';
    }
  }
}
