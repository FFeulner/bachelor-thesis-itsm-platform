// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MitarbeiterTeamRelationAvailableStruct extends BaseStruct {
  MitarbeiterTeamRelationAvailableStruct({
    String? recID,
    String? name,
    String? rollenbeschreibung,
  })  : _recID = recID,
        _name = name,
        _rollenbeschreibung = rollenbeschreibung;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

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

  static MitarbeiterTeamRelationAvailableStruct fromMap(
          Map<String, dynamic> data) =>
      MitarbeiterTeamRelationAvailableStruct(
        recID: data['RecID'] as String?,
        name: data['Name'] as String?,
        rollenbeschreibung: data['Rollenbeschreibung'] as String?,
      );

  static MitarbeiterTeamRelationAvailableStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? MitarbeiterTeamRelationAvailableStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'Name': _name,
        'Rollenbeschreibung': _rollenbeschreibung,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
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

  static MitarbeiterTeamRelationAvailableStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MitarbeiterTeamRelationAvailableStruct(
        recID: deserializeParam(
          data['RecID'],
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
  String toString() => 'MitarbeiterTeamRelationAvailableStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MitarbeiterTeamRelationAvailableStruct &&
        recID == other.recID &&
        name == other.name &&
        rollenbeschreibung == other.rollenbeschreibung;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([recID, name, rollenbeschreibung]);
}

MitarbeiterTeamRelationAvailableStruct
    createMitarbeiterTeamRelationAvailableStruct({
  String? recID,
  String? name,
  String? rollenbeschreibung,
}) =>
        MitarbeiterTeamRelationAvailableStruct(
          recID: recID,
          name: name,
          rollenbeschreibung: rollenbeschreibung,
        );
