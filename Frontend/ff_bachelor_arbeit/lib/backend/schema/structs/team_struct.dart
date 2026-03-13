// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TeamStruct extends BaseStruct {
  TeamStruct({
    String? recID,
    String? creatorID,
    String? name,
    String? rollenbeschreibung,
  })  : _recID = recID,
        _creatorID = creatorID,
        _name = name,
        _rollenbeschreibung = rollenbeschreibung;

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

  // "Name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "Rollenbeschreibung" field.
  String? _rollenbeschreibung;
  String get rollenbeschreibung => _rollenbeschreibung ?? '';
  set rollenbeschreibung(String? val) => _rollenbeschreibung = val;

  bool hasRollenbeschreibung() => _rollenbeschreibung != null;

  static TeamStruct fromMap(Map<String, dynamic> data) => TeamStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        name: data['Name'] as String?,
        rollenbeschreibung: data['Rollenbeschreibung'] as String?,
      );

  static TeamStruct? maybeFromMap(dynamic data) =>
      data is Map ? TeamStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Name': _name,
        'Rollenbeschreibung': _rollenbeschreibung,
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
        'Name': serializeParam(
          _name,
          ParamType.String,
        ),
        'Rollenbeschreibung': serializeParam(
          _rollenbeschreibung,
          ParamType.String,
        ),
      }.withoutNulls;

  static TeamStruct fromSerializableMap(Map<String, dynamic> data) =>
      TeamStruct(
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
        name: deserializeParam(
          data['Name'],
          ParamType.String,
          false,
        ),
        rollenbeschreibung: deserializeParam(
          data['Rollenbeschreibung'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TeamStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TeamStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        name == other.name &&
        rollenbeschreibung == other.rollenbeschreibung;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([recID, creatorID, name, rollenbeschreibung]);
}

TeamStruct createTeamStruct({
  String? recID,
  String? creatorID,
  String? name,
  String? rollenbeschreibung,
}) =>
    TeamStruct(
      recID: recID,
      creatorID: creatorID,
      name: name,
      rollenbeschreibung: rollenbeschreibung,
    );
