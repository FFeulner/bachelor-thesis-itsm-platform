// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AktivitaetenStruct extends BaseStruct {
  AktivitaetenStruct({
    String? recID,
    String? mitarbeiterRecID,
    String? timestamp,
    String? aktion,
    String? aktionInhalt,
    String? entityRecID,
    String? entityTable,
  })  : _recID = recID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _timestamp = timestamp,
        _aktion = aktion,
        _aktionInhalt = aktionInhalt,
        _entityRecID = entityRecID,
        _entityTable = entityTable;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "mitarbeiter_RecID" field.
  String? _mitarbeiterRecID;
  String get mitarbeiterRecID => _mitarbeiterRecID ?? '';
  set mitarbeiterRecID(String? val) => _mitarbeiterRecID = val;

  bool hasMitarbeiterRecID() => _mitarbeiterRecID != null;

  // "timestamp" field.
  String? _timestamp;
  String get timestamp => _timestamp ?? '';
  set timestamp(String? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  // "aktion" field.
  String? _aktion;
  String get aktion => _aktion ?? '';
  set aktion(String? val) => _aktion = val;

  bool hasAktion() => _aktion != null;

  // "aktion_inhalt" field.
  String? _aktionInhalt;
  String get aktionInhalt => _aktionInhalt ?? '';
  set aktionInhalt(String? val) => _aktionInhalt = val;

  bool hasAktionInhalt() => _aktionInhalt != null;

  // "entity_RecID" field.
  String? _entityRecID;
  String get entityRecID => _entityRecID ?? '';
  set entityRecID(String? val) => _entityRecID = val;

  bool hasEntityRecID() => _entityRecID != null;

  // "entity_table" field.
  String? _entityTable;
  String get entityTable => _entityTable ?? '';
  set entityTable(String? val) => _entityTable = val;

  bool hasEntityTable() => _entityTable != null;

  static AktivitaetenStruct fromMap(Map<String, dynamic> data) =>
      AktivitaetenStruct(
        recID: data['RecID'] as String?,
        mitarbeiterRecID: data['mitarbeiter_RecID'] as String?,
        timestamp: data['timestamp'] as String?,
        aktion: data['aktion'] as String?,
        aktionInhalt: data['aktion_inhalt'] as String?,
        entityRecID: data['entity_RecID'] as String?,
        entityTable: data['entity_table'] as String?,
      );

  static AktivitaetenStruct? maybeFromMap(dynamic data) => data is Map
      ? AktivitaetenStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'mitarbeiter_RecID': _mitarbeiterRecID,
        'timestamp': _timestamp,
        'aktion': _aktion,
        'aktion_inhalt': _aktionInhalt,
        'entity_RecID': _entityRecID,
        'entity_table': _entityTable,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'mitarbeiter_RecID': serializeParam(
          _mitarbeiterRecID,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.String,
        ),
        'aktion': serializeParam(
          _aktion,
          ParamType.String,
        ),
        'aktion_inhalt': serializeParam(
          _aktionInhalt,
          ParamType.String,
        ),
        'entity_RecID': serializeParam(
          _entityRecID,
          ParamType.String,
        ),
        'entity_table': serializeParam(
          _entityTable,
          ParamType.String,
        ),
      }.withoutNulls;

  static AktivitaetenStruct fromSerializableMap(Map<String, dynamic> data) =>
      AktivitaetenStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        mitarbeiterRecID: deserializeParam(
          data['mitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.String,
          false,
        ),
        aktion: deserializeParam(
          data['aktion'],
          ParamType.String,
          false,
        ),
        aktionInhalt: deserializeParam(
          data['aktion_inhalt'],
          ParamType.String,
          false,
        ),
        entityRecID: deserializeParam(
          data['entity_RecID'],
          ParamType.String,
          false,
        ),
        entityTable: deserializeParam(
          data['entity_table'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'AktivitaetenStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AktivitaetenStruct &&
        recID == other.recID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        timestamp == other.timestamp &&
        aktion == other.aktion &&
        aktionInhalt == other.aktionInhalt &&
        entityRecID == other.entityRecID &&
        entityTable == other.entityTable;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        mitarbeiterRecID,
        timestamp,
        aktion,
        aktionInhalt,
        entityRecID,
        entityTable
      ]);
}

AktivitaetenStruct createAktivitaetenStruct({
  String? recID,
  String? mitarbeiterRecID,
  String? timestamp,
  String? aktion,
  String? aktionInhalt,
  String? entityRecID,
  String? entityTable,
}) =>
    AktivitaetenStruct(
      recID: recID,
      mitarbeiterRecID: mitarbeiterRecID,
      timestamp: timestamp,
      aktion: aktion,
      aktionInhalt: aktionInhalt,
      entityRecID: entityRecID,
      entityTable: entityTable,
    );
