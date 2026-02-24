import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = true;

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
      
      // Placeholder data
      setState(() {
        _cartItems = [];
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
      final price = item['price'] ??
          item['price_amount'] ??
          item['selling_price'] ??
          0;
      final quantity = item['quantity'] ?? 1;
      final priceNum = price is num
          ? price.toDouble()
          : double.tryParse(price.toString()) ?? 0;
      total += priceNum * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add items to your cart to see them here',
                        style: TextStyle(
                          fontSize: 14,
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
                        padding: const EdgeInsets.all(20),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          return _buildCartItem(_cartItems[index], index);
                        },
                      ),
                    ),
                    // Total and Checkout Section
                    Container(
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                              Text(
                                _formatPrice(_calculateTotal()),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF9370DB),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to checkout
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Checkout functionality coming soon'),
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
                                'Proceed to Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
    final imageUrl = item['imageUrl'] ??
        item['image_url'] ??
        item['image'] ??
        '';
    final name = item['name'] ?? item['title'] ?? item['product_name'] ?? '';
    final brand = item['brand'] ??
        item['manufacturer'] ??
        item['brand_name'] ??
        '';
    final price = _formatPrice(
      item['price'] ??
          item['price_amount'] ??
          item['selling_price'] ??
          0,
    );
    final quantity = item['quantity'] ?? 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
      child: Row(
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: imageUrl.toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imageUrl.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey,
                          size: 30,
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.grey,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 15),
          // Product Details
          Expanded(
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
                if (brand.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    brand,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9370DB),
                  ),
                ),
              ],
            ),
          ),
          // Quantity Controls
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                color: const Color(0xFF9370DB),
                onPressed: () {
                  setState(() {
                    _cartItems[index]['quantity'] = quantity + 1;
                  });
                },
              ),
              Text(
                '$quantity',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                color: const Color(0xFF9370DB),
                onPressed: () {
                  if (quantity > 1) {
                    setState(() {
                      _cartItems[index]['quantity'] = quantity - 1;
                    });
                  } else {
                    setState(() {
                      _cartItems.removeAt(index);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
