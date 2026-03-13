import 'dart:convert';
import 'package:flutter/services.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'development';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _apiURl = data['apiURl'];
      _zitadelRedirectUri = data['zitadelRedirectUri'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _apiURl = '';
  String get apiURl => _apiURl;

  String _zitadelRedirectUri = '';
  String get zitadelRedirectUri => _zitadelRedirectUri;
}
