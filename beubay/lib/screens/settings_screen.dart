import 'package:flutter/material.dart';
import 'package:beubay/screens/profile_screen.dart';
import 'package:beubay/screens/help_support_screen.dart';
import 'package:beubay/screens/refund_screen.dart';
import 'package:beubay/screens/wishlist_screen.dart';
import 'package:beubay/utils/responsive_helper.dart';

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
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
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
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 20)),
            // User Profile Section
            Column(
              children: [
                // Profile Picture
                LayoutBuilder(
                  builder: (context, constraints) {
                    final avatarSize = ResponsiveHelper.isMobile(context) ? 100.0 : ResponsiveHelper.isTablet(context) ? 120.0 : 140.0;
                    return Container(
                      width: avatarSize,
                      height: avatarSize,
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
                              child: Icon(
                                Icons.person,
                                size: avatarSize * 0.5,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 16)),
                // User Name
                Text(
                  'Ammulya Jones',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 4)),
                // Email
                Text(
                  'ammulya123@gmail.com',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 14),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Your Informations Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Informations',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 8)),
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
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveSpacing(context, 20),
              ),
              child: SizedBox(
                width: double.infinity,
                height: ResponsiveHelper.isMobile(context) ? 50.0 : ResponsiveHelper.isTablet(context) ? 56.0 : 60.0,
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
                  child: Text(
                    'LOG OUT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.responsiveSpacing(context, 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveHelper.responsiveSpacing(context, 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, mobile: 16),
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: ResponsiveHelper.responsiveFontSize(context, mobile: 20),
            ),
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
