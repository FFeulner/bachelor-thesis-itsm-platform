// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CurrentUserStruct extends BaseStruct {
  CurrentUserStruct({
    String? recID,
    String? name,
    String? givenName,
    String? familyName,
    String? nickname,
    String? email,
    List<String>? roles,
  })  : _recID = recID,
        _name = name,
        _givenName = givenName,
        _familyName = familyName,
        _nickname = nickname,
        _email = email,
        _roles = roles;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "given_name" field.
  String? _givenName;
  String get givenName => _givenName ?? '';
  set givenName(String? val) => _givenName = val;

  bool hasGivenName() => _givenName != null;

  // "family_name" field.
  String? _familyName;
  String get familyName => _familyName ?? '';
  set familyName(String? val) => _familyName = val;

  bool hasFamilyName() => _familyName != null;

  // "nickname" field.
  String? _nickname;
  String get nickname => _nickname ?? '';
  set nickname(String? val) => _nickname = val;

  bool hasNickname() => _nickname != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "roles" field.
  List<String>? _roles;
  List<String> get roles => _roles ?? const [];
  set roles(List<String>? val) => _roles = val;

  void updateRoles(Function(List<String>) updateFn) {
    updateFn(_roles ??= []);
  }

  bool hasRoles() => _roles != null;

  static CurrentUserStruct fromMap(Map<String, dynamic> data) =>
      CurrentUserStruct(
        recID: data['RecID'] as String?,
        name: data['name'] as String?,
        givenName: data['given_name'] as String?,
        familyName: data['family_name'] as String?,
        nickname: data['nickname'] as String?,
        email: data['email'] as String?,
        roles: getDataList(data['roles']),
      );

  static CurrentUserStruct? maybeFromMap(dynamic data) => data is Map
      ? CurrentUserStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'name': _name,
        'given_name': _givenName,
        'family_name': _familyName,
        'nickname': _nickname,
        'email': _email,
        'roles': _roles,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'given_name': serializeParam(
          _givenName,
          ParamType.String,
        ),
        'family_name': serializeParam(
          _familyName,
          ParamType.String,
        ),
        'nickname': serializeParam(
          _nickname,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'roles': serializeParam(
          _roles,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static CurrentUserStruct fromSerializableMap(Map<String, dynamic> data) =>
      CurrentUserStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        givenName: deserializeParam(
          data['given_name'],
          ParamType.String,
          false,
        ),
        familyName: deserializeParam(
          data['family_name'],
          ParamType.String,
          false,
        ),
        nickname: deserializeParam(
          data['nickname'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        roles: deserializeParam<String>(
          data['roles'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'CurrentUserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CurrentUserStruct &&
        recID == other.recID &&
        name == other.name &&
        givenName == other.givenName &&
        familyName == other.familyName &&
        nickname == other.nickname &&
        email == other.email &&
        listEquality.equals(roles, other.roles);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([recID, name, givenName, familyName, nickname, email, roles]);
}

CurrentUserStruct createCurrentUserStruct({
  String? recID,
  String? name,
  String? givenName,
  String? familyName,
  String? nickname,
  String? email,
}) =>
    CurrentUserStruct(
      recID: recID,
      name: name,
      givenName: givenName,
      familyName: familyName,
      nickname: nickname,
      email: email,
    );
