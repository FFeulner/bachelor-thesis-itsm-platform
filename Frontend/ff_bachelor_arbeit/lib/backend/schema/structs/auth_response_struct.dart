// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AuthResponseStruct extends BaseStruct {
  AuthResponseStruct({
    String? accessToken,
    String? refreshToken,
    String? idToken,
  })  : _accessToken = accessToken,
        _refreshToken = refreshToken,
        _idToken = idToken;

  // "access_token" field.
  String? _accessToken;
  String get accessToken => _accessToken ?? '';
  set accessToken(String? val) => _accessToken = val;

  bool hasAccessToken() => _accessToken != null;

  // "refresh_token" field.
  String? _refreshToken;
  String get refreshToken => _refreshToken ?? '';
  set refreshToken(String? val) => _refreshToken = val;

  bool hasRefreshToken() => _refreshToken != null;

  // "id_token" field.
  String? _idToken;
  String get idToken => _idToken ?? '';
  set idToken(String? val) => _idToken = val;

  bool hasIdToken() => _idToken != null;

  static AuthResponseStruct fromMap(Map<String, dynamic> data) =>
      AuthResponseStruct(
        accessToken: data['access_token'] as String?,
        refreshToken: data['refresh_token'] as String?,
        idToken: data['id_token'] as String?,
      );

  static AuthResponseStruct? maybeFromMap(dynamic data) => data is Map
      ? AuthResponseStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'access_token': _accessToken,
        'refresh_token': _refreshToken,
        'id_token': _idToken,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'access_token': serializeParam(
          _accessToken,
          ParamType.String,
        ),
        'refresh_token': serializeParam(
          _refreshToken,
          ParamType.String,
        ),
        'id_token': serializeParam(
          _idToken,
          ParamType.String,
        ),
      }.withoutNulls;

  static AuthResponseStruct fromSerializableMap(Map<String, dynamic> data) =>
      AuthResponseStruct(
        accessToken: deserializeParam(
          data['access_token'],
          ParamType.String,
          false,
        ),
        refreshToken: deserializeParam(
          data['refresh_token'],
          ParamType.String,
          false,
        ),
        idToken: deserializeParam(
          data['id_token'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AuthResponseStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AuthResponseStruct &&
        accessToken == other.accessToken &&
        refreshToken == other.refreshToken &&
        idToken == other.idToken;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([accessToken, refreshToken, idToken]);
}

AuthResponseStruct createAuthResponseStruct({
  String? accessToken,
  String? refreshToken,
  String? idToken,
}) =>
    AuthResponseStruct(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
    );
