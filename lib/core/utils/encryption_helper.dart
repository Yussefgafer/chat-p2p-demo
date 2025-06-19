import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

/// Helper class for encryption and decryption operations
class EncryptionHelper {
  static final _secureRandom = SecureRandom('Fortuna')
    ..seed(KeyParameter(Uint8List.fromList(
        List.generate(32, (i) => Random.secure().nextInt(256)))));
  
  /// Generate a secure random key
  static Key generateKey() {
    final keyBytes = _secureRandom.nextBytes(32); // 256-bit key
    return Key(keyBytes);
  }
  
  /// Generate a secure random IV
  static IV generateIV() {
    final ivBytes = _secureRandom.nextBytes(16); // 128-bit IV
    return IV(ivBytes);
  }
  
  /// Encrypt text using AES-GCM
  static EncryptedData encryptText(String plainText, Key key) {
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final iv = generateIV();
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    return EncryptedData(
      encryptedText: encrypted.base64,
      iv: iv.base64,
      key: key.base64,
    );
  }
  
  /// Decrypt text using AES-GCM
  static String decryptText(EncryptedData encryptedData) {
    final key = Key.fromBase64(encryptedData.key);
    final iv = IV.fromBase64(encryptedData.iv);
    final encrypted = Encrypted.fromBase64(encryptedData.encryptedText);
    
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return encrypter.decrypt(encrypted, iv: iv);
  }
  
  /// Encrypt file data
  static EncryptedData encryptFileData(Uint8List fileData, Key key) {
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    final iv = generateIV();
    final encrypted = encrypter.encryptBytes(fileData, iv: iv);
    
    return EncryptedData(
      encryptedText: encrypted.base64,
      iv: iv.base64,
      key: key.base64,
    );
  }
  
  /// Decrypt file data
  static Uint8List decryptFileData(EncryptedData encryptedData) {
    final key = Key.fromBase64(encryptedData.key);
    final iv = IV.fromBase64(encryptedData.iv);
    final encrypted = Encrypted.fromBase64(encryptedData.encryptedText);
    
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return Uint8List.fromList(encrypter.decryptBytes(encrypted, iv: iv));
  }
  
  /// Generate hash for data integrity
  static String generateHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Verify hash
  static bool verifyHash(String data, String hash) {
    return generateHash(data) == hash;
  }
  
  /// Generate key from password using PBKDF2
  static Key deriveKeyFromPassword(String password, String salt) {
    final saltBytes = utf8.encode(salt);
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(saltBytes, 10000, 32));
    
    final keyBytes = pbkdf2.process(utf8.encode(password));
    return Key(keyBytes);
  }
  
  /// Generate a secure salt
  static String generateSalt() {
    final saltBytes = _secureRandom.nextBytes(16);
    return base64.encode(saltBytes);
  }
}

/// Data class for encrypted content
class EncryptedData {
  final String encryptedText;
  final String iv;
  final String key;
  
  const EncryptedData({
    required this.encryptedText,
    required this.iv,
    required this.key,
  });
  
  Map<String, dynamic> toJson() => {
    'encryptedText': encryptedText,
    'iv': iv,
    'key': key,
  };
  
  factory EncryptedData.fromJson(Map<String, dynamic> json) => EncryptedData(
    encryptedText: json['encryptedText'],
    iv: json['iv'],
    key: json['key'],
  );
}
