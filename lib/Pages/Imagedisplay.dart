import 'dart:convert';
import 'package:flutter/material.dart';

class Imagedisplay extends StatelessWidget {
  final String src;
  const Imagedisplay({super.key, required this.src});

  @override
  Widget build(BuildContext context) {
    final bool isUrl = src.startsWith('http');
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: isUrl 
            ? Image.network(src, fit: BoxFit.contain)
            : Image.memory(base64Decode(src), fit: BoxFit.contain),
        ),
      ),
    );
  }
}
