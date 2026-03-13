// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChangesStruct extends BaseStruct {
  ChangesStruct({
    int? id,
    String? recordId,
    String? action,
    String? field,
    String? oldValue,
    String? newValue,
    String? timestamp,
    String? user,
  })  : _id = id,
        _recordId = recordId,
        _action = action,
        _field = field,
        _oldValue = oldValue,
        _newValue = newValue,
        _timestamp = timestamp,
        _user = user;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "record_id" field.
  String? _recordId;
  String get recordId => _recordId ?? '';
  set recordId(String? val) => _recordId = val;

  bool hasRecordId() => _recordId != null;

  // "action" field.
  String? _action;
  String get action => _action ?? '';
  set action(String? val) => _action = val;

  bool hasAction() => _action != null;

  // "field" field.
  String? _field;
  String get field => _field ?? '';
  set field(String? val) => _field = val;

  bool hasField() => _field != null;

  // "old_value" field.
  String? _oldValue;
  String get oldValue => _oldValue ?? '';
  set oldValue(String? val) => _oldValue = val;

  bool hasOldValue() => _oldValue != null;

  // "new_value" field.
  String? _newValue;
  String get newValue => _newValue ?? '';
  set newValue(String? val) => _newValue = val;

  bool hasNewValue() => _newValue != null;

  // "timestamp" field.
  String? _timestamp;
  String get timestamp => _timestamp ?? '';
  set timestamp(String? val) => _timestamp = val;

  bool hasTimestamp() => _timestamp != null;

  // "user" field.
  String? _user;
  String get user => _user ?? '';
  set user(String? val) => _user = val;

  bool hasUser() => _user != null;

  static ChangesStruct fromMap(Map<String, dynamic> data) => ChangesStruct(
        id: castToType<int>(data['id']),
        recordId: data['record_id'] as String?,
        action: data['action'] as String?,
        field: data['field'] as String?,
        oldValue: data['old_value'] as String?,
        newValue: data['new_value'] as String?,
        timestamp: data['timestamp'] as String?,
        user: data['user'] as String?,
      );

  static ChangesStruct? maybeFromMap(dynamic data) =>
      data is Map ? ChangesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'record_id': _recordId,
        'action': _action,
        'field': _field,
        'old_value': _oldValue,
        'new_value': _newValue,
        'timestamp': _timestamp,
        'user': _user,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'record_id': serializeParam(
          _recordId,
          ParamType.String,
        ),
        'action': serializeParam(
          _action,
          ParamType.String,
        ),
        'field': serializeParam(
          _field,
          ParamType.String,
        ),
        'old_value': serializeParam(
          _oldValue,
          ParamType.String,
        ),
        'new_value': serializeParam(
          _newValue,
          ParamType.String,
        ),
        'timestamp': serializeParam(
          _timestamp,
          ParamType.String,
        ),
        'user': serializeParam(
          _user,
          ParamType.String,
        ),
      }.withoutNulls;

  static ChangesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChangesStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        recordId: deserializeParam(
          data['record_id'],
          ParamType.String,
          false,
        ),
        action: deserializeParam(
          data['action'],
          ParamType.String,
          false,
        ),
        field: deserializeParam(
          data['field'],
          ParamType.String,
          false,
        ),
        oldValue: deserializeParam(
          data['old_value'],
          ParamType.String,
          false,
        ),
        newValue: deserializeParam(
          data['new_value'],
          ParamType.String,
          false,
        ),
        timestamp: deserializeParam(
          data['timestamp'],
          ParamType.String,
          false,
        ),
        user: deserializeParam(
          data['user'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ChangesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChangesStruct &&
        id == other.id &&
        recordId == other.recordId &&
        action == other.action &&
        field == other.field &&
        oldValue == other.oldValue &&
        newValue == other.newValue &&
        timestamp == other.timestamp &&
        user == other.user;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, recordId, action, field, oldValue, newValue, timestamp, user]);
}

ChangesStruct createChangesStruct({
  int? id,
  String? recordId,
  String? action,
  String? field,
  String? oldValue,
  String? newValue,
  String? timestamp,
  String? user,
}) =>
    ChangesStruct(
      id: id,
      recordId: recordId,
      action: action,
      field: field,
      oldValue: oldValue,
      newValue: newValue,
      timestamp: timestamp,
      user: user,
    );
