import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:typed_data';

class EncryptionService {
  static encrypt.Key _getKey(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return encrypt.Key(Uint8List.fromList(digest.bytes));
  }

  static String encryptText(String text, String password) {
    if (text.isEmpty) return text;
    final key = _getKey(password);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    
    return iv.base64 + ':' + encrypted.base64;
  }

  static String decryptText(String encryptedText, String password) {
    if (encryptedText.isEmpty) return encryptedText;
    try {
      final parts = encryptedText.split(':');
      if (parts.length != 2) return encryptedText; // Fallback for unencrypted text
      
      final iv = encrypt.IV.fromBase64(parts[0]);
      final key = _getKey(password);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      
      return encrypter.decrypt64(parts[1], iv: iv);
    } catch (e) {
      return "Error decrypting message";
    }
  }
}
