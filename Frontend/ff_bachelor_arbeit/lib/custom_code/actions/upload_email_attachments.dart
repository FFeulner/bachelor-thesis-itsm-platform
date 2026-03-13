// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<List<String>> uploadEmailAttachments(
  String uploadUrl,
  String? accessToken,
  String? recId,
) async {
  final atts = FFAppState().emailAttachments;
  if (atts.isEmpty) return [];

  final endpoint = uploadUrl.trim();
  if (endpoint.isEmpty) return [];

  final List<String> uploaded = [];

  for (final dataUri in atts) {
    final parts = dataUri.split(',');
    if (parts.length != 2) continue;

    final meta = parts[0];
    final b64 = parts[1];

    final nameMatch = RegExp(r'name=([^;]+)').firstMatch(meta);
    final filename = nameMatch?.group(1) ?? 'attachment';

    Uint8List bytes;
    try {
      bytes = base64Decode(b64);
    } catch (_) {
      continue;
    }

    final req = http.MultipartRequest('POST', Uri.parse(endpoint));
    req.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ),
    );

    final folder =
        (recId != null && recId.trim().isNotEmpty) ? 'res/$recId' : 'res/misc';
    req.fields['folder'] = folder;

    final tokenRaw = (accessToken ?? '').trim();
    if (tokenRaw.isNotEmpty) {
      final clean = tokenRaw.toLowerCase().startsWith('bearer ')
          ? tokenRaw.substring(7).trim()
          : tokenRaw;
      req.headers['Authorization'] = 'Bearer $clean';
    }

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Upload failed ${resp.statusCode}: ${resp.body}');
    }

    final dynamic j = jsonDecode(resp.body);
    String? url;

    if (j is Map && j['files'] is List && (j['files'] as List).isNotEmpty) {
      final first = (j['files'] as List).first;
      if (first is Map && first['url'] is String) {
        url = first['url'];
      } else if (first is Map && first['path'] is String) {
        url = first['path'];
      }
    } else if (j is Map && j['url'] is String) {
      url = j['url'];
    } else if (j is String) {
      url = j;
    }

    if (url == null || url.isEmpty) continue;

    url = url.replaceFirst(
      'http://enigmadev.trinitynetworks.zz:8000',
      'https://enigmadev.trinitynetworks.zz',
    );

    uploaded.add(url);
  }

  return uploaded;
}
