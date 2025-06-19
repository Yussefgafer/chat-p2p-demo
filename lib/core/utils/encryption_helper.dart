import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Demo encryption helper - simplified version for demo purposes
/// In production, use proper encryption libraries like crypto, encrypt, pointycastle
class EncryptionHelper {
  static final _random = Random.secure();

  /// Generate a secure random key (demo version)
  static String generateKey() {
    final keyBytes = List.generate(32, (i) => _random.nextInt(256));
    return base64Encode(keyBytes);
  }

  /// Generate a secure random IV (demo version)
  static String generateIV() {
    final ivBytes = List.generate(16, (i) => _random.nextInt(256));
    return base64Encode(ivBytes);
  }

  /// Encrypt text using simple XOR (demo version - NOT secure for production)
  static EncryptedData encryptText(String plainText, String key) {
    final keyBytes = base64Decode(key);
    final plainBytes = utf8.encode(plainText);
    final iv = generateIV();

    // Simple XOR encryption (demo only)
    final encryptedBytes = <int>[];
    for (int i = 0; i < plainBytes.length; i++) {
      encryptedBytes.add(plainBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return EncryptedData(
      encryptedText: base64Encode(encryptedBytes),
      key: key,
      iv: iv,
    );
  }

  /// Decrypt text (demo version)
  static String decryptText(EncryptedData encryptedData) {
    final keyBytes = base64Decode(encryptedData.key);
    final encryptedBytes = base64Decode(encryptedData.encryptedText);

    // Simple XOR decryption (demo only)
    final decryptedBytes = <int>[];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return utf8.decode(decryptedBytes);
  }

  /// Encrypt file data (demo version)
  static EncryptedData encryptFileData(Uint8List fileData, String key) {
    final keyBytes = base64Decode(key);
    final iv = generateIV();

    // Simple XOR encryption (demo only)
    final encryptedBytes = <int>[];
    for (int i = 0; i < fileData.length; i++) {
      encryptedBytes.add(fileData[i] ^ keyBytes[i % keyBytes.length]);
    }

    return EncryptedData(
      encryptedText: base64Encode(encryptedBytes),
      key: key,
      iv: iv,
    );
  }

  /// Decrypt file data (demo version)
  static Uint8List decryptFileData(EncryptedData encryptedData) {
    final keyBytes = base64Decode(encryptedData.key);
    final encryptedBytes = base64Decode(encryptedData.encryptedText);

    // Simple XOR decryption (demo only)
    final decryptedBytes = <int>[];
    for (int i = 0; i < encryptedBytes.length; i++) {
      decryptedBytes.add(encryptedBytes[i] ^ keyBytes[i % keyBytes.length]);
    }

    return Uint8List.fromList(decryptedBytes);
  }

  /// Generate hash of data (demo version)
  static String generateHash(String data) {
    // Simple hash function (demo only - use proper crypto in production)
    final bytes = utf8.encode(data);
    int hash = 0;
    for (int byte in bytes) {
      hash = ((hash << 5) - hash + byte) & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  /// Verify hash
  static bool verifyHash(String data, String hash) {
    return generateHash(data) == hash;
  }

  /// Generate key from password (demo version)
  static String deriveKeyFromPassword(String password, String salt) {
    // Simple key derivation (demo only - use PBKDF2 in production)
    final combined = password + salt;
    final bytes = utf8.encode(combined);
    final keyBytes = List.generate(
      32,
      (i) => bytes[i % bytes.length] ^ (i + 1),
    );
    return base64Encode(keyBytes);
  }
}

/// Data class for encrypted content
class EncryptedData {
  final String encryptedText;
  final String key;
  final String iv;

  const EncryptedData({
    required this.encryptedText,
    required this.key,
    required this.iv,
  });

  Map<String, dynamic> toJson() {
    return {'encryptedText': encryptedText, 'key': key, 'iv': iv};
  }

  factory EncryptedData.fromJson(Map<String, dynamic> json) {
    return EncryptedData(
      encryptedText: json['encryptedText'] as String,
      key: json['key'] as String,
      iv: json['iv'] as String,
    );
  }

  @override
  String toString() {
    return 'EncryptedData(encryptedText: ${encryptedText.substring(0, 10)}..., key: ${key.substring(0, 10)}..., iv: ${iv.substring(0, 10)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EncryptedData &&
        other.encryptedText == encryptedText &&
        other.key == key &&
        other.iv == iv;
  }

  @override
  int get hashCode {
    return encryptedText.hashCode ^ key.hashCode ^ iv.hashCode;
  }
}
