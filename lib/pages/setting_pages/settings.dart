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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: _buildText("Settings", 24, FontWeight.w600, Colors.black),
        centerTitle: false,
      ),
      body: IconTheme(
        data: const IconThemeData(
          color: Colors.black, 
          size: 24,       
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Go Premium Button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.05,
                    vertical: constraints.maxHeight * 0.02,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      print("Go Premium tapped");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3478F6),
                      padding: EdgeInsets.symmetric(vertical: constraints.maxHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.emoji_events, size: 22, color: Colors.white),
                          const SizedBox(width: 8),
                          _buildText("Go Premium", 16, FontWeight.w500, Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),

                // Settings List
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
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
            );
          },
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: _buildText(title, 14, FontWeight.w600, const Color(0xFF6B7280)),
    );
  }

  // Settings Tile
  Widget _buildSettingsTile(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: _buildText(title, 16, FontWeight.w500, const Color(0xFF111827)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          print('$title tapped');
        },
      ),
    );
  }

  // General Text Builder
  Widget _buildText(String text, double fontSize, FontWeight fontWeight, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
