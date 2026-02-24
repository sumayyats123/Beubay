import 'package:flutter/material.dart';

class CommonSortFilterMenu {
  static void show(BuildContext context) {
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
                // TODO: Show sort options
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_list, color: Color(0xFF9370DB)),
              title: const Text('Filter'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show filter options
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
