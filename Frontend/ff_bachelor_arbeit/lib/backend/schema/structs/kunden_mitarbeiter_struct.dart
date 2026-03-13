// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class KundenMitarbeiterStruct extends BaseStruct {
  KundenMitarbeiterStruct({
    String? recID,
    String? creatorID,
    String? nachname,
    String? vorname,
    String? firmaRecID,
    String? kommunikationAnrede,
    String? kommunikationVerabschiedung,
    String? rolle,
    String? notizen,
    String? telefon,
    String? mobil,
    String? eMail,
    String? eintritt,
    String? austritt,
    bool? vip,
    String? ganzerName,
  })  : _recID = recID,
        _creatorID = creatorID,
        _nachname = nachname,
        _vorname = vorname,
        _firmaRecID = firmaRecID,
        _kommunikationAnrede = kommunikationAnrede,
        _kommunikationVerabschiedung = kommunikationVerabschiedung,
        _rolle = rolle,
        _notizen = notizen,
        _telefon = telefon,
        _mobil = mobil,
        _eMail = eMail,
        _eintritt = eintritt,
        _austritt = austritt,
        _vip = vip,
        _ganzerName = ganzerName;

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

  // "Nachname" field.
  String? _nachname;
  String get nachname => _nachname ?? '';
  set nachname(String? val) => _nachname = val;

  bool hasNachname() => _nachname != null;

  // "Vorname" field.
  String? _vorname;
  String get vorname => _vorname ?? '';
  set vorname(String? val) => _vorname = val;

  bool hasVorname() => _vorname != null;

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Kommunikation_Anrede" field.
  String? _kommunikationAnrede;
  String get kommunikationAnrede => _kommunikationAnrede ?? '';
  set kommunikationAnrede(String? val) => _kommunikationAnrede = val;

  bool hasKommunikationAnrede() => _kommunikationAnrede != null;

  // "Kommunikation_Verabschiedung" field.
  String? _kommunikationVerabschiedung;
  String get kommunikationVerabschiedung => _kommunikationVerabschiedung ?? '';
  set kommunikationVerabschiedung(String? val) =>
      _kommunikationVerabschiedung = val;

  bool hasKommunikationVerabschiedung() => _kommunikationVerabschiedung != null;

  // "Rolle" field.
  String? _rolle;
  String get rolle => _rolle ?? '';
  set rolle(String? val) => _rolle = val;

  bool hasRolle() => _rolle != null;

  // "Notizen" field.
  String? _notizen;
  String get notizen => _notizen ?? '';
  set notizen(String? val) => _notizen = val;

  bool hasNotizen() => _notizen != null;

  // "Telefon" field.
  String? _telefon;
  String get telefon => _telefon ?? '';
  set telefon(String? val) => _telefon = val;

  bool hasTelefon() => _telefon != null;

  // "Mobil" field.
  String? _mobil;
  String get mobil => _mobil ?? '';
  set mobil(String? val) => _mobil = val;

  bool hasMobil() => _mobil != null;

  // "e-mail" field.
  String? _eMail;
  String get eMail => _eMail ?? '';
  set eMail(String? val) => _eMail = val;

  bool hasEMail() => _eMail != null;

  // "Eintritt" field.
  String? _eintritt;
  String get eintritt => _eintritt ?? '';
  set eintritt(String? val) => _eintritt = val;

  bool hasEintritt() => _eintritt != null;

  // "Austritt" field.
  String? _austritt;
  String get austritt => _austritt ?? '';
  set austritt(String? val) => _austritt = val;

  bool hasAustritt() => _austritt != null;

  // "VIP" field.
  bool? _vip;
  bool get vip => _vip ?? false;
  set vip(bool? val) => _vip = val;

  bool hasVip() => _vip != null;

  // "Ganzer_name" field.
  String? _ganzerName;
  String get ganzerName => _ganzerName ?? '';
  set ganzerName(String? val) => _ganzerName = val;

  bool hasGanzerName() => _ganzerName != null;

  static KundenMitarbeiterStruct fromMap(Map<String, dynamic> data) =>
      KundenMitarbeiterStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        nachname: data['Nachname'] as String?,
        vorname: data['Vorname'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        kommunikationAnrede: data['Kommunikation_Anrede'] as String?,
        kommunikationVerabschiedung:
            data['Kommunikation_Verabschiedung'] as String?,
        rolle: data['Rolle'] as String?,
        notizen: data['Notizen'] as String?,
        telefon: data['Telefon'] as String?,
        mobil: data['Mobil'] as String?,
        eMail: data['e-mail'] as String?,
        eintritt: data['Eintritt'] as String?,
        austritt: data['Austritt'] as String?,
        vip: data['VIP'] as bool?,
        ganzerName: data['Ganzer_name'] as String?,
      );

  static KundenMitarbeiterStruct? maybeFromMap(dynamic data) => data is Map
      ? KundenMitarbeiterStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Nachname': _nachname,
        'Vorname': _vorname,
        'Firma_RecID': _firmaRecID,
        'Kommunikation_Anrede': _kommunikationAnrede,
        'Kommunikation_Verabschiedung': _kommunikationVerabschiedung,
        'Rolle': _rolle,
        'Notizen': _notizen,
        'Telefon': _telefon,
        'Mobil': _mobil,
        'e-mail': _eMail,
        'Eintritt': _eintritt,
        'Austritt': _austritt,
        'VIP': _vip,
        'Ganzer_name': _ganzerName,
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
        'Nachname': serializeParam(
          _nachname,
          ParamType.String,
        ),
        'Vorname': serializeParam(
          _vorname,
          ParamType.String,
        ),
        'Firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Kommunikation_Anrede': serializeParam(
          _kommunikationAnrede,
          ParamType.String,
        ),
        'Kommunikation_Verabschiedung': serializeParam(
          _kommunikationVerabschiedung,
          ParamType.String,
        ),
        'Rolle': serializeParam(
          _rolle,
          ParamType.String,
        ),
        'Notizen': serializeParam(
          _notizen,
          ParamType.String,
        ),
        'Telefon': serializeParam(
          _telefon,
          ParamType.String,
        ),
        'Mobil': serializeParam(
          _mobil,
          ParamType.String,
        ),
        'e-mail': serializeParam(
          _eMail,
          ParamType.String,
        ),
        'Eintritt': serializeParam(
          _eintritt,
          ParamType.String,
        ),
        'Austritt': serializeParam(
          _austritt,
          ParamType.String,
        ),
        'VIP': serializeParam(
          _vip,
          ParamType.bool,
        ),
        'Ganzer_name': serializeParam(
          _ganzerName,
          ParamType.String,
        ),
      }.withoutNulls;

  static KundenMitarbeiterStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      KundenMitarbeiterStruct(
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
        nachname: deserializeParam(
          data['Nachname'],
          ParamType.String,
          false,
        ),
        vorname: deserializeParam(
          data['Vorname'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
          ParamType.String,
          false,
        ),
        kommunikationAnrede: deserializeParam(
          data['Kommunikation_Anrede'],
          ParamType.String,
          false,
        ),
        kommunikationVerabschiedung: deserializeParam(
          data['Kommunikation_Verabschiedung'],
          ParamType.String,
          false,
        ),
        rolle: deserializeParam(
          data['Rolle'],
          ParamType.String,
          false,
        ),
        notizen: deserializeParam(
          data['Notizen'],
          ParamType.String,
          false,
        ),
        telefon: deserializeParam(
          data['Telefon'],
          ParamType.String,
          false,
        ),
        mobil: deserializeParam(
          data['Mobil'],
          ParamType.String,
          false,
        ),
        eMail: deserializeParam(
          data['e-mail'],
          ParamType.String,
          false,
        ),
        eintritt: deserializeParam(
          data['Eintritt'],
          ParamType.String,
          false,
        ),
        austritt: deserializeParam(
          data['Austritt'],
          ParamType.String,
          false,
        ),
        vip: deserializeParam(
          data['VIP'],
          ParamType.bool,
          false,
        ),
        ganzerName: deserializeParam(
          data['Ganzer_name'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'KundenMitarbeiterStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is KundenMitarbeiterStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        nachname == other.nachname &&
        vorname == other.vorname &&
        firmaRecID == other.firmaRecID &&
        kommunikationAnrede == other.kommunikationAnrede &&
        kommunikationVerabschiedung == other.kommunikationVerabschiedung &&
        rolle == other.rolle &&
        notizen == other.notizen &&
        telefon == other.telefon &&
        mobil == other.mobil &&
        eMail == other.eMail &&
        eintritt == other.eintritt &&
        austritt == other.austritt &&
        vip == other.vip &&
        ganzerName == other.ganzerName;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creatorID,
        nachname,
        vorname,
        firmaRecID,
        kommunikationAnrede,
        kommunikationVerabschiedung,
        rolle,
        notizen,
        telefon,
        mobil,
        eMail,
        eintritt,
        austritt,
        vip,
        ganzerName
      ]);
}

KundenMitarbeiterStruct createKundenMitarbeiterStruct({
  String? recID,
  String? creatorID,
  String? nachname,
  String? vorname,
  String? firmaRecID,
  String? kommunikationAnrede,
  String? kommunikationVerabschiedung,
  String? rolle,
  String? notizen,
  String? telefon,
  String? mobil,
  String? eMail,
  String? eintritt,
  String? austritt,
  bool? vip,
  String? ganzerName,
}) =>
    KundenMitarbeiterStruct(
      recID: recID,
      creatorID: creatorID,
      nachname: nachname,
      vorname: vorname,
      firmaRecID: firmaRecID,
      kommunikationAnrede: kommunikationAnrede,
      kommunikationVerabschiedung: kommunikationVerabschiedung,
      rolle: rolle,
      notizen: notizen,
      telefon: telefon,
      mobil: mobil,
      eMail: eMail,
      eintritt: eintritt,
      austritt: austritt,
      vip: vip,
      ganzerName: ganzerName,
    );
