import 'package:flutter/material.dart';

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
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${_cartItems.length} items',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
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
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
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
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                ),
                // Total and Checkout Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total amount',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _formatPrice(_calculateTotal()),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
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
                          child: const Text(
                            'Checkout',
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
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF9370DB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        _removeItem(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
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
            const SizedBox(width: 12),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (brand.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      brand,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.remove,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _updateQuantity(index, quantity + 1),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.add, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            // Price
            Text(
              _formatPrice(priceNum),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            // Delete Button
            GestureDetector(
              onTap: () => _removeItem(index),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF9370DB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.delete, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
