// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProjektStruct extends BaseStruct {
  ProjektStruct({
    String? recID,
    String? creatorID,
    String? firmaRecID,
    String? verantwortlicherRecID,
    String? mitarbeiterRecID,
    String? teamRecID,
    String? betreff,
    String? beschreibungMD,
  })  : _recID = recID,
        _creatorID = creatorID,
        _firmaRecID = firmaRecID,
        _verantwortlicherRecID = verantwortlicherRecID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _teamRecID = teamRecID,
        _betreff = betreff,
        _beschreibungMD = beschreibungMD;

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

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Verantwortlicher_RecID" field.
  String? _verantwortlicherRecID;
  String get verantwortlicherRecID => _verantwortlicherRecID ?? '';
  set verantwortlicherRecID(String? val) => _verantwortlicherRecID = val;

  bool hasVerantwortlicherRecID() => _verantwortlicherRecID != null;

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

  static ProjektStruct fromMap(Map<String, dynamic> data) => ProjektStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        verantwortlicherRecID: data['Verantwortlicher_RecID'] as String?,
        mitarbeiterRecID: data['Mitarbeiter_RecID'] as String?,
        teamRecID: data['Team_RecID'] as String?,
        betreff: data['Betreff'] as String?,
        beschreibungMD: data['Beschreibung_MD'] as String?,
      );

  static ProjektStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProjektStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Firma_RecID': _firmaRecID,
        'Verantwortlicher_RecID': _verantwortlicherRecID,
        'Mitarbeiter_RecID': _mitarbeiterRecID,
        'Team_RecID': _teamRecID,
        'Betreff': _betreff,
        'Beschreibung_MD': _beschreibungMD,
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
        'Firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Verantwortlicher_RecID': serializeParam(
          _verantwortlicherRecID,
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

  static ProjektStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProjektStruct(
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
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
          ParamType.String,
          false,
        ),
        verantwortlicherRecID: deserializeParam(
          data['Verantwortlicher_RecID'],
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
  String toString() => 'ProjektStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProjektStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        firmaRecID == other.firmaRecID &&
        verantwortlicherRecID == other.verantwortlicherRecID &&
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
        verantwortlicherRecID,
        mitarbeiterRecID,
        teamRecID,
        betreff,
        beschreibungMD
      ]);
}

ProjektStruct createProjektStruct({
  String? recID,
  String? creatorID,
  String? firmaRecID,
  String? verantwortlicherRecID,
  String? mitarbeiterRecID,
  String? teamRecID,
  String? betreff,
  String? beschreibungMD,
}) =>
    ProjektStruct(
      recID: recID,
      creatorID: creatorID,
      firmaRecID: firmaRecID,
      verantwortlicherRecID: verantwortlicherRecID,
      mitarbeiterRecID: mitarbeiterRecID,
      teamRecID: teamRecID,
      betreff: betreff,
      beschreibungMD: beschreibungMD,
    );
