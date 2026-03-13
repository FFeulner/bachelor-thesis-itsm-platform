// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StandortStruct extends BaseStruct {
  StandortStruct({
    String? recID,
    String? creatorID,
    String? name,
    String? firmaRecID,
    String? strasse,
    int? hausnummer,
    int? plz,
    String? ort,
    String? land,
    String? parkmoeglichkeiten,
    bool? hauptstandort,
  })  : _recID = recID,
        _creatorID = creatorID,
        _name = name,
        _firmaRecID = firmaRecID,
        _strasse = strasse,
        _hausnummer = hausnummer,
        _plz = plz,
        _ort = ort,
        _land = land,
        _parkmoeglichkeiten = parkmoeglichkeiten,
        _hauptstandort = hauptstandort;

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

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Strasse" field.
  String? _strasse;
  String get strasse => _strasse ?? '';
  set strasse(String? val) => _strasse = val;

  bool hasStrasse() => _strasse != null;

  // "Hausnummer" field.
  int? _hausnummer;
  int get hausnummer => _hausnummer ?? 0;
  set hausnummer(int? val) => _hausnummer = val;

  void incrementHausnummer(int amount) => hausnummer = hausnummer + amount;

  bool hasHausnummer() => _hausnummer != null;

  // "PLZ" field.
  int? _plz;
  int get plz => _plz ?? 0;
  set plz(int? val) => _plz = val;

  void incrementPlz(int amount) => plz = plz + amount;

  bool hasPlz() => _plz != null;

  // "Ort" field.
  String? _ort;
  String get ort => _ort ?? '';
  set ort(String? val) => _ort = val;

  bool hasOrt() => _ort != null;

  // "Land" field.
  String? _land;
  String get land => _land ?? '';
  set land(String? val) => _land = val;

  bool hasLand() => _land != null;

  // "Parkmoeglichkeiten" field.
  String? _parkmoeglichkeiten;
  String get parkmoeglichkeiten => _parkmoeglichkeiten ?? '';
  set parkmoeglichkeiten(String? val) => _parkmoeglichkeiten = val;

  bool hasParkmoeglichkeiten() => _parkmoeglichkeiten != null;

  // "Hauptstandort" field.
  bool? _hauptstandort;
  bool get hauptstandort => _hauptstandort ?? false;
  set hauptstandort(bool? val) => _hauptstandort = val;

  bool hasHauptstandort() => _hauptstandort != null;

  static StandortStruct fromMap(Map<String, dynamic> data) => StandortStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        name: data['Name'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        strasse: data['Strasse'] as String?,
        hausnummer: castToType<int>(data['Hausnummer']),
        plz: castToType<int>(data['PLZ']),
        ort: data['Ort'] as String?,
        land: data['Land'] as String?,
        parkmoeglichkeiten: data['Parkmoeglichkeiten'] as String?,
        hauptstandort: data['Hauptstandort'] as bool?,
      );

  static StandortStruct? maybeFromMap(dynamic data) =>
      data is Map ? StandortStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Name': _name,
        'Firma_RecID': _firmaRecID,
        'Strasse': _strasse,
        'Hausnummer': _hausnummer,
        'PLZ': _plz,
        'Ort': _ort,
        'Land': _land,
        'Parkmoeglichkeiten': _parkmoeglichkeiten,
        'Hauptstandort': _hauptstandort,
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
        'Firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Strasse': serializeParam(
          _strasse,
          ParamType.String,
        ),
        'Hausnummer': serializeParam(
          _hausnummer,
          ParamType.int,
        ),
        'PLZ': serializeParam(
          _plz,
          ParamType.int,
        ),
        'Ort': serializeParam(
          _ort,
          ParamType.String,
        ),
        'Land': serializeParam(
          _land,
          ParamType.String,
        ),
        'Parkmoeglichkeiten': serializeParam(
          _parkmoeglichkeiten,
          ParamType.String,
        ),
        'Hauptstandort': serializeParam(
          _hauptstandort,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StandortStruct fromSerializableMap(Map<String, dynamic> data) =>
      StandortStruct(
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
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
          ParamType.String,
          false,
        ),
        strasse: deserializeParam(
          data['Strasse'],
          ParamType.String,
          false,
        ),
        hausnummer: deserializeParam(
          data['Hausnummer'],
          ParamType.int,
          false,
        ),
        plz: deserializeParam(
          data['PLZ'],
          ParamType.int,
          false,
        ),
        ort: deserializeParam(
          data['Ort'],
          ParamType.String,
          false,
        ),
        land: deserializeParam(
          data['Land'],
          ParamType.String,
          false,
        ),
        parkmoeglichkeiten: deserializeParam(
          data['Parkmoeglichkeiten'],
          ParamType.String,
          false,
        ),
        hauptstandort: deserializeParam(
          data['Hauptstandort'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StandortStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StandortStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        name == other.name &&
        firmaRecID == other.firmaRecID &&
        strasse == other.strasse &&
        hausnummer == other.hausnummer &&
        plz == other.plz &&
        ort == other.ort &&
        land == other.land &&
        parkmoeglichkeiten == other.parkmoeglichkeiten &&
        hauptstandort == other.hauptstandort;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creatorID,
        name,
        firmaRecID,
        strasse,
        hausnummer,
        plz,
        ort,
        land,
        parkmoeglichkeiten,
        hauptstandort
      ]);
}

StandortStruct createStandortStruct({
  String? recID,
  String? creatorID,
  String? name,
  String? firmaRecID,
  String? strasse,
  int? hausnummer,
  int? plz,
  String? ort,
  String? land,
  String? parkmoeglichkeiten,
  bool? hauptstandort,
}) =>
    StandortStruct(
      recID: recID,
      creatorID: creatorID,
      name: name,
      firmaRecID: firmaRecID,
      strasse: strasse,
      hausnummer: hausnummer,
      plz: plz,
      ort: ort,
      land: land,
      parkmoeglichkeiten: parkmoeglichkeiten,
      hauptstandort: hauptstandort,
    );
