// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FirmaStruct extends BaseStruct {
  FirmaStruct({
    String? recID,
    String? creatorID,
    String? name,
  })  : _recID = recID,
        _creatorID = creatorID,
        _name = name;

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

  static FirmaStruct fromMap(Map<String, dynamic> data) => FirmaStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        name: data['Name'] as String?,
      );

  static FirmaStruct? maybeFromMap(dynamic data) =>
      data is Map ? FirmaStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Name': _name,
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
      }.withoutNulls;

  static FirmaStruct fromSerializableMap(Map<String, dynamic> data) =>
      FirmaStruct(
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
      );

  @override
  String toString() => 'FirmaStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FirmaStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        name == other.name;
  }

  @override
  int get hashCode => const ListEquality().hash([recID, creatorID, name]);
}

FirmaStruct createFirmaStruct({
  String? recID,
  String? creatorID,
  String? name,
}) =>
    FirmaStruct(
      recID: recID,
      creatorID: creatorID,
      name: name,
    );
