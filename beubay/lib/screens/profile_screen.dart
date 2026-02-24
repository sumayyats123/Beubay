import 'package:flutter/material.dart';
import 'package:beubay/services/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    final profile = await ApiClient.getUserProfile();
    
    setState(() {
      _userProfile = profile;
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
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userProfile == null
              ? const Center(
                  child: Text(
                    'Failed to load profile',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Profile Picture
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF9370DB),
                          child: _userProfile!['profileImage'] != null
                              ? ClipOval(
                                  child: Image.network(
                                    _userProfile!['profileImage'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                        ),
                        const SizedBox(height: 20),

                        // User Name
                        Text(
                          _userProfile!['name'] ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Email
                        Text(
                          _userProfile!['email'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Profile Details
                        _buildProfileItem('Phone', _userProfile!['phone'] ?? 'N/A'),
                        _buildProfileItem('Address', _userProfile!['address'] ?? 'N/A'),
                        _buildProfileItem('Date of Birth', _userProfile!['dob'] ?? 'N/A'),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
