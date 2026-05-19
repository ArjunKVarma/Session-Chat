import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sessionchat/Services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  void logout(BuildContext context) async {
    final AuthService _auth = context.read<AuthService>();
    await _auth.logout();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          // Glass Blur Effect
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.home_outlined,
                        title: 'Home',
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: 'About',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDrawerItem(
                    context: context,
                    icon: Icons.exit_to_app,
                    title: 'Log Out',
                    color: const Color(0xFFEF4444),
                    onTap: () => logout(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String username = user?.email?.split('@').first ?? "Anonymous User";
    
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: onSurfaceColor.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        username.toUpperCase(),
        style: TextStyle(
          color: onSurfaceColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final finalColor = color ?? onSurfaceColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: finalColor, size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    color: finalColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
