import 'package:flutter/material.dart';
import 'package:beubay/services/api_client.dart';

class SearchResultsScreen extends StatefulWidget {
  final String searchQuery;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });

    final results = await ApiClient.searchServices(widget.searchQuery);
    
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search: ${widget.searchQuery}',
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF9370DB),
                          child: const Icon(Icons.business, color: Colors.white),
                        ),
                        title: Text(
                          result['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        subtitle: Text(
                          result['description'] ?? result['address'] ?? '',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to detail screen
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
