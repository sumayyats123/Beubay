import 'package:flutter/material.dart';
import 'package:beubay/screens/profile_screen.dart';
import 'package:beubay/screens/help_support_screen.dart';
import 'package:beubay/screens/refund_screen.dart';
import 'package:beubay/screens/wishlist_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          // Heart icon with notification dot
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: () {
                  // TODO: Navigate to wishlist
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF9370DB),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          // Points/Currency icon
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF9370DB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '\$100',
                  style: TextStyle(
                    color: Color(0xFF9370DB),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User Profile Section
            Column(
              children: [
                // Profile Picture
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF9370DB),
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile_placeholder.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                const Text(
                  'Ammulya Jones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                // Email
                Text(
                  'ammulya123@gmail.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Your Informations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Informations',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem('Your Refunds', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RefundScreen(),
                      ),
                    );
                  }),
                  _buildDivider(),
                  _buildMenuItem('Your Wishlist', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishlistScreen(),
                      ),
                    );
                  }),
                  _buildDivider(),
                  _buildMenuItem('E-Gift Cards', () {
                    // TODO: Navigate to gift cards
                  }),
                  _buildDivider(),
                  _buildMenuItem('Help & Support', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  }),
                  _buildDivider(),
                  _buildMenuItem('Profile', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  }),
                  _buildDivider(),
                  _buildMenuItem('Rewards', () {
                    // TODO: Navigate to rewards
                  }),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9370DB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'LOG OUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey[200]);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
