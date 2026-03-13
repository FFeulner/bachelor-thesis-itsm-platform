import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';

List<String> textZuListe(
  String input,
  String seperators,
) {
  if (input.trim().isEmpty) return [];

  final pattern = RegExp('[${RegExp.escape(seperators)}]+');

  final parts = input
      .split(pattern)
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  final seen = <String>{};
  final out = <String>[];
  for (final s in parts) {
    if (seen.add(s)) out.add(s);
  }
  return out;
}

DateTime? parseStringtoDatetime(String? input) {
  if (input == null) return null;
  final s = input.trim();
  if (s.isEmpty) return null;

  // 1) Falls es ein Unix-Timestamp ist (Sekunden oder Millisekunden)
  final numVal = int.tryParse(s);
  if (numVal != null) {
    if (s.length >= 13) {
      return DateTime.fromMillisecondsSinceEpoch(numVal, isUtc: true).toLocal();
    } else {
      return DateTime.fromMillisecondsSinceEpoch(numVal * 1000, isUtc: true)
          .toLocal();
    }
  }

  final iso = DateTime.tryParse(s);
  if (iso != null) {
    return iso.isUtc ? iso.toLocal() : iso;
  }

  // 3) Optional: weitere Formate falls nötig

  final formats = <String>[
    "dd.MM.yyyy",
    "dd.MM.yyyy HH:mm",
    "dd.MM.yyyy HH:mm:ss",
  ];

  for (final f in formats) {
    try {
      return DateFormat(f).parseLoose(s);
    } catch (_) {}
  }

  return null;
}

String createTicketTag() {
  final now = DateTime.now().toUtc();
  final y = now.year.toString().padLeft(4, '0');
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  final _abc = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final _rng = math.Random();
  final rand = List.generate(8, (_) => _abc[_rng.nextInt(_abc.length)]).join();
  return 'TCK-$y$m$d-$rand';
}

List<String> getFileNameFromUrlList(List<String> urls) {
  List<String> fileNames = [];
  for (String url in urls) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
    fileNames.add(fileName);
  }
  return fileNames;
}

bool checkDateityp(
  String? text,
  String? dateityp,
) {
  if (text == null || dateityp == null) return false;
  String extension = text.split('.').last;
  return extension.toLowerCase() == dateityp.toLowerCase();
}

String? stringToImageFile(String? path) {
  if (path == null || path.isEmpty) {
    return null;
  }
  return path;
}

String? parseDatetimeToString(DateTime x) {
  return x.toIso8601String();
}

String? listeToString(List<String> items) {
  return items.join(', ');
}

dynamic updateJson(
  String key,
  String newValue,
  dynamic originalMap,
) {
  final Map<String, dynamic> updatedJson =
      Map<String, dynamic>.from(originalMap as Map<String, dynamic>);

  updatedJson[key] = newValue;

  return updatedJson;
}

String addTimeCustom(String input) {
  final raw = input.trim();
  if (raw.isEmpty) return DateTime.now().toIso8601String();

  final match = RegExp(r'^([+-])\s*(\d+)\s*([hHdDmM])$').firstMatch(raw);
  if (match == null) return DateTime.now().toIso8601String();

  final sign = match.group(1)!; // + oder -
  final amount = int.tryParse(match.group(2)!) ?? 0;
  final unit = match.group(3)!.toLowerCase(); // h, d, m

  final value = (sign == '-') ? -amount : amount;

  DateTime updated = DateTime.now();

  if (unit == 'h') {
    updated = updated.add(Duration(hours: value));
    return updated.toIso8601String();
  }

  if (unit == 'd') {
    updated = updated.add(Duration(days: value));
    return updated.toIso8601String();
  }

  // unit == 'm' -> echte Monate addieren (mit Tag-Clamp)
  final base = updated;
  final targetMonthIndex = (base.year * 12) + (base.month - 1) + value;
  final targetYear = targetMonthIndex ~/ 12;
  final targetMonth = (targetMonthIndex % 12) + 1;

  final lastDay = DateTime(targetYear, targetMonth + 1, 0).day;
  final day = math.min(base.day, lastDay);

  updated = DateTime(
    targetYear,
    targetMonth,
    day,
    base.hour,
    base.minute,
    base.second,
    base.millisecond,
    base.microsecond,
  );

  return updated.toIso8601String();
}
