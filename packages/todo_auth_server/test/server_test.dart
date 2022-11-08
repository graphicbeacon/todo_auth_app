import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://0.0.0.0:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  group('/auth/', () {
    test('/register succeeds', () async {
      final response = await post(
        Uri.parse('$host/auth/register'),
        body: json.encode({
          'name': 'Johnny',
          'email': 'johnny@todo.com',
          'password': 'password',
        }),
      );
      expect(response.statusCode, 200);
      expect(response.body, 'Registered');
    });

    test('/register fails upon wrong payload', () async {
      final response = await post(Uri.parse('$host/auth/register'));
      final response2 = await post(
        Uri.parse(
          '$host/auth/register',
        ),
        body: json.encode({'name': '', 'email': '', 'password': ''}),
      );
      expect(response.statusCode, 400);
      expect(response.body, 'Please provide your name, email and password');
      expect(response2.statusCode, 400);
      expect(response2.body, 'Please provide your name, email and password');
    });
  });
}
