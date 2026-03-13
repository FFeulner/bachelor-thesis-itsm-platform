// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MitarbeiterStruct extends BaseStruct {
  MitarbeiterStruct({
    String? recID,
    String? creatorID,
    String? vorname,
    String? nachname,
  })  : _recID = recID,
        _creatorID = creatorID,
        _vorname = vorname,
        _nachname = nachname;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "CreatorID" field.
  String? _creatorID;
  String get creatorID => _creatorID ?? '';
  set creatorID(String? val) => _creatorID = val;

  bool hasCreatorID() => _creatorID != null;

  // "Vorname" field.
  String? _vorname;
  String get vorname => _vorname ?? '';
  set vorname(String? val) => _vorname = val;

  bool hasVorname() => _vorname != null;

  // "Nachname" field.
  String? _nachname;
  String get nachname => _nachname ?? '';
  set nachname(String? val) => _nachname = val;

  bool hasNachname() => _nachname != null;

  static MitarbeiterStruct fromMap(Map<String, dynamic> data) =>
      MitarbeiterStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        vorname: data['Vorname'] as String?,
        nachname: data['Nachname'] as String?,
      );

  static MitarbeiterStruct? maybeFromMap(dynamic data) => data is Map
      ? MitarbeiterStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Vorname': _vorname,
        'Nachname': _nachname,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'CreatorID': serializeParam(
          _creatorID,
          ParamType.String,
        ),
        'Vorname': serializeParam(
          _vorname,
          ParamType.String,
        ),
        'Nachname': serializeParam(
          _nachname,
          ParamType.String,
        ),
      }.withoutNulls;

  static MitarbeiterStruct fromSerializableMap(Map<String, dynamic> data) =>
      MitarbeiterStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        creatorID: deserializeParam(
          data['CreatorID'],
          ParamType.String,
          false,
        ),
        vorname: deserializeParam(
          data['Vorname'],
          ParamType.String,
          false,
        ),
        nachname: deserializeParam(
          data['Nachname'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MitarbeiterStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MitarbeiterStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        vorname == other.vorname &&
        nachname == other.nachname;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([recID, creatorID, vorname, nachname]);
}

MitarbeiterStruct createMitarbeiterStruct({
  String? recID,
  String? creatorID,
  String? vorname,
  String? nachname,
}) =>
    MitarbeiterStruct(
      recID: recID,
      creatorID: creatorID,
      vorname: vorname,
      nachname: nachname,
    );
