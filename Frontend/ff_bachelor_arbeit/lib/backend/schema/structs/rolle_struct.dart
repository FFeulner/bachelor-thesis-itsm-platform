// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RolleStruct extends BaseStruct {
  RolleStruct({
    String? recID,
    String? beschreibung,
  })  : _recID = recID,
        _beschreibung = beschreibung;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "Beschreibung" field.
  String? _beschreibung;
  String get beschreibung => _beschreibung ?? '';
  set beschreibung(String? val) => _beschreibung = val;

  bool hasBeschreibung() => _beschreibung != null;

  static RolleStruct fromMap(Map<String, dynamic> data) => RolleStruct(
        recID: data['RecID'] as String?,
        beschreibung: data['Beschreibung'] as String?,
      );

  static RolleStruct? maybeFromMap(dynamic data) =>
      data is Map ? RolleStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'Beschreibung': _beschreibung,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'Beschreibung': serializeParam(
          _beschreibung,
          ParamType.String,
        ),
      }.withoutNulls;

  static RolleStruct fromSerializableMap(Map<String, dynamic> data) =>
      RolleStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        beschreibung: deserializeParam(
          data['Beschreibung'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RolleStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RolleStruct &&
        recID == other.recID &&
        beschreibung == other.beschreibung;
  }

  @override
  int get hashCode => const ListEquality().hash([recID, beschreibung]);
}

RolleStruct createRolleStruct({
  String? recID,
  String? beschreibung,
}) =>
    RolleStruct(
      recID: recID,
      beschreibung: beschreibung,
    );
