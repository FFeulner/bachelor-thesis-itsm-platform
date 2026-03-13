// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<void> speichereNutzerAusIdToken() async {
  final app = FFAppState();
  final idToken = (app.idToken ?? '').toString().trim();

  List<String> _extractRoleNames(Map<String, dynamic> payload) {
    final names = <String>{};
    for (final key in payload.keys) {
      if (key.startsWith('urn:zitadel:iam:org:project:') &&
          key.endsWith(':roles')) {
        final v = payload[key];
        if (v is Map) {
          for (final roleName in v.keys) {
            names.add(roleName.toString());
          }
        }
      }
    }
    final fallback = payload['roles'];
    if (fallback is List) {
      for (final r in fallback) {
        names.add(r.toString());
      }
    }
    return names.toList()..sort();
  }

  Map<String, dynamic> emptyUser() => <String, dynamic>{};

  if (idToken.isEmpty || !idToken.contains('.')) {
    app.update(() => app.currentUser = emptyUser());
    return;
  }

  try {
    final parts = idToken.split('.');
    if (parts.length < 2) {
      app.update(() => app.currentUser = emptyUser());
      return;
    }

    final payloadJson =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payload = jsonDecode(payloadJson) as Map<String, dynamic>;

    dynamic aud = payload['aud'];
    if (aud is! List && aud is! String && aud != null) {
      aud = aud.toString();
    }

    final data = <String, dynamic>{
      'RecID': payload['sub']?.toString() ?? '',
      'name': payload['name']?.toString() ?? '',
      'given_name': payload['given_name']?.toString() ?? '',
      'family_name': payload['family_name']?.toString() ?? '',
      'nickname': (payload['nickname'] ?? payload['preferred_username'] ?? '')
          .toString(),
      'email': payload['email']?.toString() ?? '',
      'roles': _extractRoleNames(payload),
      'iss': payload['iss']?.toString(),
      'aud': aud,
      'exp': payload['exp'],
      'iat': payload['iat'],
      'auth_time': payload['auth_time'],
    };

    app.update(() {
      app.currentUser = data;
    });
  } catch (_) {
    app.update(() => app.currentUser = emptyUser());
  }
}
