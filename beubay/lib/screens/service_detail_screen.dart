import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/screens/service_selection_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Map<String, dynamic> service;
  final String serviceType; // 'salon', 'spa', or 'clinic'

  const ServiceDetailScreen({
    super.key,
    required this.service,
    required this.serviceType,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _currentImageIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  List<Map<String, dynamic>> _images = [];
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _stylists = [];
  List<Map<String, dynamic>> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load detail data from API based on serviceType
      // final detailData = await ApiClient.getServiceDetail(
      //   widget.service['id'],
      //   widget.serviceType,
      // );

      // Placeholder data structure
      setState(() {
        _detailData = {
          'name': widget.service['title'] ?? 
                  widget.service['name'] ?? 
                  'Service Name',
          'type': widget.service['type'] ?? 'Unisex',
          'price': widget.service['price'] ?? '₹1,200',
          'status': 'Open now',
          'hours': '10.00 AM - 08.00 PM',
          'distance': widget.service['distance'] ?? '0.27Kms',
          'phone': widget.service['phone'] ?? '+91 1234567890',
          'about': widget.service['description'] ?? 
                   widget.service['about'] ??
              'Wayanad\'s first and largest Naturals Unisex salon and Spa. The unisex salon provides high-quality beauty service and hygiene at affordable rates. Our Services; - Skin Care - Hair Care - Body Care......read more',
          'rating': widget.service['rating'] != null 
              ? double.tryParse(widget.service['rating'].toString()) ?? 4.0
              : 4.0,
          'totalRatings': widget.service['totalRatings'] ?? 134,
        };

        final imageUrl = widget.service['imageUrl'] ?? 
                        widget.service['image_url'] ?? 
                        widget.service['image'] ?? 
                        '';
        _images = [
          {'url': imageUrl},
          {'url': imageUrl},
          {'url': imageUrl},
        ];

        _services = [
          {'name': 'Men\'s Grooming', 'icon': Icons.content_cut},
          {'name': 'Hair Care', 'icon': Icons.face},
          {'name': 'Face', 'icon': Icons.face_outlined},
          {'name': 'Massage and Spa', 'icon': Icons.spa},
          {'name': 'Nail', 'icon': Icons.brush},
          {'name': 'Men\'s Grooming', 'icon': Icons.content_cut},
          {'name': 'Hair Care', 'icon': Icons.face},
          {'name': 'Face', 'icon': Icons.face_outlined},
          {'name': 'Massage and Spa', 'icon': Icons.spa},
          {'name': 'Nail', 'icon': Icons.brush},
        ];

        _stylists = [
          {'name': 'Nikhil', 'imageUrl': null},
          {'name': 'Nikhil', 'imageUrl': null},
          {'name': 'Nikhil', 'imageUrl': null},
          {'name': 'Nikhil', 'imageUrl': null},
          {'name': 'Nikhil', 'imageUrl': null},
        ];

        _reviews = [
          {
            'name': 'Nikhil Vishwan',
            'comment': 'Good service',
            'rating': 3,
            'date': 'Visited on 9th May 24',
          },
          {
            'name': 'Abiram vr',
            'comment': 'Good service',
            'rating': 3,
            'date': 'Visited on 9th May 24',
          },
        ];

        _isLoading = false;
      });
    } catch (e) {
      print('Error loading detail data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading || _detailData == null
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9370DB)),
              ),
            )
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Image Carousel Section
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: _buildImageCarousel(),
                      ),
                    ),

                    // Content Section
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Service Name and Info
                          _buildServiceInfo(),

                          const SizedBox(height: 20),

                          // About Section
                          _buildAboutSection(),

                          const SizedBox(height: 20),

                          // Services Section
                          _buildServicesSection(),

                          const SizedBox(height: 20),

                          // Stylists/Doctors Section
                          _buildStylistsSection(),

                          const SizedBox(height: 20),

                          // Reviews Section
                          _buildReviewsSection(),

                          const SizedBox(height: 100), // Space for bottom button
                        ],
                      ),
                    ),
                  ],
                ),
                // Back and Share Buttons Overlay
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  right: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Share functionality
                        print('Share button tapped');
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.share, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBookAppointmentButton(),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: _images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imageUrl = _images[index]['url'];
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: imageUrl != null && imageUrl.toString().isNotEmpty
                  ? Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
            );
          },
        ),
        // Image Indicators
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _images.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentImageIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _detailData!['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${_detailData!['type']} | ${_detailData!['price']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // Status Button
          _buildInfoButton(
            '${_detailData!['status']} | ${_detailData!['hours']}',
            Icons.keyboard_arrow_down,
            () {},
          ),
          const SizedBox(height: 10),
          // Get Direction Button
          _buildInfoButton(
            'Get Direction | ${_detailData!['distance']}',
            Icons.arrow_forward,
            () {
              // Open maps
            },
          ),
          const SizedBox(height: 10),
          // Contact Button
          _buildInfoButton(
            'Contact',
            Icons.phone,
            () {
              // Make call
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF9370DB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _detailData!['about'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              return _buildServiceIcon(_services[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceIcon(Map<String, dynamic> service) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF9370DB).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            service['icon'] as IconData,
            size: 24,
            color: const Color(0xFF9370DB),
          ),
          const SizedBox(height: 5),
          Text(
            service['name'] ?? '',
            style: const TextStyle(
              fontSize: 10,
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

  Widget _buildStylistsSection() {
    final sectionTitle = widget.serviceType == 'clinic'
        ? 'Meet our Doctors'
        : 'Meet our Stylists';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _stylists.length,
              itemBuilder: (context, index) {
                return _buildStylistCard(_stylists[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStylistCard(Map<String, dynamic> stylist) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: stylist['imageUrl'] != null &&
                    stylist['imageUrl'].toString().isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      stylist['imageUrl'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 80,
            height: 50,
            child: Center(
              child: Text(
                stylist['name'] ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A1A),
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews (${_reviews.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 10),
          // Overall Rating
          Row(
            children: [
              _buildStarRating(_detailData!['rating'] ?? 4.0),
              const SizedBox(width: 10),
              Text(
                '${_detailData!['rating']} out of 5',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            '${_detailData!['totalRatings']} total ratings',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          // Individual Reviews
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reviews.length,
            itemBuilder: (context, index) {
              return _buildReviewCard(_reviews[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(review['rating']?.toDouble() ?? 3.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review['comment'] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['date'] ?? '',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              TextButton(
                onPressed: () {
                  // Report review
                },
                child: const Text(
                  'Report',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookAppointmentButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ServiceSelectionScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9370DB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Appointment',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
