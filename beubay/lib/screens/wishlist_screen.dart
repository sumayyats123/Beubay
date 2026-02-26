import 'package:flutter/material.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Sample wishlist data - in a real app, this would come from an API
  List<WishlistItem> _wishlistItems = [
    WishlistItem(
      id: '1',
      productName: 'Jean Jacket',
      price: 5.00,
      rating: 4.5,
      size: 'M',
      category: 'Running',
      stockStatus: StockStatus.inStock,
      imageUrl: null,
      isNew: true,
    ),
    WishlistItem(
      id: '2',
      productName: 'Jean Jacket',
      price: 5.00,
      rating: 4.5,
      size: 'M',
      category: 'Running',
      stockStatus: StockStatus.lowStock,
      imageUrl: null,
      isNew: true,
    ),
    WishlistItem(
      id: '3',
      productName: 'Jean Jacket',
      price: 5.00,
      rating: 4.5,
      size: 'M',
      category: 'Running',
      stockStatus: StockStatus.outOfStock,
      imageUrl: null,
      isNew: true,
    ),
  ];

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
          'Your Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wishlist Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Fashion Wishlist',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${_wishlistItems.length} items',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Wishlist Items
            ..._wishlistItems.map((item) => _buildWishlistCard(item)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistCard(WishlistItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // New Badge
                if (item.isNew)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                // Product Name
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Price
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Size Info
                Text(
                  '${item.category} - size ${item.size}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Stock Status
                Text(
                  _getStockStatusText(item.stockStatus),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStockStatusColor(item.stockStatus),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right side - Product Image
          Column(
            children: [
              Stack(
                children: [
                  // Product Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: item.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    color: Colors.grey,
                                    size: 32,
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: Colors.grey,
                              size: 32,
                            ),
                          ),
                  ),
                  // Delete Icon
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeFromWishlist(item.id),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Action Button
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: item.stockStatus == StockStatus.outOfStock
                      ? () => _handleNotify(item)
                      : () => _handleAddToCart(item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.stockStatus == StockStatus.outOfStock
                        ? Colors.grey[400]
                        : Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    item.stockStatus == StockStatus.outOfStock
                        ? 'Notify'
                        : 'Add',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStockStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.lowStock:
        return Colors.red;
      case StockStatus.outOfStock:
        return Colors.grey;
    }
  }

  String _getStockStatusText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
    }
  }

  void _removeFromWishlist(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: const Text('Are you sure you want to remove this item from your wishlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _wishlistItems.removeWhere((item) => item.id == itemId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item removed from wishlist'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddToCart(WishlistItem item) {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.productName} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleNotify(WishlistItem item) {
    // TODO: Implement notify when back in stock functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You will be notified when ${item.productName} is back in stock'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class WishlistItem {
  final String id;
  final String productName;
  final double price;
  final double rating;
  final String size;
  final String category;
  final StockStatus stockStatus;
  final String? imageUrl;
  final bool isNew;

  WishlistItem({
    required this.id,
    required this.productName,
    required this.price,
    required this.rating,
    required this.size,
    required this.category,
    required this.stockStatus,
    this.imageUrl,
    required this.isNew,
  });
}

enum StockStatus {
  inStock,
  lowStock,
  outOfStock,
}
