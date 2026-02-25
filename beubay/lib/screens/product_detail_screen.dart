import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/services/api_client.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  Map<String, dynamic>? _productDetail;
  List<String> _productImages = [];
  int _quantity = 1;
  String _selectedVariant = '100 ML';
  bool _isDescriptionExpanded = false;
  bool _isIdealForExpanded = false;
  bool _isHowToUseExpanded = true;
  final ScrollController _scrollController = ScrollController();
  PageController? _pageController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _currentImageIndex = 0;
    _pageController = PageController(initialPage: 0);
    _loadProductDetail();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    // Hide elements when scrolling past the image carousel (full screen height)
    final screenHeight = MediaQuery.of(context).size.height;
    final isScrolling = offset > screenHeight * 0.1;
    if (isScrolling != _isScrolling) {
      setState(() {
        _isScrolling = isScrolling;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetail() async {
    try {
      final productId =
          widget.product['id'] ??
          widget.product['product_id'] ??
          widget.product['_id'] ??
          '';

      if (productId.toString().isNotEmpty) {
        final detail = await ApiClient.getProductDetail(productId.toString());
        if (detail != null) {
          setState(() {
            _productDetail = detail;
            _loadProductImages(detail);
          });
          return;
        }
      }

      // If API fails, use product data passed to screen
      setState(() {
        _productDetail = widget.product;
        _loadProductImages(widget.product);
      });
    } catch (e) {
      print('Error loading product detail: $e');
      setState(() {
        _productDetail = widget.product;
        _loadProductImages(widget.product);
      });
    }
  }

  void _loadProductImages(Map<String, dynamic> product) {
    _productImages = [];

    // Try to get images array
    if (product['images'] != null && product['images'] is List) {
      final images = product['images'] as List;
      if (images.isNotEmpty) {
        _productImages = List<String>.from(images.map((img) => img.toString()));
      }
    } else if (product['image_urls'] != null && product['image_urls'] is List) {
      final images = product['image_urls'] as List;
      if (images.isNotEmpty) {
        _productImages = List<String>.from(images.map((img) => img.toString()));
      }
    }

    // Add single image if available
    final singleImage =
        product['imageUrl'] ?? product['image_url'] ?? product['image'] ?? '';
    if (singleImage.toString().isNotEmpty &&
        !_productImages.contains(singleImage)) {
      _productImages.insert(0, singleImage.toString());
    }

    // If no images or only one image, add placeholder images for different angles
    if (_productImages.isEmpty || _productImages.length == 1) {
      // Create placeholder images for different angles: front, back, left, right
      _productImages = [
        'front', // Front view
        'back', // Back view
        'left', // Left side view
        'right', // Right side view
      ];
    }
  }

  Widget _buildProductImage(String imageUrl, int index) {
    // Handle placeholder images for different angles
    if (imageUrl == 'front' ||
        imageUrl == 'back' ||
        imageUrl == 'left' ||
        imageUrl == 'right' ||
        imageUrl == 'placeholder') {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 200, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            _getAngleLabel(imageUrl),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    // Real image from URL
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9370DB)),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 200,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                _getAngleLabel(imageUrl),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getAngleLabel(String imageUrl) {
    switch (imageUrl) {
      case 'front':
        return 'Front View';
      case 'back':
        return 'Back View';
      case 'left':
        return 'Left Side';
      case 'right':
        return 'Right Side';
      default:
        return 'Product Image';
    }
  }

  String _formatPrice(dynamic price) {
    if (price == null || price == '') {
      return '₹0';
    }

    if (price is num) {
      return '₹${price.toStringAsFixed(0)}';
    }

    final priceStr = price.toString().trim();
    if (priceStr.startsWith('₹') ||
        priceStr.startsWith('Rs') ||
        priceStr.startsWith('INR')) {
      return priceStr;
    }

    try {
      final numValue = double.parse(priceStr);
      return '₹${numValue.toStringAsFixed(0)}';
    } catch (e) {
      return priceStr.contains(RegExp(r'[0-9]')) ? '₹$priceStr' : '₹0';
    }
  }

  void _handleShare() {
    final product = _productDetail ?? widget.product;
    final productName =
        product['name'] ??
        product['title'] ??
        product['product_name'] ??
        'Product Name';

    // Share functionality - you can integrate with share_plus package if needed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $productName'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAddToCart() {
    // TODO: Add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    final product = _productDetail ?? widget.product;
    final productName =
        product['name'] ??
        product['title'] ??
        product['product_name'] ??
        'Product Name';
    final productDescription =
        product['description'] ??
        product['short_description'] ??
        product['details'] ??
        '';
    final originalPrice =
        product['original_price'] ??
        product['mrp'] ??
        product['list_price'] ??
        '';
    final sellingPrice = _formatPrice(
      product['price'] ??
          product['selling_price'] ??
          product['price_amount'] ??
          '',
    );
    final rating = product['rating'] ?? product['average_rating'] ?? 5.0;
    final reviewsCount =
        product['reviews_count'] ?? product['total_reviews'] ?? 1223;

    return Scaffold(
      backgroundColor: const Color(0xFF9370DB),
      body: Stack(
        children: [
          // Scrollable Content with Purple Gradient
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              // Allow horizontal scrolling for PageView
              return false;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                // Image Carousel Section - Full Height
                SliverToBoxAdapter(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF9370DB), Color(0xFF9370DB)],
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Image Carousel
                        _productImages.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 200,
                                  color: Colors.white,
                                ),
                              )
                            : _pageController != null
                            ? GestureDetector(
                                // Allow horizontal swipes for PageView
                                behavior: HitTestBehavior.opaque,
                                child: PageView.builder(
                                  controller: _pageController!,
                                  physics: const PageScrollPhysics(),
                                  allowImplicitScrolling: false,
                                  onPageChanged: (index) {
                                    setState(() {
                                      if (index < _productImages.length) {
                                        _currentImageIndex = index;
                                      }
                                    });
                                  },
                                  itemCount: _productImages.length,
                                  itemBuilder: (context, index) {
                                    if (index >= _productImages.length) {
                                      return const SizedBox.shrink();
                                    }
                                    final imageUrl = _productImages[index];
                                    return Container(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: _buildProductImage(
                                          imageUrl,
                                          index,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                        // White Bottom Bar with Name, Details, Price and Cart Icon - Single Unified Section
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                  20,
                                  24,
                                  20,
                                  24 + MediaQuery.of(context).padding.bottom,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 18),
                                    // Name and Price on same row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            productName,
                                            style: const TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          sellingPrice,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF9370DB),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Down Arrow at bottom
                                    Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          _scrollController.animateTo(
                                            MediaQuery.of(context).size.height,
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: const Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Color(0xFF9370DB),
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Cart Icon positioned at top right, half in slide bar, half in background
                              Positioned(
                                top: -24,
                                right: 30,
                                child: InkWell(
                                  onTap: _handleAddToCart,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: const BoxDecoration(
                                      color: Colors.black87,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Page Indicators (Dots) - Above the bottom bar
                        if (_productImages.isNotEmpty && !_isScrolling)
                          Positioned(
                            bottom: 250,
                            left: 0,
                            right: 0,
                            child: IgnorePointer(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  _productImages.length,
                                  (index) => Container(
                                    width: _currentImageIndex == index ? 10 : 8,
                                    height: _currentImageIndex == index
                                        ? 10
                                        : 8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentImageIndex == index
                                          ? const Color(0xFFFFD700)
                                          : const Color(
                                              0xFFFFD700,
                                            ).withOpacity(0.3),
                                      boxShadow: _currentImageIndex == index
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFFFD700,
                                                ).withOpacity(0.5),
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Product Details Section (White) - Only shows after scrolling
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productDescription.isNotEmpty
                                    ? productDescription
                                    : 'A daily, gentle exfoliating, acne fighting face cleanser. It contains lha + aha (salicylic acid + capryloyl salicylic acid) in 2h concentration...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                                maxLines: _isDescriptionExpanded ? null : 3,
                                overflow: _isDescriptionExpanded
                                    ? TextOverflow.visible
                                    : TextOverflow.ellipsis,
                              ),
                              if (productDescription.length > 100)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isDescriptionExpanded =
                                          !_isDescriptionExpanded;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    _isDescriptionExpanded ? 'less' : 'more',
                                    style: const TextStyle(
                                      color: Color(0xFF9370DB),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Choose Variants
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CHOOSE VARIANTS',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    ['100 ML', '50 ML', '200 ML', '250 ML'].map(
                                      (variant) {
                                        final isSelected =
                                            _selectedVariant == variant;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedVariant = variant;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFF9370DB)
                                                  : Colors.white,
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xFF9370DB)
                                                    : Colors.grey[300]!,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              variant,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Ideal For Accordion
                        _buildAccordion(
                          title: 'Ideal For',
                          isExpanded: _isIdealForExpanded,
                          onTap: () {
                            setState(() {
                              _isIdealForExpanded = !_isIdealForExpanded;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Oily skin, Acne-prone skin, Combination skin',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        // How to Use Accordion
                        _buildAccordion(
                          title: 'How to Use',
                          isExpanded: _isHowToUseExpanded,
                          onTap: () {
                            setState(() {
                              _isHowToUseExpanded = !_isHowToUseExpanded;
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Apply on wet face. Pour an appropriate quantity into wet hands, rub together into a light lather, and massage into face. Rinse thoroughly.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'When to use: Use AM & PM. Everyday.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // You might also like
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'You might also like',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(right: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                      topLeft: Radius.circular(
                                                        12,
                                                      ),
                                                      topRight: Radius.circular(
                                                        12,
                                                      ),
                                                    ),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.inventory_2_outlined,
                                                  size: 60,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Glow Serum',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF1A1A1A),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '₹1299',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Bottom Bar with Quantity and Add to Cart
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            child: Row(
                              children: [
                                // Quantity Selector
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          if (_quantity > 1) {
                                            setState(() {
                                              _quantity--;
                                            });
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                      ),
                                      Container(
                                        width: 40,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$_quantity',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 20),
                                        onPressed: () {
                                          setState(() {
                                            _quantity++;
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 40,
                                          minHeight: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Add to Cart Button
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _handleAddToCart,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF9370DB),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'ADD TO CART',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
              ],
            ),
          ),
          // Top Navigation Buttons
          if (!_isScrolling)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // Share Icon
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _handleShare,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9370DB),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
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

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) child,
        ],
      ),
    );
  }
}
