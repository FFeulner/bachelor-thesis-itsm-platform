// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SopStruct extends BaseStruct {
  SopStruct({
    int? recID,
    String? creatorID,
    String? firmaRecID,
    String? mitarbeiterRecID,
    String? teamRecID,
    String? betreff,
    String? beschreibungMD,
  })  : _recID = recID,
        _creatorID = creatorID,
        _firmaRecID = firmaRecID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _teamRecID = teamRecID,
        _betreff = betreff,
        _beschreibungMD = beschreibungMD;

  // "RecID" field.
  int? _recID;
  int get recID => _recID ?? 0;
  set recID(int? val) => _recID = val;

  void incrementRecID(int amount) => recID = recID + amount;

  bool hasRecID() => _recID != null;

  // "CreatorID" field.
  String? _creatorID;
  String get creatorID => _creatorID ?? '';
  set creatorID(String? val) => _creatorID = val;

  bool hasCreatorID() => _creatorID != null;

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Mitarbeiter_RecID" field.
  String? _mitarbeiterRecID;
  String get mitarbeiterRecID => _mitarbeiterRecID ?? '';
  set mitarbeiterRecID(String? val) => _mitarbeiterRecID = val;

  bool hasMitarbeiterRecID() => _mitarbeiterRecID != null;

  // "Team_RecID" field.
  String? _teamRecID;
  String get teamRecID => _teamRecID ?? '';
  set teamRecID(String? val) => _teamRecID = val;

  bool hasTeamRecID() => _teamRecID != null;

  // "Betreff" field.
  String? _betreff;
  String get betreff => _betreff ?? '';
  set betreff(String? val) => _betreff = val;

  bool hasBetreff() => _betreff != null;

  // "Beschreibung_MD" field.
  String? _beschreibungMD;
  String get beschreibungMD => _beschreibungMD ?? '';
  set beschreibungMD(String? val) => _beschreibungMD = val;

  bool hasBeschreibungMD() => _beschreibungMD != null;

  static SopStruct fromMap(Map<String, dynamic> data) => SopStruct(
        recID: castToType<int>(data['RecID']),
        creatorID: data['CreatorID'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        mitarbeiterRecID: data['Mitarbeiter_RecID'] as String?,
        teamRecID: data['Team_RecID'] as String?,
        betreff: data['Betreff'] as String?,
        beschreibungMD: data['Beschreibung_MD'] as String?,
      );

  static SopStruct? maybeFromMap(dynamic data) =>
      data is Map ? SopStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Firma_RecID': _firmaRecID,
        'Mitarbeiter_RecID': _mitarbeiterRecID,
        'Team_RecID': _teamRecID,
        'Betreff': _betreff,
        'Beschreibung_MD': _beschreibungMD,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.int,
        ),
        'CreatorID': serializeParam(
          _creatorID,
          ParamType.String,
        ),
        'Firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Mitarbeiter_RecID': serializeParam(
          _mitarbeiterRecID,
          ParamType.String,
        ),
        'Team_RecID': serializeParam(
          _teamRecID,
          ParamType.String,
        ),
        'Betreff': serializeParam(
          _betreff,
          ParamType.String,
        ),
        'Beschreibung_MD': serializeParam(
          _beschreibungMD,
          ParamType.String,
        ),
      }.withoutNulls;

  static SopStruct fromSerializableMap(Map<String, dynamic> data) => SopStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.int,
          false,
        ),
        creatorID: deserializeParam(
          data['CreatorID'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
          ParamType.String,
          false,
        ),
        mitarbeiterRecID: deserializeParam(
          data['Mitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        teamRecID: deserializeParam(
          data['Team_RecID'],
          ParamType.String,
          false,
        ),
        betreff: deserializeParam(
          data['Betreff'],
          ParamType.String,
          false,
        ),
        beschreibungMD: deserializeParam(
          data['Beschreibung_MD'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SopStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SopStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        firmaRecID == other.firmaRecID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        teamRecID == other.teamRecID &&
        betreff == other.betreff &&
        beschreibungMD == other.beschreibungMD;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creatorID,
        firmaRecID,
        mitarbeiterRecID,
        teamRecID,
        betreff,
        beschreibungMD
      ]);
}

SopStruct createSopStruct({
  int? recID,
  String? creatorID,
  String? firmaRecID,
  String? mitarbeiterRecID,
  String? teamRecID,
  String? betreff,
  String? beschreibungMD,
}) =>
    SopStruct(
      recID: recID,
      creatorID: creatorID,
      firmaRecID: firmaRecID,
      mitarbeiterRecID: mitarbeiterRecID,
      teamRecID: teamRecID,
      betreff: betreff,
      beschreibungMD: beschreibungMD,
    );
