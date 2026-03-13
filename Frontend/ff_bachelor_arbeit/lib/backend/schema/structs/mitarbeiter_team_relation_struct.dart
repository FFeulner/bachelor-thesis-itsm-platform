// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MitarbeiterTeamRelationStruct extends BaseStruct {
  MitarbeiterTeamRelationStruct({
    String? employeeId,
    List<MitarbeiterTeamRelationAssignedStruct>? assigned,
    List<MitarbeiterTeamRelationAvailableStruct>? available,
  })  : _employeeId = employeeId,
        _assigned = assigned,
        _available = available;

  // "employee_id" field.
  String? _employeeId;
  String get employeeId => _employeeId ?? '';
  set employeeId(String? val) => _employeeId = val;

  bool hasEmployeeId() => _employeeId != null;

  // "assigned" field.
  List<MitarbeiterTeamRelationAssignedStruct>? _assigned;
  List<MitarbeiterTeamRelationAssignedStruct> get assigned =>
      _assigned ?? const [];
  set assigned(List<MitarbeiterTeamRelationAssignedStruct>? val) =>
      _assigned = val;

  void updateAssigned(
      Function(List<MitarbeiterTeamRelationAssignedStruct>) updateFn) {
    updateFn(_assigned ??= []);
  }

  bool hasAssigned() => _assigned != null;

  // "available" field.
  List<MitarbeiterTeamRelationAvailableStruct>? _available;
  List<MitarbeiterTeamRelationAvailableStruct> get available =>
      _available ?? const [];
  set available(List<MitarbeiterTeamRelationAvailableStruct>? val) =>
      _available = val;

  void updateAvailable(
      Function(List<MitarbeiterTeamRelationAvailableStruct>) updateFn) {
    updateFn(_available ??= []);
  }

  bool hasAvailable() => _available != null;

  static MitarbeiterTeamRelationStruct fromMap(Map<String, dynamic> data) =>
      MitarbeiterTeamRelationStruct(
        employeeId: data['employee_id'] as String?,
        assigned: getStructList(
          data['assigned'],
          MitarbeiterTeamRelationAssignedStruct.fromMap,
        ),
        available: getStructList(
          data['available'],
          MitarbeiterTeamRelationAvailableStruct.fromMap,
        ),
      );

  static MitarbeiterTeamRelationStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? MitarbeiterTeamRelationStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'employee_id': _employeeId,
        'assigned': _assigned?.map((e) => e.toMap()).toList(),
        'available': _available?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'employee_id': serializeParam(
          _employeeId,
          ParamType.String,
        ),
        'assigned': serializeParam(
          _assigned,
          ParamType.DataStruct,
          isList: true,
        ),
        'available': serializeParam(
          _available,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static MitarbeiterTeamRelationStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MitarbeiterTeamRelationStruct(
        employeeId: deserializeParam(
          data['employee_id'],
          ParamType.String,
          false,
        ),
        assigned: deserializeStructParam<MitarbeiterTeamRelationAssignedStruct>(
          data['assigned'],
          ParamType.DataStruct,
          true,
          structBuilder:
              MitarbeiterTeamRelationAssignedStruct.fromSerializableMap,
        ),
        available:
            deserializeStructParam<MitarbeiterTeamRelationAvailableStruct>(
          data['available'],
          ParamType.DataStruct,
          true,
          structBuilder:
              MitarbeiterTeamRelationAvailableStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'MitarbeiterTeamRelationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is MitarbeiterTeamRelationStruct &&
        employeeId == other.employeeId &&
        listEquality.equals(assigned, other.assigned) &&
        listEquality.equals(available, other.available);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([employeeId, assigned, available]);
}

MitarbeiterTeamRelationStruct createMitarbeiterTeamRelationStruct({
  String? employeeId,
}) =>
    MitarbeiterTeamRelationStruct(
      employeeId: employeeId,
    );
