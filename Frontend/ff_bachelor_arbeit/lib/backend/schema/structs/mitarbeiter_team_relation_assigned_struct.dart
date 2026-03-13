// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MitarbeiterTeamRelationAssignedStruct extends BaseStruct {
  MitarbeiterTeamRelationAssignedStruct({
    TeamStruct? team,
    String? rolleId,
  })  : _team = team,
        _rolleId = rolleId;

  // "team" field.
  TeamStruct? _team;
  TeamStruct get team => _team ?? TeamStruct();
  set team(TeamStruct? val) => _team = val;

  void updateTeam(Function(TeamStruct) updateFn) {
    updateFn(_team ??= TeamStruct());
  }

  bool hasTeam() => _team != null;

  // "rolle_id" field.
  String? _rolleId;
  String get rolleId => _rolleId ?? '';
  set rolleId(String? val) => _rolleId = val;

  bool hasRolleId() => _rolleId != null;

  static MitarbeiterTeamRelationAssignedStruct fromMap(
          Map<String, dynamic> data) =>
      MitarbeiterTeamRelationAssignedStruct(
        team: data['team'] is TeamStruct
            ? data['team']
            : TeamStruct.maybeFromMap(data['team']),
        rolleId: data['rolle_id'] as String?,
      );

  static MitarbeiterTeamRelationAssignedStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? MitarbeiterTeamRelationAssignedStruct.fromMap(
              data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'team': _team?.toMap(),
        'rolle_id': _rolleId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'team': serializeParam(
          _team,
          ParamType.DataStruct,
        ),
        'rolle_id': serializeParam(
          _rolleId,
          ParamType.String,
        ),
      }.withoutNulls;

  static MitarbeiterTeamRelationAssignedStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      MitarbeiterTeamRelationAssignedStruct(
        team: deserializeStructParam(
          data['team'],
          ParamType.DataStruct,
          false,
          structBuilder: TeamStruct.fromSerializableMap,
        ),
        rolleId: deserializeParam(
          data['rolle_id'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MitarbeiterTeamRelationAssignedStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MitarbeiterTeamRelationAssignedStruct &&
        team == other.team &&
        rolleId == other.rolleId;
  }

  @override
  int get hashCode => const ListEquality().hash([team, rolleId]);
}

MitarbeiterTeamRelationAssignedStruct
    createMitarbeiterTeamRelationAssignedStruct({
  TeamStruct? team,
  String? rolleId,
}) =>
        MitarbeiterTeamRelationAssignedStruct(
          team: team ?? TeamStruct(),
          rolleId: rolleId,
        );
