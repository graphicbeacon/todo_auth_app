import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Creates a salt for password generation
String generateSalt([int length = 32]) {
  final rand = Random.secure();
  final saltBytes = List<int>.generate(length, (_) => rand.nextInt(256));
  return base64.encode(saltBytes);
}

/// Hash the password with the given salt
String hashPassword(String password, String salt) {
  const codec = Utf8Codec();
  final key = codec.encode(password);
  final saltBytes = codec.encode(salt);
  final hmac = Hmac(sha256, key);
  final digest = hmac.convert(saltBytes);
  return digest.toString();
}

/// Generate the JWT string used for user sessions
String generateJwt({
  required String subject,
  required String issuer,
  required String secret,
  Duration expiry = const Duration(seconds: 60 * 10), // 10 minutes
}) {
  final jwt = JWT(
    {
      'iat': DateTime.now().millisecondsSinceEpoch,
    },
    subject: subject,
    issuer: issuer,
  );
  return jwt.sign(SecretKey(secret), expiresIn: expiry);
}
