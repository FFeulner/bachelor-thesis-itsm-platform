// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> loadTokensToAppState() async {
  FFAppState().accessToken = await storage.read(key: 'access_token') ?? '';
  FFAppState().refreshToken = await storage.read(key: 'refresh_token') ?? '';
  FFAppState().idToken = await storage.read(key: 'id_token') ?? '';
}
