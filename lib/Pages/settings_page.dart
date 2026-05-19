import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessionchat/Services/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.2),
            ),
          ),
        ),
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: onSurfaceColor)),
        iconTheme: IconThemeData(color: onSurfaceColor),
      ),
      body: Stack(
        children: [
          // Background Gradient Ornaments
          Positioned(
            top: 50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF818CF8).withOpacity(0.1),
              ),
            ),
          ),
          // Glass Blur Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(color: Colors.transparent),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildSectionHeader("App Preferences"),
                _buildSettingsTile(
                  icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                  title: "App Theme",
                  subtitle: isDark ? "Frost Dark Mode is currently active." : "Light Mode is currently active.",
                  onSurfaceColor: onSurfaceColor,
                  isDark: isDark,
                  trailing: Switch(
                    value: isDark,
                    onChanged: (val) {
                      context.read<ThemeProvider>().toggleTheme();
                    },
                    activeColor: const Color(0xFF38BDF8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF38BDF8),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    required Color onSurfaceColor,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: onSurfaceColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: onSurfaceColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: onSurfaceColor.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          trailing,
        ],
      ),
    );
  }
}
