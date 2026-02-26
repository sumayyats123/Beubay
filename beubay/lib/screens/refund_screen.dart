import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:beubay/utils/responsive_helper.dart';

class RefundScreen extends StatefulWidget {
  const RefundScreen({super.key});

  @override
  State<RefundScreen> createState() => _RefundScreenState();
}

class _RefundScreenState extends State<RefundScreen> {
  // Sample refund data - in a real app, this would come from an API
  final List<RefundItem> _refunds = [
    RefundItem(
      id: '1',
      productName: 'Jean Jacket',
      orderNumber: '44423',
      date: DateTime(2024, 10, 12),
      amount: 120.00,
      status: RefundStatus.complete,
      imageUrl: null,
    ),
    RefundItem(
      id: '2',
      productName: 'Jean Jacket',
      orderNumber: '44423',
      date: DateTime(2024, 10, 12),
      amount: 120.00,
      status: RefundStatus.complete,
      imageUrl: null,
    ),
    RefundItem(
      id: '3',
      productName: 'Jean Jacket',
      orderNumber: '44423',
      date: DateTime(2024, 9, 15),
      amount: 120.00,
      status: RefundStatus.complete,
      imageUrl: null,
    ),
    RefundItem(
      id: '4',
      productName: 'Jean Jacket',
      orderNumber: '44423',
      date: DateTime(2024, 9, 10),
      amount: 120.00,
      status: RefundStatus.complete,
      imageUrl: null,
    ),
  ];

  double get _totalRefunded {
    return _refunds.fold(0.0, (sum, refund) => sum + refund.amount);
  }

  Map<String, List<RefundItem>> get _groupedRefunds {
    final Map<String, List<RefundItem>> grouped = {};
    for (var refund in _refunds) {
      final key = DateFormat('MMMM yyyy').format(refund.date);
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(refund);
    }
    // Sort each group's items by date (newest first)
    for (var key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.date.compareTo(a.date));
    }
    // Sort groups by date (newest first) - use the first item's date from each group
    final sortedGroups = grouped.entries.toList()
      ..sort((a, b) {
        if (a.value.isEmpty || b.value.isEmpty) return 0;
        return b.value.first.date.compareTo(a.value.first.date);
      });
    return Map.fromEntries(sortedGroups);
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
          'Your Refund',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Refunded Section
            Padding(
              padding: ResponsiveHelper.responsivePadding(context),
              child: Container(
                width: double.infinity,
                padding: ResponsiveHelper.responsivePadding(context),
                decoration: BoxDecoration(
                  color: const Color(0xFF9370DB).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Refunded',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                    Text(
                      '\$ ${_totalRefunded.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 32),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Refund Details Section
            ..._groupedRefunds.entries.map((entry) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.responsiveSpacing(context, 16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
                        top: ResponsiveHelper.responsiveSpacing(context, 8),
                      ),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 18),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ...entry.value.map((refund) => _buildRefundItem(refund)),
                    SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundItem(RefundItem refund) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ResponsiveHelper.responsiveSpacing(context, 12),
      ),
      padding: EdgeInsets.all(
        ResponsiveHelper.responsiveSpacing(context, 12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Product Image Placeholder
          LayoutBuilder(
            builder: (context, constraints) {
              final imageSize = ResponsiveHelper.isMobile(context) ? 80.0 : ResponsiveHelper.isTablet(context) ? 100.0 : 120.0;
              return Container(
                width: imageSize,
                height: imageSize,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: refund.imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      refund.imageUrl!,
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
                  refund.productName,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                Text(
                  'Order #${refund.orderNumber} - ${DateFormat('MMM d').format(refund.date)}',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(refund.status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(refund.status),
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 12),
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(refund.status),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Refund Amount
          Text(
            '\$${refund.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RefundStatus status) {
    switch (status) {
      case RefundStatus.complete:
        return const Color(0xFF4CAF50); // Light green
      case RefundStatus.pending:
        return Colors.orange;
      case RefundStatus.processing:
        return Colors.blue;
      case RefundStatus.failed:
        return Colors.red;
    }
  }

  String _getStatusText(RefundStatus status) {
    switch (status) {
      case RefundStatus.complete:
        return 'Complete';
      case RefundStatus.pending:
        return 'Pending';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.failed:
        return 'Failed';
    }
  }
}

class RefundItem {
  final String id;
  final String productName;
  final String orderNumber;
  final DateTime date;
  final double amount;
  final RefundStatus status;
  final String? imageUrl;

  RefundItem({
    required this.id,
    required this.productName,
    required this.orderNumber,
    required this.date,
    required this.amount,
    required this.status,
    this.imageUrl,
  });
}

enum RefundStatus {
  complete,
  pending,
  processing,
  failed,
}
