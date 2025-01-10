import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Go Premium Button
          Container(
            margin: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print("Go Premium tapped");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3478F6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.crop, size: 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Go Premium",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Settings List
          Expanded(
            child: Flex(
              direction: Axis.vertical,
              children: [
                _buildSectionTitle("General"),
                _buildSettingsTile(Icons.description, "Terms of Service"),
                _buildSettingsTile(Icons.privacy_tip, "Privacy Policy"),
                _buildSectionTitle("Feedback"),
                _buildSettingsTile(Icons.star_border, "Rate the App"),
                _buildSettingsTile(Icons.edit_outlined, "Write a Review"),
                _buildSettingsTile(Icons.share_outlined, "Share the App"),
                _buildSectionTitle("Account"),
                _buildSettingsTile(Icons.copy, "Copy User ID"),
                _buildSettingsTile(Icons.email_outlined, "Contact Support"),
                _buildSettingsTile(Icons.restore, "Restore Purchases"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // Settings Tile
  Widget _buildSettingsTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF9CA3AF)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0xFF111827),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
        onTap: () {
          print('$title tapped');
        },
      ),
    );
  }
}
