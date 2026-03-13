// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'index.dart'; // Imports other custom actions

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // nur für Web-Redirect

final storage = FlutterSecureStorage();

Future<bool> logoutUser() async {
  final idToken = FFAppState().idToken;
  final accessToken = FFAppState().accessToken;

  try {
    // 1) Backend-Logout-Endpoint callen (dort z.B. HttpOnly-Cookie löschen)
    final resp = await http.post(
      Uri.parse('http://localhost:8000/api/auth/logout'),
      headers: {
        'Content-Type': 'application/json',
        if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
        if (idToken.isNotEmpty) 'X-ID-Token': idToken,
      },
    ).timeout(const Duration(seconds: 12));

    if (resp.statusCode != 200) {
      print('Logout-Call fehlgeschlagen: ${resp.statusCode} | ${resp.body}');
      return false;
    }

    // 2) logout_url aus der Response ziehen (für RP-initiated Logout bei ZITADEL)
    String? logoutUrl;
    try {
      final body = jsonDecode(resp.body);
      if (body is Map && body['logout_url'] is String) {
        logoutUrl = body['logout_url'] as String;
      }
    } catch (_) {
      // Body ist kein JSON — ignorieren
    }

    // 3) Lokal alle Tokens und Secure Storage löschen
    await storage.deleteAll();
    FFAppState().accessToken = '';
    FFAppState().refreshToken = '';
    FFAppState().idToken = '';

    // 4) Im Web zur end_session URL navigieren (richtiger GET-Redirect)
    if (kIsWeb && logoutUrl != null && logoutUrl.isNotEmpty) {
      html.window.location.href = logoutUrl;
      // Normalerweise kehrt der Code hier nicht mehr zurück.
    }

    // Success signalisieren (auch wenn keine logout_url da war)
    return true;
  } catch (e) {
    print('Logout Exception: $e');
    return false;
  }
}
