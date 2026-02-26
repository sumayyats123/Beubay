import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/widgets/common_header.dart';
import 'package:beubay/widgets/common_search_section.dart';
import 'package:beubay/widgets/common_promotional_banner.dart';
import 'package:beubay/widgets/common_bottom_nav_bar.dart';
import 'package:beubay/widgets/common_gradient_container.dart';
import 'package:beubay/widgets/common_sort_filter_menu.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/screens/location_picker_screen.dart';
import 'package:beubay/screens/profile_screen.dart';
import 'package:beubay/screens/service_detail_screen.dart';
import 'package:beubay/utils/responsive_helper.dart';

class SpaScreen extends StatefulWidget {
  const SpaScreen({super.key});

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

class _SpaScreenState extends State<SpaScreen> {
  int _currentIndex = 2; // Spa is selected
  String _selectedLocation = 'Bangalore, Karnataka...';

  // API data placeholders - will be populated from API
  List<Map<String, dynamic>> _promotionalBanners = [];
  List<Map<String, dynamic>> _wellnessSpaServices = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromApi();
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
            'title': 'Relax & Rejuvenate',
            'subtitle': 'Premium Spa Services',
            'buttonText': 'Book Spa Session',
            'footerText': 'Get 20% off on first visit',
            'imageUrl': null,
          },
        ];
      });
    }

    // TODO: Load spa services from API
    // _loadWellnessSpaServices();

    // Placeholder spa services for testing
    setState(() {
      _wellnessSpaServices = [
        {
          'title': 'Serenity Spa',
          'description': 'Relaxing massage and wellness treatments',
          'imageUrl': null,
          'distance': '0.5kms',
          'serviceType': 'Premium',
          'rating': '4.7',
          'discount': '25% off',
        },
        {
          'title': 'Wellness Center',
          'description': 'Complete spa and wellness experience',
          'imageUrl': null,
          'distance': '1.0kms',
          'serviceType': 'Luxury',
          'rating': '4.8',
          'discount': '30% off',
        },
        {
          'title': 'Tranquil Spa',
          'description': 'Aromatherapy and relaxation therapies',
          'imageUrl': null,
          'distance': '0.7kms',
          'serviceType': 'Standard',
          'rating': '4.5',
          'discount': '20% off',
        },
      ];
    });
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
      backgroundColor: const Color(0xFFF8F8F8),
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
                  // Top Header Section
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: CommonHeader(
                      selectedLocation: _selectedLocation,
                      onLocationTap: _handleLocationTap,
                      rightIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              CommonSortFilterMenu.show(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
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
                    ),
                  ),

                  // Promotional Banner (Horizontally Scrollable)
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: SizedBox(
                      height: 220,
                      child: _promotionalBanners.isNotEmpty
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
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
                                vertical: 10,
                              ),
                              child: CommonPromotionalBanner(banner: null),
                            ),
                    ),
                  ),

                  // Search Section
                  Transform.translate(
                    offset: const Offset(0, -25),
                    child: const CommonSearchSection(showRightButton: false),
                  ),

                  const SizedBox(height: 0),

                  // Wellness & Spa Section Title and First Container
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.responsiveSpacing(context, 20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: ResponsiveHelper.responsiveSpacing(context, 8),
                            ),
                            child: Text(
                              'WELLNESS & SPA',
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 15)),
                          _buildFirstServiceItem(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Remaining Wellness & Spa Section Content
            _buildRemainingWellnessSpaSection(),

            const SizedBox(height: 100),
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

  Widget _buildFirstServiceItem() {
    // Show only first container inside gradient
    if (_wellnessSpaServices.isNotEmpty) {
      return _buildServiceCard(_wellnessSpaServices[0]);
    }
    return _buildServiceCardPlaceholder();
  }

  Widget _buildRemainingWellnessSpaSection() {
    // Show remaining items outside gradient
    if (_wellnessSpaServices.length <= 1) {
      // Show placeholder containers if no services or only one service
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(2, (index) => _buildServiceCardPlaceholder()),
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
            itemCount: _wellnessSpaServices.length - 1,
            itemBuilder: (context, index) {
              return _buildServiceCard(_wellnessSpaServices[index + 1]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        print('Spa card tapped: ${service['title'] ?? service['name']}');
        print('Service data: $service');
        Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ServiceDetailScreen(service: service, serviceType: 'spa'),
              ),
            )
            .then((_) {
              print('Navigation completed');
            })
            .catchError((error) {
              print('Navigation error: $error');
            });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
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
            // Image with discount tag
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
                          child: Icon(Icons.spa, color: Colors.grey, size: 40),
                        ),
                ),
                // Discount tag
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

            // Service details
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    service['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
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
                  // Metrics
                  Row(
                    children: [
                      // Distance
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey,
                          ),
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
                      // Service Type
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
                      // Rating
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
}
