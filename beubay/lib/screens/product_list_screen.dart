import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/services/api_client.dart';
import 'dart:async';
import 'package:beubay/widgets/common_bottom_nav_bar.dart';
import 'package:beubay/screens/cart_screen.dart';
import 'package:beubay/screens/settings_screen.dart';
import 'package:beubay/screens/product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String categoryName;

  const ProductListScreen({super.key, required this.categoryName});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _allProducts =
      []; // Store all products for filtering
  bool _isLoading = true;
  int _currentIndex = 4; // Cosmetic is selected
  String _selectedSortOption = 'Bestselling'; // Default sort option

  // Filter state
  double _minPrice = 100;
  double _maxPrice = 1000;
  double _currentMinPrice = 100;
  double _currentMaxPrice = 1000;
  String _selectedSize = 'All';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  Future<void> _loadProducts() async {
    if (!mounted) return;

    _safeSetState(() {
      _isLoading = true;
    });

    try {
      final products = await ApiClient.getProductsByCategory(
        widget.categoryName,
      );

      if (!mounted) return;

      _safeSetState(() {
        // If products are empty, add placeholder products for testing
        if (products.isEmpty) {
          _products = _getPlaceholderProducts();
          _allProducts = List.from(_products);
        } else {
          _products = products;
          _allProducts = List.from(products);
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      print('Error loading products: $e');
      _safeSetState(() {
        _isLoading = false;
        // Add placeholder data for testing
        _products = _getPlaceholderProducts();
        _allProducts = List.from(_products);
      });
    }
  }

  List<Map<String, dynamic>> _getPlaceholderProducts() {
    return [
      {
        'id': '1',
        'name': 'Salicylic Acid + LHA 2% Cleanser',
        'brand': 'The Ordinary',
        'price': '1299',
        'original_price': '1800',
        'imageUrl': null,
        'description': 'A gentle exfoliating cleanser with salicylic acid',
        'images': [],
        'size': '100 ml',
      },
      {
        'id': '2',
        'name': 'Glow Serum',
        'brand': 'The Ordinary',
        'price': '1299',
        'original_price': '1500',
        'imageUrl': null,
        'description': 'Brightening serum for radiant skin',
        'images': [],
        'size': '50 ml',
      },
      {
        'id': '3',
        'name': 'Hydrating Face Wash',
        'brand': 'CeraVe',
        'price': '899',
        'original_price': '1200',
        'imageUrl': null,
        'description': 'Moisturizing cleanser for dry skin',
        'images': [],
        'size': '236 ml',
      },
      {
        'id': '4',
        'name': 'Vitamin C Brightening Scrub',
        'brand': 'Neutrogena',
        'price': '1499',
        'original_price': '2000',
        'imageUrl': null,
        'description': 'Exfoliating scrub with vitamin C',
        'images': [],
        'size': '100 ml',
      },
      {
        'id': '5',
        'name': 'Gentle Exfoliating Cleanser',
        'brand': 'Cetaphil',
        'price': '799',
        'original_price': '1100',
        'imageUrl': null,
        'description': 'Daily exfoliating face wash',
        'images': [],
        'size': '150 ml',
      },
      {
        'id': '6',
        'name': 'Charcoal Detox Scrub',
        'brand': 'Garnier',
        'price': '599',
        'original_price': '800',
        'imageUrl': null,
        'description': 'Deep cleansing charcoal scrub',
        'images': [],
        'size': '100 ml',
      },
    ];
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

  void _handleCartTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CartScreen()),
    );
  }

  void _handleProfileTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
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
                _showSortModal();
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_list, color: Color(0xFF9370DB)),
              title: const Text('Filter'),
              onTap: () {
                Navigator.pop(context);
                _showFilterModal();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showSortModal() {
    String tempSelectedOption = _selectedSortOption;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header with title and close button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sort by',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Sort Options
                Expanded(
                  child: ListView(
                    children: [
                      _buildSortOptionInModal(
                        'Bestselling',
                        tempSelectedOption,
                        (option) {
                          setModalState(() {
                            tempSelectedOption = option;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      _buildSortOptionInModal(
                        'New Arrivals',
                        tempSelectedOption,
                        (option) {
                          setModalState(() {
                            tempSelectedOption = option;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      _buildSortOptionInModal(
                        'Low to High',
                        tempSelectedOption,
                        (option) {
                          setModalState(() {
                            tempSelectedOption = option;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      _buildSortOptionInModal(
                        'High to Low',
                        tempSelectedOption,
                        (option) {
                          setModalState(() {
                            tempSelectedOption = option;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                // Apply Button
                Container(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _selectedSortOption = tempSelectedOption;
                        });
                        Navigator.pop(context);
                        await _applySort();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9370DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortOptionInModal(
    String option,
    String selectedOption,
    Function(String) onTap,
  ) {
    final isSelected = selectedOption == option;
    return InkWell(
      onTap: () {
        onTap(option);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              option,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF9370DB),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
    double tempMinPrice = _currentMinPrice;
    double tempMaxPrice = _currentMaxPrice;
    String tempSelectedSize = _selectedSize;

    // Calculate min and max from all products
    double calculatedMinPrice = _minPrice;
    double calculatedMaxPrice = _maxPrice;

    if (_allProducts.isNotEmpty) {
      final prices = _allProducts.map((p) => _getPriceValue(p)).toList();
      prices.removeWhere((p) => p == 0);
      if (prices.isNotEmpty) {
        calculatedMinPrice = prices.reduce((a, b) => a < b ? a : b);
        calculatedMaxPrice = prices.reduce((a, b) => a > b ? a : b);
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.65,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Header with title and close button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Filter Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Price Section
                        const Text(
                          'Price',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Price Range Display
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${tempMinPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '₹${tempMaxPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Price Slider
                        RangeSlider(
                          values: RangeValues(tempMinPrice, tempMaxPrice),
                          min: calculatedMinPrice,
                          max: calculatedMaxPrice,
                          divisions: 100,
                          activeColor: const Color(0xFF9370DB),
                          inactiveColor: Colors.grey[300]!,
                          onChanged: (RangeValues values) {
                            setModalState(() {
                              tempMinPrice = values.start;
                              tempMaxPrice = values.end;
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        // Size Section
                        const Text(
                          'Size',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Size Buttons
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _buildSizeButton('All', tempSelectedSize, () {
                              setModalState(() {
                                tempSelectedSize = 'All';
                              });
                            }),
                            _buildSizeButton('20 ml', tempSelectedSize, () {
                              setModalState(() {
                                tempSelectedSize = '20 ml';
                              });
                            }),
                            _buildSizeButton('50 ml', tempSelectedSize, () {
                              setModalState(() {
                                tempSelectedSize = '50 ml';
                              });
                            }),
                            _buildSizeButton('100 ml', tempSelectedSize, () {
                              setModalState(() {
                                tempSelectedSize = '100 ml';
                              });
                            }),
                            _buildSizeButton('250 ml', tempSelectedSize, () {
                              setModalState(() {
                                tempSelectedSize = '250 ml';
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Clear Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                tempMinPrice = calculatedMinPrice;
                                tempMaxPrice = calculatedMaxPrice;
                                tempSelectedSize = 'All';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Apply Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentMinPrice = tempMinPrice;
                                _currentMaxPrice = tempMaxPrice;
                                _selectedSize = tempSelectedSize;
                              });
                              Navigator.pop(context);
                              _applyFilter();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9370DB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildSizeButton(
    String size,
    String selectedSize,
    VoidCallback onTap,
  ) {
    final isSelected = selectedSize == size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF9370DB) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF9370DB) : Colors.grey[300]!,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          size,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _applyFilter() {
    setState(() {
      _isLoading = true;
    });

    List<Map<String, dynamic>> filteredProducts = _allProducts.where((product) {
      // Filter by price
      final price = _getPriceValue(product);
      if (price < _currentMinPrice || price > _currentMaxPrice) {
        return false;
      }

      // Filter by size
      if (_selectedSize != 'All') {
        final productSize =
            product['size'] ?? product['volume'] ?? product['capacity'] ?? '';
        if (productSize.toString().toLowerCase() !=
            _selectedSize.toLowerCase()) {
          return false;
        }
      }

      return true;
    }).toList();

    setState(() {
      _products = filteredProducts;
      _isLoading = false;
    });
  }

  Future<void> _applySort() async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Try to fetch sorted data from backend first
      List<Map<String, dynamic>> sortedProducts = [];

      // Map sort option to backend parameter
      String sortParam = '';
      switch (_selectedSortOption) {
        case 'Bestselling':
          sortParam = 'bestselling';
          break;
        case 'New Arrivals':
          sortParam = 'new_arrivals';
          break;
        case 'Low to High':
          sortParam = 'price_asc';
          break;
        case 'High to Low':
          sortParam = 'price_desc';
          break;
      }

      // Try to fetch sorted products from API
      try {
        final response = await ApiClient.getProductsByCategoryWithSort(
          widget.categoryName,
          sortParam,
        );
        sortedProducts = response;
      } catch (e) {
        // If API doesn't support sorting, sort locally
        print('Backend sort not available, sorting locally: $e');
        sortedProducts = List.from(_products);
        _sortProductsLocally(sortedProducts);
      }

      if (!mounted) return;

      setState(() {
        _products = sortedProducts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error applying sort: $e');
      if (!mounted) return;

      // Fallback to local sorting
      List<Map<String, dynamic>> sortedProducts = List.from(_products);
      _sortProductsLocally(sortedProducts);

      setState(() {
        _products = sortedProducts;
        _isLoading = false;
      });
    }
  }

  void _sortProductsLocally(List<Map<String, dynamic>> products) {
    switch (_selectedSortOption) {
      case 'Bestselling':
        // Sort by bestseller field if available, otherwise keep original order
        products.sort((a, b) {
          final bestsellerA = a['bestseller'] ?? a['is_bestseller'] ?? 0;
          final bestsellerB = b['bestseller'] ?? b['is_bestseller'] ?? 0;
          if (bestsellerA is bool && bestsellerB is bool) {
            return bestsellerB ? 1 : (bestsellerA ? -1 : 0);
          }
          return (bestsellerB as num).compareTo(bestsellerA as num);
        });
        break;
      case 'New Arrivals':
        // Sort by newest first
        products.sort((a, b) {
          final dateA =
              a['created_at'] ??
              a['createdAt'] ??
              a['date'] ??
              a['added_date'] ??
              '';
          final dateB =
              b['created_at'] ??
              b['createdAt'] ??
              b['date'] ??
              b['added_date'] ??
              '';
          return dateB.toString().compareTo(dateA.toString());
        });
        break;
      case 'Low to High':
        products.sort((a, b) {
          final priceA = _getPriceValue(a);
          final priceB = _getPriceValue(b);
          return priceA.compareTo(priceB);
        });
        break;
      case 'High to Low':
        products.sort((a, b) {
          final priceA = _getPriceValue(a);
          final priceB = _getPriceValue(b);
          return priceB.compareTo(priceA);
        });
        break;
    }
  }

  double _getPriceValue(Map<String, dynamic> product) {
    final price =
        product['price'] ??
        product['price_amount'] ??
        product['selling_price'] ??
        '0';

    if (price is num) {
      return price.toDouble();
    }

    final priceStr = price
        .toString()
        .replaceAll('₹', '')
        .replaceAll(',', '')
        .trim();
    try {
      return double.parse(priceStr);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom Header
          Column(
            children: [
              // Top Row: Back Arrow (left) and Sort, Cart, Profile (right) - at very top
              SafeArea(
                bottom: false,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // Back Arrow (top left, moved more to left)
                      Transform.translate(
                        offset: const Offset(-16, 0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const Spacer(),
                      // Sort/Filter Icon (combined)
                      IconButton(
                        icon: const Icon(Icons.tune, color: Colors.black),
                        onPressed: _showSortFilterMenu,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      // Cart Icon
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.black,
                        ),
                        onPressed: _handleCartTap,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(width: 8),
                      // Profile Icon
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.black),
                        onPressed: _handleProfileTap,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              // Second Row: Title and Product Count (same row)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    // Title (starts from left, same position as back arrow would be)
                    Expanded(
                      child: Text(
                        widget.categoryName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Product Count (aligned to right, under cart/profile)
                    Text(
                      _isLoading
                          ? 'Loading...'
                          : '${_products.length} products',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Product Grid
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF9370DB),
                      ),
                    ),
                  )
                : _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No products available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(_products[index]);
                    },
                  ),
          ),
        ],
      ),
      // Bottom Navigation Bar
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

  Widget _buildProductCard(Map<String, dynamic> product) {
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
    final price = _formatPrice(
      product['price'] ??
          product['price_amount'] ??
          product['selling_price'] ??
          '',
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: imageUrl != null && imageUrl.toString().isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
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
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Brand/Details
                  if (brand.isNotEmpty)
                    Text(
                      brand,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  // Price
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
      ),
    );
  }
}
