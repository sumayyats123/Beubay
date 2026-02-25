import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/screens/product_list_screen.dart';

class CategorySubcategoriesScreen extends StatefulWidget {
  final String categoryName;

  const CategorySubcategoriesScreen({super.key, required this.categoryName});

  @override
  State<CategorySubcategoriesScreen> createState() =>
      _CategorySubcategoriesScreenState();
}

class _CategorySubcategoriesScreenState
    extends State<CategorySubcategoriesScreen> {
  List<Map<String, dynamic>> _subcategories = [];
  bool _isLoading = true;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (_isDisposed || !mounted) return;
    try {
      if (mounted && !_isDisposed) {
        setState(fn);
      }
    } catch (e) {
      // Silently ignore setState errors after dispose
      if (e is FlutterError &&
          (e.message.contains('dispose') || e.message.contains('mounted'))) {
        return;
      }
      // Re-throw other errors
      rethrow;
    }
  }

  Future<void> _loadSubcategories() async {
    if (!mounted) return;

    _safeSetState(() {
      _isLoading = true;
    });

    try {
      final subcategories = await ApiClient.getCategorySubcategories(
        widget.categoryName,
      );

      if (!mounted) return;

      _safeSetState(() {
        // If API returns empty, use placeholder subcategories
        _subcategories = subcategories.isNotEmpty
            ? subcategories
            : _getPlaceholderSubcategories(widget.categoryName);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      print('Error loading subcategories: $e');
      _safeSetState(() {
        _isLoading = false;
        // Add placeholder subcategories based on category name
        _subcategories = _getPlaceholderSubcategories(widget.categoryName);
      });
    }
  }

  List<Map<String, dynamic>> _getPlaceholderSubcategories(String categoryName) {
    // Return placeholder subcategories based on category
    final categoryLower = categoryName.toLowerCase().trim();

    if (categoryLower == 'skincare') {
      return [
        {'name': 'Facewash & Scrubs'},
        {'name': 'Creams & Moisturizers'},
        {'name': 'Sunscreen'},
        {'name': 'Body Lotion'},
        {'name': 'Toner'},
        {'name': 'Serum'},
        {'name': 'Lip Balms'},
        {'name': 'View All'},
      ];
    } else if (categoryLower == 'makeup') {
      return [
        {'name': 'Foundation'},
        {'name': 'Lipstick'},
        {'name': 'Eyeshadow'},
        {'name': 'Mascara'},
        {'name': 'Blush'},
        {'name': 'Concealer'},
        {'name': 'View All'},
      ];
    } else if (categoryLower == 'haircare') {
      return [
        {'name': 'Shampoo'},
        {'name': 'Conditioner'},
        {'name': 'Hair Oil'},
        {'name': 'Hair Mask'},
        {'name': 'Hair Serum'},
        {'name': 'View All'},
      ];
    } else if (categoryLower == 'fragrance') {
      return [
        {'name': 'Perfume'},
        {'name': 'Body Mist'},
        {'name': 'Deodorant'},
        {'name': 'View All'},
      ];
    } else if (categoryLower == 'bodycare') {
      return [
        {'name': 'Body Wash'},
        {'name': 'Body Scrub'},
        {'name': 'Body Cream'},
        {'name': 'Hand Cream'},
        {'name': 'Foot Care'},
        {'name': 'View All'},
      ];
    } else {
      return [
        {'name': 'Subcategory 1'},
        {'name': 'Subcategory 2'},
        {'name': 'Subcategory 3'},
        {'name': 'View All'},
      ];
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            fontFamily: 'serif',
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
          : _subcategories.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No subcategories available',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _subcategories.length,
              itemBuilder: (context, index) {
                return _buildSubcategoryItem(_subcategories[index]);
              },
            ),
    );
  }

  Widget _buildSubcategoryItem(Map<String, dynamic> subcategory) {
    final name = subcategory['name'] ?? '';

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF424242),
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
        onTap: () {
          // Navigate to product list screen with subcategory name
          // If "View All" is selected, use the main category name
          final categoryToUse = name.toLowerCase() == 'view all'
              ? widget.categoryName
              : name;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProductListScreen(categoryName: categoryToUse),
            ),
          );
        },
      ),
    );
  }
}
