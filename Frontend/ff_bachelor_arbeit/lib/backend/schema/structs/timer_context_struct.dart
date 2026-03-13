// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TimerContextStruct extends BaseStruct {
  TimerContextStruct({
    String? objectType,
    String? objectId,
    String? objectName,
    DateTime? startTime,
    bool? isrunning,
    int? elapsedSeconds,
  })  : _objectType = objectType,
        _objectId = objectId,
        _objectName = objectName,
        _startTime = startTime,
        _isrunning = isrunning,
        _elapsedSeconds = elapsedSeconds;

  // "objectType" field.
  String? _objectType;
  String get objectType => _objectType ?? '';
  set objectType(String? val) => _objectType = val;

  bool hasObjectType() => _objectType != null;

  // "objectId" field.
  String? _objectId;
  String get objectId => _objectId ?? '';
  set objectId(String? val) => _objectId = val;

  bool hasObjectId() => _objectId != null;

  // "objectName" field.
  String? _objectName;
  String get objectName => _objectName ?? '';
  set objectName(String? val) => _objectName = val;

  bool hasObjectName() => _objectName != null;

  // "startTime" field.
  DateTime? _startTime;
  DateTime? get startTime => _startTime;
  set startTime(DateTime? val) => _startTime = val;

  bool hasStartTime() => _startTime != null;

  // "isrunning" field.
  bool? _isrunning;
  bool get isrunning => _isrunning ?? false;
  set isrunning(bool? val) => _isrunning = val;

  bool hasIsrunning() => _isrunning != null;

  // "elapsedSeconds" field.
  int? _elapsedSeconds;
  int get elapsedSeconds => _elapsedSeconds ?? 0;
  set elapsedSeconds(int? val) => _elapsedSeconds = val;

  void incrementElapsedSeconds(int amount) =>
      elapsedSeconds = elapsedSeconds + amount;

  bool hasElapsedSeconds() => _elapsedSeconds != null;

  static TimerContextStruct fromMap(Map<String, dynamic> data) =>
      TimerContextStruct(
        objectType: data['objectType'] as String?,
        objectId: data['objectId'] as String?,
        objectName: data['objectName'] as String?,
        startTime: data['startTime'] as DateTime?,
        isrunning: data['isrunning'] as bool?,
        elapsedSeconds: castToType<int>(data['elapsedSeconds']),
      );

  static TimerContextStruct? maybeFromMap(dynamic data) => data is Map
      ? TimerContextStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'objectType': _objectType,
        'objectId': _objectId,
        'objectName': _objectName,
        'startTime': _startTime,
        'isrunning': _isrunning,
        'elapsedSeconds': _elapsedSeconds,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'objectType': serializeParam(
          _objectType,
          ParamType.String,
        ),
        'objectId': serializeParam(
          _objectId,
          ParamType.String,
        ),
        'objectName': serializeParam(
          _objectName,
          ParamType.String,
        ),
        'startTime': serializeParam(
          _startTime,
          ParamType.DateTime,
        ),
        'isrunning': serializeParam(
          _isrunning,
          ParamType.bool,
        ),
        'elapsedSeconds': serializeParam(
          _elapsedSeconds,
          ParamType.int,
        ),
      }.withoutNulls;

  static TimerContextStruct fromSerializableMap(Map<String, dynamic> data) =>
      TimerContextStruct(
        objectType: deserializeParam(
          data['objectType'],
          ParamType.String,
          false,
        ),
        objectId: deserializeParam(
          data['objectId'],
          ParamType.String,
          false,
        ),
        objectName: deserializeParam(
          data['objectName'],
          ParamType.String,
          false,
        ),
        startTime: deserializeParam(
          data['startTime'],
          ParamType.DateTime,
          false,
        ),
        isrunning: deserializeParam(
          data['isrunning'],
          ParamType.bool,
          false,
        ),
        elapsedSeconds: deserializeParam(
          data['elapsedSeconds'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'TimerContextStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TimerContextStruct &&
        objectType == other.objectType &&
        objectId == other.objectId &&
        objectName == other.objectName &&
        startTime == other.startTime &&
        isrunning == other.isrunning &&
        elapsedSeconds == other.elapsedSeconds;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [objectType, objectId, objectName, startTime, isrunning, elapsedSeconds]);
}

TimerContextStruct createTimerContextStruct({
  String? objectType,
  String? objectId,
  String? objectName,
  DateTime? startTime,
  bool? isrunning,
  int? elapsedSeconds,
}) =>
    TimerContextStruct(
      objectType: objectType,
      objectId: objectId,
      objectName: objectName,
      startTime: startTime,
      isrunning: isrunning,
      elapsedSeconds: elapsedSeconds,
    );
