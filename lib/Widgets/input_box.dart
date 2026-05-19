import 'dart:ui';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final IconData? prefixIcon;

  InputBox({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              obscureText: obscureText ?? false,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.white.withOpacity(0.7)) : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                errorStyle: const TextStyle(color: Color(0xFFEF4444)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
