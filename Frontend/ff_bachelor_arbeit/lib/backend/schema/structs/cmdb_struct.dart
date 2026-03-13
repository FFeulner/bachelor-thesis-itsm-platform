// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CmdbStruct extends BaseStruct {
  CmdbStruct({
    String? recID,
    String? creatorID,
    String? assetname,
  })  : _recID = recID,
        _creatorID = creatorID,
        _assetname = assetname;

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

  // "Assetname" field.
  String? _assetname;
  String get assetname => _assetname ?? '';
  set assetname(String? val) => _assetname = val;

  bool hasAssetname() => _assetname != null;

  static CmdbStruct fromMap(Map<String, dynamic> data) => CmdbStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        assetname: data['Assetname'] as String?,
      );

  static CmdbStruct? maybeFromMap(dynamic data) =>
      data is Map ? CmdbStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Assetname': _assetname,
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
        'Assetname': serializeParam(
          _assetname,
          ParamType.String,
        ),
      }.withoutNulls;

  static CmdbStruct fromSerializableMap(Map<String, dynamic> data) =>
      CmdbStruct(
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
        assetname: deserializeParam(
          data['Assetname'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CmdbStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CmdbStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        assetname == other.assetname;
  }

  @override
  int get hashCode => const ListEquality().hash([recID, creatorID, assetname]);
}

CmdbStruct createCmdbStruct({
  String? recID,
  String? creatorID,
  String? assetname,
}) =>
    CmdbStruct(
      recID: recID,
      creatorID: creatorID,
      assetname: assetname,
    );
