import 'dart:ui';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        title: const Text('About SessionChat', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/images/icon_nb.png'),
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "SessionChat",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Version 1.0.0",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildInfoCard(
                    icon: Icons.lock_outline,
                    title: "End-to-End Encryption",
                    description: "Your messages are secured with E2E encryption. Nobody, not even us, can read your messages without the room password.",
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.meeting_room_outlined,
                    title: "Anonymous Rooms",
                    description: "Create or join rooms instantly. No phone numbers or real names required. The admin has the power to securely delete the room anytime.",
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.delete_outline,
                    title: "Zero Trace",
                    description: "Once a room is deleted, all messages and media are permanently wiped from the servers. Your data belongs to you.",
                  ),
                  const SizedBox(height: 40),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF38BDF8), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
