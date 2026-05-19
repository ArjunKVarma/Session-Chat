import 'dart:ui';
import 'package:flutter/material.dart';

// Define a class called 'Functions' to encapsulate all the reusable functions
class Functions {
  /// Scrolls to the bottom of a scrollable widget using the provided ScrollController.

  /// @param _scrollController The ScrollController instance associated with the scrollable widget.
  void scrollToBottom(ScrollController _scrollController) {
    // Check if the ScrollController has clients (i.e., the scrollable widget has been built)
    if (_scrollController.hasClients) {
      // Animate the scroll to the maximum scroll extent (i.e., the bottom of the scrollable widget)
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        // Set the animation duration to 500 milliseconds
        duration: const Duration(milliseconds: 500),
        // Use the 'ease' curve for a smooth animation
        curve: Curves.ease,
      );
    }
  }

  /// Displays an auto-dismissing alert dialog with room data.
  ///
  /// @param context The BuildContext instance of the parent widget.
  /// @param roomId A Map containing the room ID.
  /// @param password A Map containing the password.
  void showAutoDismissAlert(BuildContext context, Map roomId, password) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Room Info",
      barrierColor: Colors.black.withOpacity(0.1),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline, color: Color(0xFF38BDF8), size: 24),
                              const SizedBox(width: 8),
                              const Text(
                                "Room Info",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                                onPressed: () => Navigator.pop(context),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(Icons.meeting_room, "Room ID", "${roomId['room_id']}"),
                          const SizedBox(height: 12),
                          _buildInfoRow(Icons.lock_outline, "Password", "${password['password']}"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
