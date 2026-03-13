// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/environment_values.dart';

import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;
import 'package:crypto/crypto.dart';

Future startZitadelLogin(BuildContext context) async {
  // === ENVIRONMENT LADEN ===
  final env = FFDevEnvironmentValues();

  // === ZITADEL KONFIGURATION ===
  // TODO: Optional in dein environment.json verschieben und in FFDevEnvironmentValues exposen
  const String clientId = '314910909506060290';
  const String zitadelDomain = 'aegis.trinitycloud.de';

  // Redirect-URI aus deiner aktiven Environment-Datei
  final String redirectUri = env.zitadelRedirectUri;

  // Sanity-Check
  assert(
    redirectUri.isNotEmpty,
    'zitadelRedirectUri ist leer. Wurde FFDevEnvironmentValues.initialize() aufgerufen?',
  );

  // === 1. Code Verifier sicher generieren ===
  String generateCodeVerifier([int length = 64]) {
    final rand = Random.secure();
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    return List.generate(length, (_) => charset[rand.nextInt(charset.length)])
        .join();
  }

  final verifier = generateCodeVerifier();

  // === 2. Challenge erzeugen ===
  final challenge = base64UrlEncode(
    sha256.convert(utf8.encode(verifier)).bytes,
  ).replaceAll('=', '');

  // === 3. Verifier im AppState speichern ===
  FFAppState().authVerifier = verifier;

  // === 5. Login URL bauen ===
  final url = Uri.https(zitadelDomain, '/oauth/v2/authorize', {
    'client_id': clientId,
    'response_type': 'code',
    'redirect_uri': redirectUri,
    'scope':
        'openid email profile urn:zitadel:iam:org:project:roles offline_access',
    'code_challenge': challenge,
    'code_challenge_method': 'S256',
  });

  // === 6. Weiterleitung (IN-TAB) ===
  html.window.location.href = url.toString();
}
