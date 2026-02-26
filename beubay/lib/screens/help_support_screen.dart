import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // FAQ Data
  final List<FAQItem> _faqItems = [
    FAQItem(
      question: 'How do I manage my notifications?',
      answer:
          'To manage notifications, go to "Settings", select "Notification Settings" and customize your preferences.',
    ),
    FAQItem(
      question: 'How do I start a guided meditation session?',
      answer:
          'To start a guided meditation session, navigate to the Meditation section, choose a session, and tap "Start Session".',
    ),
    FAQItem(
      question: 'How do I join a support group?',
      answer:
          'To join a support group, go to the Community section, browse available groups, and tap "Join" on the group you\'re interested in.',
    ),
    FAQItem(
      question: 'Is my data safe and private?',
      answer:
          'Yes, we take your privacy seriously. All your data is encrypted and stored securely. We never share your personal information with third parties.',
    ),
  ];

  List<FAQItem> get _filteredFAQItems {
    if (_searchQuery.isEmpty) {
      return _faqItems;
    }
    return _faqItems
        .where(
          (item) =>
              item.question.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              item.answer.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // TODO: Add menu options
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF9370DB),
          indicatorWeight: 3,
          labelColor: const Color(0xFF9370DB),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'FAQ'),
            Tab(text: 'Contact Us'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFAQTab(), _buildContactUsTab()],
      ),
    );
  }

  Widget _buildFAQTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                suffixIcon: IconButton(
                  icon: Icon(Icons.tune, color: Colors.grey[600]),
                  onPressed: () {
                    // TODO: Implement filter functionality
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
        // FAQ List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filteredFAQItems.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(_filteredFAQItems[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFAQItem(FAQItem item) {
    return _ExpandableFAQItem(faqItem: item);
  }

  Widget _buildContactUsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildContactItem(
          title: 'Customer Services',
          icon: Icons.headset,
          onTap: () {
            // TODO: Implement customer service contact
            _showContactDialog('Customer Services');
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          title: 'Whatsapp',
          icon: Icons.chat,
          iconColor: const Color(0xFF25D366), // WhatsApp green
          onTap: () {
            _launchWhatsApp();
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          title: 'Website',
          icon: Icons.language,
          onTap: () {
            _launchWebsite();
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          title: 'Facebook',
          icon: Icons.people,
          iconColor: const Color(0xFF1877F2), // Facebook blue
          onTap: () {
            _launchFacebook();
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          title: 'Twitter',
          icon: Icons.alternate_email,
          iconColor: const Color(0xFF1DA1F2), // Twitter blue
          onTap: () {
            _launchTwitter();
          },
        ),
        const SizedBox(height: 12),
        _buildContactItem(
          title: 'Instagram',
          icon: Icons.camera_alt,
          iconColor: const Color(0xFFE4405F), // Instagram pink
          onTap: () {
            _launchInstagram();
          },
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required String title,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF9370DB)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF9370DB),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          'Contact us at support@beubay.com or call +1-800-123-4567',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWhatsApp() async {
    try {
      final uri = Uri.parse('https://wa.me/1234567890');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch WhatsApp');
      }
    } catch (e) {
      _showErrorSnackBar('Error: Please restart the app to use this feature');
    }
  }

  Future<void> _launchWebsite() async {
    try {
      final uri = Uri.parse('https://www.beubay.com');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch website');
      }
    } catch (e) {
      _showErrorSnackBar('Error: Please restart the app to use this feature');
    }
  }

  Future<void> _launchFacebook() async {
    try {
      final uri = Uri.parse('https://www.facebook.com/beubay');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch Facebook');
      }
    } catch (e) {
      _showErrorSnackBar('Error: Please restart the app to use this feature');
    }
  }

  Future<void> _launchTwitter() async {
    try {
      final uri = Uri.parse('https://www.twitter.com/beubay');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch Twitter');
      }
    } catch (e) {
      _showErrorSnackBar('Error: Please restart the app to use this feature');
    }
  }

  Future<void> _launchInstagram() async {
    try {
      final uri = Uri.parse('https://www.instagram.com/beubay');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('Could not launch Instagram');
      }
    } catch (e) {
      _showErrorSnackBar('Error: Please restart the app to use this feature');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class _ExpandableFAQItem extends StatefulWidget {
  final FAQItem faqItem;

  const _ExpandableFAQItem({required this.faqItem});

  @override
  State<_ExpandableFAQItem> createState() => _ExpandableFAQItemState();
}

class _ExpandableFAQItemState extends State<_ExpandableFAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faqItem.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faqItem.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
