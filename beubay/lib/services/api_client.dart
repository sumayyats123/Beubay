import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Base URL - Update this with your actual API endpoint
  static const String baseUrl =
      'https://api.beubay.com'; // Replace with your API URL

  // Get headers for API requests
  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Add authentication token if needed
      // 'Authorization': 'Bearer $token',
    };
  }

  // Get locations list
  static Future<List<Map<String, dynamic>>> getLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/locations'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching locations: $e');
      return [];
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/profile'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Search services/places
  static Future<List<Map<String, dynamic>>> searchServices(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/search?q=${Uri.encodeComponent(query)}'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error searching services: $e');
      return [];
    }
  }

  // Get user appointments
  static Future<List<Map<String, dynamic>>> getUserAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/appointments'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching appointments: $e');
      return [];
    }
  }

  // Get promotional banners
  static Future<List<Map<String, dynamic>>> getPromotionalBanners() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/banners'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching banners: $e');
      return [];
    }
  }

  // Get service categories
  static Future<List<Map<String, dynamic>>> getServiceCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Get just arrivals products
  static Future<List<Map<String, dynamic>>> getJustArrivals() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/just-arrivals'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching just arrivals: $e');
      return [];
    }
  }

  // Get most popular products
  static Future<List<Map<String, dynamic>>> getMostPopular() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products/most-popular'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching most popular: $e');
      return [];
    }
  }

  // Get cosmetic categories
  static Future<List<Map<String, dynamic>>> getCosmeticCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/cosmetic/categories'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching cosmetic categories: $e');
      return [];
    }
  }

  // Get service detail (salon, spa, or clinic)
  static Future<Map<String, dynamic>?> getServiceDetail(
    String serviceId,
    String serviceType,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/$serviceType/$serviceId'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return Map<String, dynamic>.from(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching service detail: $e');
      return null;
    }
  }

  // Get products by category
  static Future<List<Map<String, dynamic>>> getProductsByCategory(
    String categoryName,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/products/category/${Uri.encodeComponent(categoryName)}'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get products by category with sort parameter
  static Future<List<Map<String, dynamic>>> getProductsByCategoryWithSort(
    String categoryName,
    String sortBy,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/products/category/${Uri.encodeComponent(categoryName)}?sort=$sortBy'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching sorted products by category: $e');
      return [];
    }
  }

  // Get subcategories for a category
  static Future<List<Map<String, dynamic>>> getCategorySubcategories(
    String categoryName,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/api/cosmetic/category/${Uri.encodeComponent(categoryName)}/subcategories'),
        headers: getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('Error fetching category subcategories: $e');
      return [];
    }
  }
}
