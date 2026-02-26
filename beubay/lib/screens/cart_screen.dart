import 'package:flutter/material.dart';
import 'package:beubay/utils/responsive_helper.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;
  Map<int, bool> _showDeleteButton = {};

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Load cart items from API
      // final cartItems = await ApiClient.getCartItems();

      // Placeholder data for testing
      setState(() {
        _cartItems = [
          {
            'name': 'Glow Serum',
            'brand': 'The Ordinary',
            'price': 1299,
            'quantity': 1,
            'image': '',
          },
          {
            'name': 'Glow Serum',
            'brand': 'The Ordinary',
            'price': 1299,
            'quantity': 1,
            'image': '',
          },
        ];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading cart items: $e');
      setState(() {
        _isLoading = false;
      });
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

  double _calculateTotal() {
    double total = 0;
    for (var item in _cartItems) {
      final price =
          item['price'] ?? item['price_amount'] ?? item['selling_price'] ?? 0;
      final quantity = item['quantity'] ?? 1;
      final priceNum = price is num
          ? price.toDouble()
          : double.tryParse(price.toString()) ?? 0;
      total += priceNum * quantity;
    }
    return total;
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
      _showDeleteButton.remove(index);
    });
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(index);
    } else {
      setState(() {
        _cartItems[index]['quantity'] = newQuantity;
      });
    }
  }

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
        title: Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_cartItems.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                right: ResponsiveHelper.responsiveSpacing(context, 16),
              ),
              child: Center(
                child: Text(
                  '${_cartItems.length} items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9370DB)),
              ),
            )
          : _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: ResponsiveHelper.isMobile(context) ? 80.0 : ResponsiveHelper.isTablet(context) ? 100.0 : 120.0,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 10)),
                  Text(
                    'Add items to your cart to see them here',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.responsiveSpacing(context, 20),
                      vertical: ResponsiveHelper.responsiveSpacing(context, 16),
                    ),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(_cartItems[index], index);
                    },
                  ),
                ),
                // Divider
                Container(
                  height: 1,
                  color: const Color(0xFF9370DB),
                  margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsiveSpacing(context, 20),
                  ),
                ),
                // Total and Checkout Section
                Container(
                  padding: ResponsiveHelper.responsivePadding(context),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total amount',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _formatPrice(_calculateTotal()),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
                      SizedBox(
                        width: double.infinity,
                        height: ResponsiveHelper.isMobile(context) ? 50.0 : ResponsiveHelper.isTablet(context) ? 56.0 : 60.0,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Navigate to checkout
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Checkout functionality coming soon',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9370DB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                              fontWeight: FontWeight.bold,
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
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    final imageUrl =
        item['imageUrl'] ?? item['image_url'] ?? item['image'] ?? '';
    final name = item['name'] ?? item['title'] ?? item['product_name'] ?? '';
    final brand =
        item['brand'] ?? item['manufacturer'] ?? item['brand_name'] ?? '';
    final price =
        item['price'] ?? item['price_amount'] ?? item['selling_price'] ?? 0;
    final quantity = item['quantity'] ?? 1;
    final priceNum = price is num
        ? price.toDouble()
        : double.tryParse(price.toString()) ?? 0;

    return Dismissible(
      key: Key('cart_item_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: ResponsiveHelper.responsiveSpacing(context, 20),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF9370DB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: ResponsiveHelper.responsiveFontSize(context, mobile: 28),
        ),
      ),
      onDismissed: (direction) {
        _removeItem(index);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveHelper.responsiveSpacing(context, 16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            LayoutBuilder(
              builder: (context, constraints) {
                final imageSize = ResponsiveHelper.isMobile(context) ? 80.0 : ResponsiveHelper.isTablet(context) ? 100.0 : 120.0;
                return Container(
                  width: imageSize,
                  height: imageSize,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageUrl.toString().isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl.toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey,
                            size: imageSize * 0.375,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey,
                      size: imageSize * 0.375,
                    ),
                );
              },
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (brand.isNotEmpty) ...[
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                    Text(
                      brand,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Quantity Controls
            Row(
              children: [
                GestureDetector(
                  onTap: () => _updateQuantity(index, quantity - 1),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final btnSize = ResponsiveHelper.isMobile(context) ? 32.0 : 36.0;
                      return Container(
                        width: btnSize,
                        height: btnSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.remove,
                          size: btnSize * 0.56,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsiveSpacing(context, 12),
                  ),
                  child: Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _updateQuantity(index, quantity + 1),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final btnSize = ResponsiveHelper.isMobile(context) ? 32.0 : 36.0;
                      return Container(
                        width: btnSize,
                        height: btnSize,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.add,
                          size: btnSize * 0.56,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
            // Price
            Text(
              _formatPrice(priceNum),
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(width: ResponsiveHelper.responsiveSpacing(context, 12)),
            // Delete Button
            GestureDetector(
              onTap: () => _removeItem(index),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final btnSize = ResponsiveHelper.isMobile(context) ? 48.0 : ResponsiveHelper.isTablet(context) ? 56.0 : 64.0;
                  return Container(
                    width: btnSize,
                    height: btnSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFF9370DB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: btnSize * 0.5,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
