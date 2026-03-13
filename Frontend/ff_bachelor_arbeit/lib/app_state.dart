import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import '/backend/api_requests/api_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_selectedVorgangObject') != null) {
        try {
          _selectedVorgangObject = jsonDecode(
              await secureStorage.getString('ff_selectedVorgangObject') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_selectedKundeFirma') != null) {
        try {
          _selectedKundeFirma = jsonDecode(
              await secureStorage.getString('ff_selectedKundeFirma') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_currentUser') != null) {
        try {
          _currentUser =
              jsonDecode(await secureStorage.getString('ff_currentUser') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _accessToken =
          await secureStorage.getString('ff_accessToken') ?? _accessToken;
    });
    await _safeInitAsync(() async {
      _idToken = await secureStorage.getString('ff_idToken') ?? _idToken;
    });
    await _safeInitAsync(() async {
      _refreshToken =
          await secureStorage.getString('ff_refreshToken') ?? _refreshToken;
    });
    await _safeInitAsync(() async {
      _authVerifier =
          await secureStorage.getString('ff_authVerifier') ?? _authVerifier;
    });
    await _safeInitAsync(() async {
      _selectedDetailsItems =
          (await secureStorage.getStringList('ff_selectedDetailsItems'))
                  ?.map((x) {
                try {
                  return jsonDecode(x);
                } catch (e) {
                  print("Can't decode persisted json. Error: $e.");
                  return {};
                }
              }).toList() ??
              _selectedDetailsItems;
    });
    await _safeInitAsync(() async {
      _timerSafe = await secureStorage.getInt('ff_timerSafe') ?? _timerSafe;
    });
    await _safeInitAsync(() async {
      _timertest2 =
          await secureStorage.getDouble('ff_timertest2') ?? _timertest2;
    });
    await _safeInitAsync(() async {
      _timertest3 = await secureStorage.read(key: 'ff_timertest3') != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (await secureStorage.getInt('ff_timertest3'))!)
          : _timertest3;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  dynamic _selectedVorgangObject;
  dynamic get selectedVorgangObject => _selectedVorgangObject;
  set selectedVorgangObject(dynamic value) {
    _selectedVorgangObject = value;
    secureStorage.setString('ff_selectedVorgangObject', jsonEncode(value));
  }

  void deleteSelectedVorgangObject() {
    secureStorage.delete(key: 'ff_selectedVorgangObject');
  }

  /// │ WARUM BENÖTIGT:                                              │
  /// │ • Steuert die visuelle Hervorhebung in der Navigation       │
  /// │ • Zeigt User wo er sich aktuell befindet                    │
  /// │ • Ermöglicht Active-State-Styling (gelber Hintergrund)
  String _selectedNavItem = 'mein-cockpit';
  String get selectedNavItem => _selectedNavItem;
  set selectedNavItem(String value) {
    _selectedNavItem = value;
  }

  /// Firmen Infos aus dem ausgewählten Dropdown Item
  dynamic _selectedKundeFirma;
  dynamic get selectedKundeFirma => _selectedKundeFirma;
  set selectedKundeFirma(dynamic value) {
    _selectedKundeFirma = value;
    secureStorage.setString('ff_selectedKundeFirma', jsonEncode(value));
  }

  void deleteSelectedKundeFirma() {
    secureStorage.delete(key: 'ff_selectedKundeFirma');
  }

  /// │ WARUM BENÖTIGT:                                              │
  /// │ • Steuert welcher Tab in der rechten Sidebar aktiv ist      │
  /// │ • Sidebar hat 2 Tabs: "AI Insights" und "Details"          │
  /// │ • Tab-Auswahl muss GLOBAL sein, weil:                       │
  /// │   - User wechselt zwischen Seiten                           │
  /// │   - Tab-Präferenz soll erhalten bleiben                     │
  /// │   - SidebarTabs Component ist wiederverwendbar
  String _sidebarTab = 'ai-insights';
  String get sidebarTab => _sidebarTab;
  set sidebarTab(String value) {
    _sidebarTab = value;
  }

  dynamic _sidebarSelectedItem;
  dynamic get sidebarSelectedItem => _sidebarSelectedItem;
  set sidebarSelectedItem(dynamic value) {
    _sidebarSelectedItem = value;
  }

  /// │ WARUM BENÖTIGT:                                              │
  /// │ • Speichert den eingeloggten Benutzer                       │
  /// │ • Wird in VIELEN Komponenten benötigt:                      │
  /// │   - AppHeader: Avatar anzeigen ("JD")                       │
  /// │   - ActionBar: Conditional Buttons (nur wenn zuständig)     │
  /// │   - API Calls: currentUser.id als Parameter                │
  /// │   - Berechtigungsprüfung: currentUser.role
  dynamic _currentUser;
  dynamic get currentUser => _currentUser;
  set currentUser(dynamic value) {
    _currentUser = value;
    secureStorage.setString('ff_currentUser', jsonEncode(value));
  }

  void deleteCurrentUser() {
    secureStorage.delete(key: 'ff_currentUser');
  }

  ///  WARUM BENÖTIGT:                                              │
  /// │ • Im Screenshot sichtbar im Header:                         │
  /// │   🔔 "3 Eskalationen"                                       │
  /// │   📅 "2 Termine heute"                                      │
  /// │ • Diese Info muss GLOBAL sein, weil:                        │
  /// │   - Header ist auf JEDER Seite sichtbar                    │
  /// │   - Info ändert sich in Echtzeit                           │
  /// │   - Warnsystem für wichtige Events
  dynamic _globalNotifications;
  dynamic get globalNotifications => _globalNotifications;
  set globalNotifications(dynamic value) {
    _globalNotifications = value;
  }

  String _accessToken = '';
  String get accessToken => _accessToken;
  set accessToken(String value) {
    _accessToken = value;
    secureStorage.setString('ff_accessToken', value);
  }

  void deleteAccessToken() {
    secureStorage.delete(key: 'ff_accessToken');
  }

  String _idToken = '';
  String get idToken => _idToken;
  set idToken(String value) {
    _idToken = value;
    secureStorage.setString('ff_idToken', value);
  }

  void deleteIdToken() {
    secureStorage.delete(key: 'ff_idToken');
  }

  String _refreshToken = '';
  String get refreshToken => _refreshToken;
  set refreshToken(String value) {
    _refreshToken = value;
    secureStorage.setString('ff_refreshToken', value);
  }

  void deleteRefreshToken() {
    secureStorage.delete(key: 'ff_refreshToken');
  }

  String _authVerifier = '';
  String get authVerifier => _authVerifier;
  set authVerifier(String value) {
    _authVerifier = value;
    secureStorage.setString('ff_authVerifier', value);
  }

  void deleteAuthVerifier() {
    secureStorage.delete(key: 'ff_authVerifier');
  }

  String _emailBodyMd = '';
  String get emailBodyMd => _emailBodyMd;
  set emailBodyMd(String value) {
    _emailBodyMd = value;
  }

  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;
  set imageUrls(List<String> value) {
    _imageUrls = value;
  }

  void addToImageUrls(String value) {
    imageUrls.add(value);
  }

  void removeFromImageUrls(String value) {
    imageUrls.remove(value);
  }

  void removeAtIndexFromImageUrls(int index) {
    imageUrls.removeAt(index);
  }

  void updateImageUrlsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    imageUrls[index] = updateFn(_imageUrls[index]);
  }

  void insertAtIndexInImageUrls(int index, String value) {
    imageUrls.insert(index, value);
  }

  String _lastUploadedImageUrl = '';
  String get lastUploadedImageUrl => _lastUploadedImageUrl;
  set lastUploadedImageUrl(String value) {
    _lastUploadedImageUrl = value;
  }

  /// soll den Status an die einzelnen Komponenten geben
  String _actionBarStatusBus = '';
  String get actionBarStatusBus => _actionBarStatusBus;
  set actionBarStatusBus(String value) {
    _actionBarStatusBus = value;
  }

  /// Variable um Index zu speichern für TAB Bar
  int _indexSchieber = 0;
  int get indexSchieber => _indexSchieber;
  set indexSchieber(int value) {
    _indexSchieber = value;
  }

  List<String> _emailAttachments = [];
  List<String> get emailAttachments => _emailAttachments;
  set emailAttachments(List<String> value) {
    _emailAttachments = value;
  }

  void addToEmailAttachments(String value) {
    emailAttachments.add(value);
  }

  void removeFromEmailAttachments(String value) {
    emailAttachments.remove(value);
  }

  void removeAtIndexFromEmailAttachments(int index) {
    emailAttachments.removeAt(index);
  }

  void updateEmailAttachmentsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    emailAttachments[index] = updateFn(_emailAttachments[index]);
  }

  void insertAtIndexInEmailAttachments(int index, String value) {
    emailAttachments.insert(index, value);
  }

  List<dynamic> _selectedDetailsItems = [];
  List<dynamic> get selectedDetailsItems => _selectedDetailsItems;
  set selectedDetailsItems(List<dynamic> value) {
    _selectedDetailsItems = value;
    secureStorage.setStringList(
        'ff_selectedDetailsItems', value.map((x) => jsonEncode(x)).toList());
  }

  void deleteSelectedDetailsItems() {
    secureStorage.delete(key: 'ff_selectedDetailsItems');
  }

  void addToSelectedDetailsItems(dynamic value) {
    selectedDetailsItems.add(value);
    secureStorage.setStringList('ff_selectedDetailsItems',
        _selectedDetailsItems.map((x) => jsonEncode(x)).toList());
  }

  void removeFromSelectedDetailsItems(dynamic value) {
    selectedDetailsItems.remove(value);
    secureStorage.setStringList('ff_selectedDetailsItems',
        _selectedDetailsItems.map((x) => jsonEncode(x)).toList());
  }

  void removeAtIndexFromSelectedDetailsItems(int index) {
    selectedDetailsItems.removeAt(index);
    secureStorage.setStringList('ff_selectedDetailsItems',
        _selectedDetailsItems.map((x) => jsonEncode(x)).toList());
  }

  void updateSelectedDetailsItemsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    selectedDetailsItems[index] = updateFn(_selectedDetailsItems[index]);
    secureStorage.setStringList('ff_selectedDetailsItems',
        _selectedDetailsItems.map((x) => jsonEncode(x)).toList());
  }

  void insertAtIndexInSelectedDetailsItems(int index, dynamic value) {
    selectedDetailsItems.insert(index, value);
    secureStorage.setStringList('ff_selectedDetailsItems',
        _selectedDetailsItems.map((x) => jsonEncode(x)).toList());
  }

  int _timerSafe = 0;
  int get timerSafe => _timerSafe;
  set timerSafe(int value) {
    _timerSafe = value;
    secureStorage.setInt('ff_timerSafe', value);
  }

  void deleteTimerSafe() {
    secureStorage.delete(key: 'ff_timerSafe');
  }

  double _timertest2 = 0.0;
  double get timertest2 => _timertest2;
  set timertest2(double value) {
    _timertest2 = value;
    secureStorage.setDouble('ff_timertest2', value);
  }

  void deleteTimertest2() {
    secureStorage.delete(key: 'ff_timertest2');
  }

  DateTime? _timertest3;
  DateTime? get timertest3 => _timertest3;
  set timertest3(DateTime? value) {
    _timertest3 = value;
    value != null
        ? secureStorage.setInt('ff_timertest3', value.millisecondsSinceEpoch)
        : secureStorage.remove('ff_timertest3');
  }

  void deleteTimertest3() {
    secureStorage.delete(key: 'ff_timertest3');
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
