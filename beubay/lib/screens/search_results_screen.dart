import 'package:flutter/material.dart';
import 'package:beubay/services/api_client.dart';
import 'package:beubay/utils/responsive_helper.dart';

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
          style: TextStyle(
            color: const Color(0xFF1A1A1A),
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: ResponsiveHelper.responsivePadding(context),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    return Card(
                      margin: EdgeInsets.only(
                        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
                      ),
                      child: ListTile(
                        leading: LayoutBuilder(
                          builder: (context, constraints) {
                            final avatarSize = ResponsiveHelper.isMobile(context) ? 40.0 : ResponsiveHelper.isTablet(context) ? 48.0 : 56.0;
                            return CircleAvatar(
                              radius: avatarSize / 2,
                              backgroundColor: const Color(0xFF9370DB),
                              child: Icon(
                                Icons.business,
                                color: Colors.white,
                                size: avatarSize * 0.6,
                              ),
                            );
                          },
                        ),
                        title: Text(
                          result['name'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                          ),
                        ),
                        subtitle: Text(
                          result['description'] ?? result['address'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                        ),
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
