// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TodoStruct extends BaseStruct {
  TodoStruct({
    String? recID,
    String? mitarbeiterRecID,
    String? betreff,
    String? beschreibung,
    String? deadlineType,
    String? datumStart,
    String? datumEnde,
    int? dringlichkeitsIndex,
    String? typ,
    String? kundenMitarbeiterRecID,
    String? firmaRecID,
    bool? flexTermin,
    String? vorgangRecID,
  })  : _recID = recID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _betreff = betreff,
        _beschreibung = beschreibung,
        _deadlineType = deadlineType,
        _datumStart = datumStart,
        _datumEnde = datumEnde,
        _dringlichkeitsIndex = dringlichkeitsIndex,
        _typ = typ,
        _kundenMitarbeiterRecID = kundenMitarbeiterRecID,
        _firmaRecID = firmaRecID,
        _flexTermin = flexTermin,
        _vorgangRecID = vorgangRecID;

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

  // "Betreff" field.
  String? _betreff;
  String get betreff => _betreff ?? '';
  set betreff(String? val) => _betreff = val;

  bool hasBetreff() => _betreff != null;

  // "Beschreibung" field.
  String? _beschreibung;
  String get beschreibung => _beschreibung ?? '';
  set beschreibung(String? val) => _beschreibung = val;

  bool hasBeschreibung() => _beschreibung != null;

  // "Deadline_Type" field.
  String? _deadlineType;
  String get deadlineType => _deadlineType ?? '';
  set deadlineType(String? val) => _deadlineType = val;

  bool hasDeadlineType() => _deadlineType != null;

  // "Datum_Start" field.
  String? _datumStart;
  String get datumStart => _datumStart ?? '';
  set datumStart(String? val) => _datumStart = val;

  bool hasDatumStart() => _datumStart != null;

  // "Datum_Ende" field.
  String? _datumEnde;
  String get datumEnde => _datumEnde ?? '';
  set datumEnde(String? val) => _datumEnde = val;

  bool hasDatumEnde() => _datumEnde != null;

  // "dringlichkeits_index" field.
  int? _dringlichkeitsIndex;
  int get dringlichkeitsIndex => _dringlichkeitsIndex ?? 0;
  set dringlichkeitsIndex(int? val) => _dringlichkeitsIndex = val;

  void incrementDringlichkeitsIndex(int amount) =>
      dringlichkeitsIndex = dringlichkeitsIndex + amount;

  bool hasDringlichkeitsIndex() => _dringlichkeitsIndex != null;

  // "Typ" field.
  String? _typ;
  String get typ => _typ ?? '';
  set typ(String? val) => _typ = val;

  bool hasTyp() => _typ != null;

  // "kundenMitarbeiter_RecID" field.
  String? _kundenMitarbeiterRecID;
  String get kundenMitarbeiterRecID => _kundenMitarbeiterRecID ?? '';
  set kundenMitarbeiterRecID(String? val) => _kundenMitarbeiterRecID = val;

  bool hasKundenMitarbeiterRecID() => _kundenMitarbeiterRecID != null;

  // "firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Flex_Termin" field.
  bool? _flexTermin;
  bool get flexTermin => _flexTermin ?? false;
  set flexTermin(bool? val) => _flexTermin = val;

  bool hasFlexTermin() => _flexTermin != null;

  // "vorgang_RecID" field.
  String? _vorgangRecID;
  String get vorgangRecID => _vorgangRecID ?? '';
  set vorgangRecID(String? val) => _vorgangRecID = val;

  bool hasVorgangRecID() => _vorgangRecID != null;

  static TodoStruct fromMap(Map<String, dynamic> data) => TodoStruct(
        recID: data['RecID'] as String?,
        mitarbeiterRecID: data['mitarbeiter_RecID'] as String?,
        betreff: data['Betreff'] as String?,
        beschreibung: data['Beschreibung'] as String?,
        deadlineType: data['Deadline_Type'] as String?,
        datumStart: data['Datum_Start'] as String?,
        datumEnde: data['Datum_Ende'] as String?,
        dringlichkeitsIndex: castToType<int>(data['dringlichkeits_index']),
        typ: data['Typ'] as String?,
        kundenMitarbeiterRecID: data['kundenMitarbeiter_RecID'] as String?,
        firmaRecID: data['firma_RecID'] as String?,
        flexTermin: data['Flex_Termin'] as bool?,
        vorgangRecID: data['vorgang_RecID'] as String?,
      );

  static TodoStruct? maybeFromMap(dynamic data) =>
      data is Map ? TodoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'mitarbeiter_RecID': _mitarbeiterRecID,
        'Betreff': _betreff,
        'Beschreibung': _beschreibung,
        'Deadline_Type': _deadlineType,
        'Datum_Start': _datumStart,
        'Datum_Ende': _datumEnde,
        'dringlichkeits_index': _dringlichkeitsIndex,
        'Typ': _typ,
        'kundenMitarbeiter_RecID': _kundenMitarbeiterRecID,
        'firma_RecID': _firmaRecID,
        'Flex_Termin': _flexTermin,
        'vorgang_RecID': _vorgangRecID,
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
        'Betreff': serializeParam(
          _betreff,
          ParamType.String,
        ),
        'Beschreibung': serializeParam(
          _beschreibung,
          ParamType.String,
        ),
        'Deadline_Type': serializeParam(
          _deadlineType,
          ParamType.String,
        ),
        'Datum_Start': serializeParam(
          _datumStart,
          ParamType.String,
        ),
        'Datum_Ende': serializeParam(
          _datumEnde,
          ParamType.String,
        ),
        'dringlichkeits_index': serializeParam(
          _dringlichkeitsIndex,
          ParamType.int,
        ),
        'Typ': serializeParam(
          _typ,
          ParamType.String,
        ),
        'kundenMitarbeiter_RecID': serializeParam(
          _kundenMitarbeiterRecID,
          ParamType.String,
        ),
        'firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Flex_Termin': serializeParam(
          _flexTermin,
          ParamType.bool,
        ),
        'vorgang_RecID': serializeParam(
          _vorgangRecID,
          ParamType.String,
        ),
      }.withoutNulls;

  static TodoStruct fromSerializableMap(Map<String, dynamic> data) =>
      TodoStruct(
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
        betreff: deserializeParam(
          data['Betreff'],
          ParamType.String,
          false,
        ),
        beschreibung: deserializeParam(
          data['Beschreibung'],
          ParamType.String,
          false,
        ),
        deadlineType: deserializeParam(
          data['Deadline_Type'],
          ParamType.String,
          false,
        ),
        datumStart: deserializeParam(
          data['Datum_Start'],
          ParamType.String,
          false,
        ),
        datumEnde: deserializeParam(
          data['Datum_Ende'],
          ParamType.String,
          false,
        ),
        dringlichkeitsIndex: deserializeParam(
          data['dringlichkeits_index'],
          ParamType.int,
          false,
        ),
        typ: deserializeParam(
          data['Typ'],
          ParamType.String,
          false,
        ),
        kundenMitarbeiterRecID: deserializeParam(
          data['kundenMitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['firma_RecID'],
          ParamType.String,
          false,
        ),
        flexTermin: deserializeParam(
          data['Flex_Termin'],
          ParamType.bool,
          false,
        ),
        vorgangRecID: deserializeParam(
          data['vorgang_RecID'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'TodoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TodoStruct &&
        recID == other.recID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        betreff == other.betreff &&
        beschreibung == other.beschreibung &&
        deadlineType == other.deadlineType &&
        datumStart == other.datumStart &&
        datumEnde == other.datumEnde &&
        dringlichkeitsIndex == other.dringlichkeitsIndex &&
        typ == other.typ &&
        kundenMitarbeiterRecID == other.kundenMitarbeiterRecID &&
        firmaRecID == other.firmaRecID &&
        flexTermin == other.flexTermin &&
        vorgangRecID == other.vorgangRecID;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        mitarbeiterRecID,
        betreff,
        beschreibung,
        deadlineType,
        datumStart,
        datumEnde,
        dringlichkeitsIndex,
        typ,
        kundenMitarbeiterRecID,
        firmaRecID,
        flexTermin,
        vorgangRecID
      ]);
}

TodoStruct createTodoStruct({
  String? recID,
  String? mitarbeiterRecID,
  String? betreff,
  String? beschreibung,
  String? deadlineType,
  String? datumStart,
  String? datumEnde,
  int? dringlichkeitsIndex,
  String? typ,
  String? kundenMitarbeiterRecID,
  String? firmaRecID,
  bool? flexTermin,
  String? vorgangRecID,
}) =>
    TodoStruct(
      recID: recID,
      mitarbeiterRecID: mitarbeiterRecID,
      betreff: betreff,
      beschreibung: beschreibung,
      deadlineType: deadlineType,
      datumStart: datumStart,
      datumEnde: datumEnde,
      dringlichkeitsIndex: dringlichkeitsIndex,
      typ: typ,
      kundenMitarbeiterRecID: kundenMitarbeiterRecID,
      firmaRecID: firmaRecID,
      flexTermin: flexTermin,
      vorgangRecID: vorgangRecID,
    );
