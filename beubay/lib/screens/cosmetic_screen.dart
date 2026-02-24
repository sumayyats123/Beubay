import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/widgets/common_header.dart';
import 'package:beubay/widgets/common_search_section.dart';
import 'package:beubay/widgets/common_promotional_banner.dart';
import 'package:beubay/widgets/common_bottom_nav_bar.dart';
import 'package:beubay/widgets/common_gradient_container.dart';
import 'package:beubay/widgets/common_sort_filter_menu.dart';

class CosmeticScreen extends StatefulWidget {
  const CosmeticScreen({super.key});

  @override
  State<CosmeticScreen> createState() => _CosmeticScreenState();
}

class _CosmeticScreenState extends State<CosmeticScreen> {
  int _currentIndex = 4; // Cosmetic is selected
  String _selectedLocation = 'Bangalore, Karnataka...';

  // API data placeholders - will be populated from API
  List<Map<String, dynamic>> _promotionalBanners = [];
  List<Map<String, dynamic>> _cosmeticProducts = [];

  @override
  void initState() {
    super.initState();
    // TODO: Load data from API
    // _loadPromotionalBanners();
    // _loadCosmeticProducts();

    // Placeholder data for cosmetic screen
    _promotionalBanners = [
      {
        'title': 'Premium Cosmetics',
        'subtitle': 'Beauty Products Collection',
        'buttonText': 'Shop Now',
        'footerText': 'Up to 30% off on selected items',
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
      ), // Same background as home screen
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Purple Gradient (Header, Search, Banner)
            CommonGradientContainer(
              colors: [
                const Color(0xFF9370DB),
                const Color(0xFF9370DB),
                const Color(0xFF9370DB).withOpacity(0.9),
                const Color(0xFF9370DB).withOpacity(0.7),
                const Color(0xFF9370DB).withOpacity(0.5),
                const Color(0xFF9370DB).withOpacity(0.3),
                const Color(0xFFF8F8F8),
              ],
              stops: const [0.0, 0.2, 0.35, 0.45, 0.55, 0.72, 0.85],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header Section - inside gradient
                  CommonHeader(
                    selectedLocation: _selectedLocation,
                    onLocationTap: () {
                      // TODO: Show location picker
                    },
                    rightIcon: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.more_vert, color: Colors.white),
                    ),
                    onRightIconTap: () {
                      CommonSortFilterMenu.show(context);
                    },
                  ),

                  // Promotional Banner (Horizontally Scrollable)
                  SizedBox(
                    height: 220,
                    child: _promotionalBanners.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            itemCount: _promotionalBanners.length,
                            itemBuilder: (context, index) {
                              return CommonPromotionalBanner(
                                banner: _promotionalBanners[index],
                                width: MediaQuery.of(context).size.width - 40,
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            child: CommonPromotionalBanner(banner: null),
                          ),
                  ),

                  // Search Section
                  const CommonSearchSection(),

                  const SizedBox(height: 20),

                  // Cosmetic Products Section Title and First Container - inside gradient to spread purple
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: Text(
                            'COSMETIC PRODUCTS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        // Only first container inside gradient
                        _buildFirstProductItem(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Remaining Cosmetic Products Section Content
            _buildRemainingCosmeticProductsSection(),

            const SizedBox(height: 50), // Extra padding at bottom
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

  Widget _buildFirstProductItem() {
    // Show only first container inside gradient
    if (_cosmeticProducts.isNotEmpty) {
      return _buildProductCard(_cosmeticProducts[0]);
    }
    return _buildProductCardPlaceholder();
  }

  Widget _buildRemainingCosmeticProductsSection() {
    // Show remaining items outside gradient
    if (_cosmeticProducts.length <= 1) {
      // Show placeholder containers if no products or only one product
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(2, (index) => _buildProductCardPlaceholder()),
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
            itemCount: _cosmeticProducts.length - 1,
            itemBuilder: (context, index) {
              return _buildProductCard(_cosmeticProducts[index + 1]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
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
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9370DB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    product['discount'] ?? 'Get 20% off',
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
                  product['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product['brand'] ?? '',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  product['price'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9370DB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCardPlaceholder() {
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
}
