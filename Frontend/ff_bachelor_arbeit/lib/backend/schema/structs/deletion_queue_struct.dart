// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DeletionQueueStruct extends BaseStruct {
  DeletionQueueStruct({
    String? id,
    String? tabellenname,
    String? datensatzId,
    String? grund,
    String? snapshotJson,
    String? status,
    String? angefordertVon,
    String? angefordertAm,
    String? geprueftVon,
    String? geprueftAm,
  })  : _id = id,
        _tabellenname = tabellenname,
        _datensatzId = datensatzId,
        _grund = grund,
        _snapshotJson = snapshotJson,
        _status = status,
        _angefordertVon = angefordertVon,
        _angefordertAm = angefordertAm,
        _geprueftVon = geprueftVon,
        _geprueftAm = geprueftAm;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "tabellenname" field.
  String? _tabellenname;
  String get tabellenname => _tabellenname ?? '';
  set tabellenname(String? val) => _tabellenname = val;

  bool hasTabellenname() => _tabellenname != null;

  // "datensatz_id" field.
  String? _datensatzId;
  String get datensatzId => _datensatzId ?? '';
  set datensatzId(String? val) => _datensatzId = val;

  bool hasDatensatzId() => _datensatzId != null;

  // "grund" field.
  String? _grund;
  String get grund => _grund ?? '';
  set grund(String? val) => _grund = val;

  bool hasGrund() => _grund != null;

  // "snapshot_json" field.
  String? _snapshotJson;
  String get snapshotJson => _snapshotJson ?? '';
  set snapshotJson(String? val) => _snapshotJson = val;

  bool hasSnapshotJson() => _snapshotJson != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "angefordert_von" field.
  String? _angefordertVon;
  String get angefordertVon => _angefordertVon ?? '';
  set angefordertVon(String? val) => _angefordertVon = val;

  bool hasAngefordertVon() => _angefordertVon != null;

  // "angefordert_am" field.
  String? _angefordertAm;
  String get angefordertAm => _angefordertAm ?? '';
  set angefordertAm(String? val) => _angefordertAm = val;

  bool hasAngefordertAm() => _angefordertAm != null;

  // "geprueft_von" field.
  String? _geprueftVon;
  String get geprueftVon => _geprueftVon ?? '';
  set geprueftVon(String? val) => _geprueftVon = val;

  bool hasGeprueftVon() => _geprueftVon != null;

  // "geprueft_am" field.
  String? _geprueftAm;
  String get geprueftAm => _geprueftAm ?? '';
  set geprueftAm(String? val) => _geprueftAm = val;

  bool hasGeprueftAm() => _geprueftAm != null;

  static DeletionQueueStruct fromMap(Map<String, dynamic> data) =>
      DeletionQueueStruct(
        id: data['id'] as String?,
        tabellenname: data['tabellenname'] as String?,
        datensatzId: data['datensatz_id'] as String?,
        grund: data['grund'] as String?,
        snapshotJson: data['snapshot_json'] as String?,
        status: data['status'] as String?,
        angefordertVon: data['angefordert_von'] as String?,
        angefordertAm: data['angefordert_am'] as String?,
        geprueftVon: data['geprueft_von'] as String?,
        geprueftAm: data['geprueft_am'] as String?,
      );

  static DeletionQueueStruct? maybeFromMap(dynamic data) => data is Map
      ? DeletionQueueStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'tabellenname': _tabellenname,
        'datensatz_id': _datensatzId,
        'grund': _grund,
        'snapshot_json': _snapshotJson,
        'status': _status,
        'angefordert_von': _angefordertVon,
        'angefordert_am': _angefordertAm,
        'geprueft_von': _geprueftVon,
        'geprueft_am': _geprueftAm,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'tabellenname': serializeParam(
          _tabellenname,
          ParamType.String,
        ),
        'datensatz_id': serializeParam(
          _datensatzId,
          ParamType.String,
        ),
        'grund': serializeParam(
          _grund,
          ParamType.String,
        ),
        'snapshot_json': serializeParam(
          _snapshotJson,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'angefordert_von': serializeParam(
          _angefordertVon,
          ParamType.String,
        ),
        'angefordert_am': serializeParam(
          _angefordertAm,
          ParamType.String,
        ),
        'geprueft_von': serializeParam(
          _geprueftVon,
          ParamType.String,
        ),
        'geprueft_am': serializeParam(
          _geprueftAm,
          ParamType.String,
        ),
      }.withoutNulls;

  static DeletionQueueStruct fromSerializableMap(Map<String, dynamic> data) =>
      DeletionQueueStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        tabellenname: deserializeParam(
          data['tabellenname'],
          ParamType.String,
          false,
        ),
        datensatzId: deserializeParam(
          data['datensatz_id'],
          ParamType.String,
          false,
        ),
        grund: deserializeParam(
          data['grund'],
          ParamType.String,
          false,
        ),
        snapshotJson: deserializeParam(
          data['snapshot_json'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        angefordertVon: deserializeParam(
          data['angefordert_von'],
          ParamType.String,
          false,
        ),
        angefordertAm: deserializeParam(
          data['angefordert_am'],
          ParamType.String,
          false,
        ),
        geprueftVon: deserializeParam(
          data['geprueft_von'],
          ParamType.String,
          false,
        ),
        geprueftAm: deserializeParam(
          data['geprueft_am'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DeletionQueueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DeletionQueueStruct &&
        id == other.id &&
        tabellenname == other.tabellenname &&
        datensatzId == other.datensatzId &&
        grund == other.grund &&
        snapshotJson == other.snapshotJson &&
        status == other.status &&
        angefordertVon == other.angefordertVon &&
        angefordertAm == other.angefordertAm &&
        geprueftVon == other.geprueftVon &&
        geprueftAm == other.geprueftAm;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        tabellenname,
        datensatzId,
        grund,
        snapshotJson,
        status,
        angefordertVon,
        angefordertAm,
        geprueftVon,
        geprueftAm
      ]);
}

DeletionQueueStruct createDeletionQueueStruct({
  String? id,
  String? tabellenname,
  String? datensatzId,
  String? grund,
  String? snapshotJson,
  String? status,
  String? angefordertVon,
  String? angefordertAm,
  String? geprueftVon,
  String? geprueftAm,
}) =>
    DeletionQueueStruct(
      id: id,
      tabellenname: tabellenname,
      datensatzId: datensatzId,
      grund: grund,
      snapshotJson: snapshotJson,
      status: status,
      angefordertVon: angefordertVon,
      angefordertAm: angefordertAm,
      geprueftVon: geprueftVon,
      geprueftAm: geprueftAm,
    );
