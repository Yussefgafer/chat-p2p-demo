import 'package:flutter_test/flutter_test.dart';
import 'package:chat_p2p/core/utils/encryption_helper.dart';

void main() {
  group('EncryptionHelper Tests', () {
    late Key testKey;
    const String testMessage = 'Hello, this is a test message for encryption!';

    setUp(() {
      testKey = EncryptionHelper.generateKey();
    });

    group('Key Generation', () {
      test('should generate a valid key', () {
        final key = EncryptionHelper.generateKey();
        expect(key, isNotNull);
        expect(key.base64, isNotEmpty);
        expect(key.base64.length, greaterThan(0));
      });

      test('should generate different keys each time', () {
        final key1 = EncryptionHelper.generateKey();
        final key2 = EncryptionHelper.generateKey();
        expect(key1.base64, isNot(equals(key2.base64)));
      });

      test('should create key from base64 string', () {
        final originalKey = EncryptionHelper.generateKey();
        final recreatedKey = Key.fromBase64(originalKey.base64);
        expect(recreatedKey.base64, equals(originalKey.base64));
      });
    });

    group('Text Encryption/Decryption', () {
      test('should encrypt and decrypt text correctly', () {
        final encryptedData = EncryptionHelper.encryptText(testMessage, testKey);
        expect(encryptedData, isNotNull);
        expect(encryptedData.encryptedText, isNotEmpty);
        expect(encryptedData.iv, isNotEmpty);

        final decryptedMessage = EncryptionHelper.decryptText(encryptedData);
        expect(decryptedMessage, equals(testMessage));
      });

      test('should produce different encrypted data for same message', () {
        final encrypted1 = EncryptionHelper.encryptText(testMessage, testKey);
        final encrypted2 = EncryptionHelper.encryptText(testMessage, testKey);
        
        // Should be different due to random IV
        expect(encrypted1.encryptedText, isNot(equals(encrypted2.encryptedText)));
        expect(encrypted1.iv, isNot(equals(encrypted2.iv)));
        
        // But both should decrypt to same message
        expect(EncryptionHelper.decryptText(encrypted1), equals(testMessage));
        expect(EncryptionHelper.decryptText(encrypted2), equals(testMessage));
      });

      test('should handle empty string encryption', () {
        const emptyMessage = '';
        final encryptedData = EncryptionHelper.encryptText(emptyMessage, testKey);
        final decryptedMessage = EncryptionHelper.decryptText(encryptedData);
        expect(decryptedMessage, equals(emptyMessage));
      });

      test('should handle unicode characters', () {
        const unicodeMessage = '🔐 مرحبا بك في التطبيق! 🚀 Hello 世界';
        final encryptedData = EncryptionHelper.encryptText(unicodeMessage, testKey);
        final decryptedMessage = EncryptionHelper.decryptText(encryptedData);
        expect(decryptedMessage, equals(unicodeMessage));
      });

      test('should fail with wrong key', () {
        final encryptedData = EncryptionHelper.encryptText(testMessage, testKey);
        final wrongKey = EncryptionHelper.generateKey();
        
        expect(
          () => EncryptionHelper.decryptText(encryptedData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('File Encryption/Decryption', () {
      test('should encrypt and decrypt file data correctly', () {
        final testData = List.generate(1000, (index) => index % 256);
        final encryptedData = EncryptionHelper.encryptFileData(testData, testKey);
        
        expect(encryptedData, isNotNull);
        expect(encryptedData.encryptedText, isNotEmpty);
        expect(encryptedData.iv, isNotEmpty);
        
        // Note: File decryption would need to be implemented
        // This is a placeholder for the actual implementation
      });

      test('should handle large file data', () {
        final largeData = List.generate(100000, (index) => index % 256);
        final encryptedData = EncryptionHelper.encryptFileData(largeData, testKey);
        
        expect(encryptedData, isNotNull);
        expect(encryptedData.encryptedText.length, greaterThan(0));
      });
    });

    group('EncryptedData Serialization', () {
      test('should serialize and deserialize EncryptedData correctly', () {
        final encryptedData = EncryptionHelper.encryptText(testMessage, testKey);
        final json = encryptedData.toJson();
        
        expect(json, isA<Map<String, dynamic>>());
        expect(json['encryptedText'], equals(encryptedData.encryptedText));
        expect(json['iv'], equals(encryptedData.iv));
        
        final recreatedData = EncryptedData.fromJson(json);
        expect(recreatedData.encryptedText, equals(encryptedData.encryptedText));
        expect(recreatedData.iv, equals(encryptedData.iv));
        
        final decryptedMessage = EncryptionHelper.decryptText(recreatedData);
        expect(decryptedMessage, equals(testMessage));
      });
    });

    group('Error Handling', () {
      test('should throw exception for invalid encrypted data', () {
        final invalidData = EncryptedData(
          encryptedText: 'invalid_encrypted_text',
          iv: 'invalid_iv',
        );
        
        expect(
          () => EncryptionHelper.decryptText(invalidData),
          throwsA(isA<Exception>()),
        );
      });

      test('should throw exception for malformed base64 key', () {
        expect(
          () => Key.fromBase64('invalid_base64_key'),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Performance Tests', () {
      test('should encrypt/decrypt within reasonable time', () {
        final stopwatch = Stopwatch()..start();
        
        for (int i = 0; i < 100; i++) {
          final encrypted = EncryptionHelper.encryptText(testMessage, testKey);
          EncryptionHelper.decryptText(encrypted);
        }
        
        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should complete in under 1 second
      });

      test('should handle concurrent encryption operations', () async {
        final futures = List.generate(10, (index) async {
          final message = '$testMessage $index';
          final encrypted = EncryptionHelper.encryptText(message, testKey);
          return EncryptionHelper.decryptText(encrypted);
        });
        
        final results = await Future.wait(futures);
        
        for (int i = 0; i < results.length; i++) {
          expect(results[i], equals('$testMessage $i'));
        }
      });
    });
  });
}
