// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class VorgangStruct extends BaseStruct {
  VorgangStruct({
    String? recID,
    String? creatorID,
    String? betreff,
    String? beschreibungMD,
    String? kundenMitarbeiterRecID,
    String? mitarbeiterRecID,
    String? teamRecID,
    String? firmaRecID,
    String? ticketTag,
    String? status,
    String? priorisierung,
    String? kategorie,
    String? notiz,
    List<String>? weitereKundenMitarbeiterRecID,
    String? feedbackGeloestDurchRecID,
    String? loesung,
  })  : _recID = recID,
        _creatorID = creatorID,
        _betreff = betreff,
        _beschreibungMD = beschreibungMD,
        _kundenMitarbeiterRecID = kundenMitarbeiterRecID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _teamRecID = teamRecID,
        _firmaRecID = firmaRecID,
        _ticketTag = ticketTag,
        _status = status,
        _priorisierung = priorisierung,
        _kategorie = kategorie,
        _notiz = notiz,
        _weitereKundenMitarbeiterRecID = weitereKundenMitarbeiterRecID,
        _feedbackGeloestDurchRecID = feedbackGeloestDurchRecID,
        _loesung = loesung;

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

  // "Betreff" field.
  String? _betreff;
  String get betreff => _betreff ?? '';
  set betreff(String? val) => _betreff = val;

  bool hasBetreff() => _betreff != null;

  // "Beschreibung_MD" field.
  String? _beschreibungMD;
  String get beschreibungMD => _beschreibungMD ?? '';
  set beschreibungMD(String? val) => _beschreibungMD = val;

  bool hasBeschreibungMD() => _beschreibungMD != null;

  // "Kunden-Mitarbeiter_RecID" field.
  String? _kundenMitarbeiterRecID;
  String get kundenMitarbeiterRecID => _kundenMitarbeiterRecID ?? '';
  set kundenMitarbeiterRecID(String? val) => _kundenMitarbeiterRecID = val;

  bool hasKundenMitarbeiterRecID() => _kundenMitarbeiterRecID != null;

  // "Mitarbeiter_RecID" field.
  String? _mitarbeiterRecID;
  String get mitarbeiterRecID => _mitarbeiterRecID ?? '';
  set mitarbeiterRecID(String? val) => _mitarbeiterRecID = val;

  bool hasMitarbeiterRecID() => _mitarbeiterRecID != null;

  // "Team_RecID" field.
  String? _teamRecID;
  String get teamRecID => _teamRecID ?? '';
  set teamRecID(String? val) => _teamRecID = val;

  bool hasTeamRecID() => _teamRecID != null;

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "Ticket_Tag" field.
  String? _ticketTag;
  String get ticketTag => _ticketTag ?? '';
  set ticketTag(String? val) => _ticketTag = val;

  bool hasTicketTag() => _ticketTag != null;

  // "Status" field.
  String? _status;
  String get status => _status ?? 'neu';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "Priorisierung" field.
  String? _priorisierung;
  String get priorisierung => _priorisierung ?? '';
  set priorisierung(String? val) => _priorisierung = val;

  bool hasPriorisierung() => _priorisierung != null;

  // "Kategorie" field.
  String? _kategorie;
  String get kategorie => _kategorie ?? '';
  set kategorie(String? val) => _kategorie = val;

  bool hasKategorie() => _kategorie != null;

  // "Notiz" field.
  String? _notiz;
  String get notiz => _notiz ?? '';
  set notiz(String? val) => _notiz = val;

  bool hasNotiz() => _notiz != null;

  // "Weitere_Kunden_Mitarbeiter_RecID" field.
  List<String>? _weitereKundenMitarbeiterRecID;
  List<String> get weitereKundenMitarbeiterRecID =>
      _weitereKundenMitarbeiterRecID ?? const [];
  set weitereKundenMitarbeiterRecID(List<String>? val) =>
      _weitereKundenMitarbeiterRecID = val;

  void updateWeitereKundenMitarbeiterRecID(Function(List<String>) updateFn) {
    updateFn(_weitereKundenMitarbeiterRecID ??= []);
  }

  bool hasWeitereKundenMitarbeiterRecID() =>
      _weitereKundenMitarbeiterRecID != null;

  // "Feedback_geloest_durchRecID" field.
  String? _feedbackGeloestDurchRecID;
  String get feedbackGeloestDurchRecID => _feedbackGeloestDurchRecID ?? '';
  set feedbackGeloestDurchRecID(String? val) =>
      _feedbackGeloestDurchRecID = val;

  bool hasFeedbackGeloestDurchRecID() => _feedbackGeloestDurchRecID != null;

  // "Loesung" field.
  String? _loesung;
  String get loesung => _loesung ?? '';
  set loesung(String? val) => _loesung = val;

  bool hasLoesung() => _loesung != null;

  static VorgangStruct fromMap(Map<String, dynamic> data) => VorgangStruct(
        recID: data['RecID'] as String?,
        creatorID: data['CreatorID'] as String?,
        betreff: data['Betreff'] as String?,
        beschreibungMD: data['Beschreibung_MD'] as String?,
        kundenMitarbeiterRecID: data['Kunden-Mitarbeiter_RecID'] as String?,
        mitarbeiterRecID: data['Mitarbeiter_RecID'] as String?,
        teamRecID: data['Team_RecID'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        ticketTag: data['Ticket_Tag'] as String?,
        status: data['Status'] as String?,
        priorisierung: data['Priorisierung'] as String?,
        kategorie: data['Kategorie'] as String?,
        notiz: data['Notiz'] as String?,
        weitereKundenMitarbeiterRecID:
            getDataList(data['Weitere_Kunden_Mitarbeiter_RecID']),
        feedbackGeloestDurchRecID:
            data['Feedback_geloest_durchRecID'] as String?,
        loesung: data['Loesung'] as String?,
      );

  static VorgangStruct? maybeFromMap(dynamic data) =>
      data is Map ? VorgangStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorID': _creatorID,
        'Betreff': _betreff,
        'Beschreibung_MD': _beschreibungMD,
        'Kunden-Mitarbeiter_RecID': _kundenMitarbeiterRecID,
        'Mitarbeiter_RecID': _mitarbeiterRecID,
        'Team_RecID': _teamRecID,
        'Firma_RecID': _firmaRecID,
        'Ticket_Tag': _ticketTag,
        'Status': _status,
        'Priorisierung': _priorisierung,
        'Kategorie': _kategorie,
        'Notiz': _notiz,
        'Weitere_Kunden_Mitarbeiter_RecID': _weitereKundenMitarbeiterRecID,
        'Feedback_geloest_durchRecID': _feedbackGeloestDurchRecID,
        'Loesung': _loesung,
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
        'Betreff': serializeParam(
          _betreff,
          ParamType.String,
        ),
        'Beschreibung_MD': serializeParam(
          _beschreibungMD,
          ParamType.String,
        ),
        'Kunden-Mitarbeiter_RecID': serializeParam(
          _kundenMitarbeiterRecID,
          ParamType.String,
        ),
        'Mitarbeiter_RecID': serializeParam(
          _mitarbeiterRecID,
          ParamType.String,
        ),
        'Team_RecID': serializeParam(
          _teamRecID,
          ParamType.String,
        ),
        'Firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'Ticket_Tag': serializeParam(
          _ticketTag,
          ParamType.String,
        ),
        'Status': serializeParam(
          _status,
          ParamType.String,
        ),
        'Priorisierung': serializeParam(
          _priorisierung,
          ParamType.String,
        ),
        'Kategorie': serializeParam(
          _kategorie,
          ParamType.String,
        ),
        'Notiz': serializeParam(
          _notiz,
          ParamType.String,
        ),
        'Weitere_Kunden_Mitarbeiter_RecID': serializeParam(
          _weitereKundenMitarbeiterRecID,
          ParamType.String,
          isList: true,
        ),
        'Feedback_geloest_durchRecID': serializeParam(
          _feedbackGeloestDurchRecID,
          ParamType.String,
        ),
        'Loesung': serializeParam(
          _loesung,
          ParamType.String,
        ),
      }.withoutNulls;

  static VorgangStruct fromSerializableMap(Map<String, dynamic> data) =>
      VorgangStruct(
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
        betreff: deserializeParam(
          data['Betreff'],
          ParamType.String,
          false,
        ),
        beschreibungMD: deserializeParam(
          data['Beschreibung_MD'],
          ParamType.String,
          false,
        ),
        kundenMitarbeiterRecID: deserializeParam(
          data['Kunden-Mitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        mitarbeiterRecID: deserializeParam(
          data['Mitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        teamRecID: deserializeParam(
          data['Team_RecID'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
          ParamType.String,
          false,
        ),
        ticketTag: deserializeParam(
          data['Ticket_Tag'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['Status'],
          ParamType.String,
          false,
        ),
        priorisierung: deserializeParam(
          data['Priorisierung'],
          ParamType.String,
          false,
        ),
        kategorie: deserializeParam(
          data['Kategorie'],
          ParamType.String,
          false,
        ),
        notiz: deserializeParam(
          data['Notiz'],
          ParamType.String,
          false,
        ),
        weitereKundenMitarbeiterRecID: deserializeParam<String>(
          data['Weitere_Kunden_Mitarbeiter_RecID'],
          ParamType.String,
          true,
        ),
        feedbackGeloestDurchRecID: deserializeParam(
          data['Feedback_geloest_durchRecID'],
          ParamType.String,
          false,
        ),
        loesung: deserializeParam(
          data['Loesung'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'VorgangStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is VorgangStruct &&
        recID == other.recID &&
        creatorID == other.creatorID &&
        betreff == other.betreff &&
        beschreibungMD == other.beschreibungMD &&
        kundenMitarbeiterRecID == other.kundenMitarbeiterRecID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        teamRecID == other.teamRecID &&
        firmaRecID == other.firmaRecID &&
        ticketTag == other.ticketTag &&
        status == other.status &&
        priorisierung == other.priorisierung &&
        kategorie == other.kategorie &&
        notiz == other.notiz &&
        listEquality.equals(weitereKundenMitarbeiterRecID,
            other.weitereKundenMitarbeiterRecID) &&
        feedbackGeloestDurchRecID == other.feedbackGeloestDurchRecID &&
        loesung == other.loesung;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creatorID,
        betreff,
        beschreibungMD,
        kundenMitarbeiterRecID,
        mitarbeiterRecID,
        teamRecID,
        firmaRecID,
        ticketTag,
        status,
        priorisierung,
        kategorie,
        notiz,
        weitereKundenMitarbeiterRecID,
        feedbackGeloestDurchRecID,
        loesung
      ]);
}

VorgangStruct createVorgangStruct({
  String? recID,
  String? creatorID,
  String? betreff,
  String? beschreibungMD,
  String? kundenMitarbeiterRecID,
  String? mitarbeiterRecID,
  String? teamRecID,
  String? firmaRecID,
  String? ticketTag,
  String? status,
  String? priorisierung,
  String? kategorie,
  String? notiz,
  String? feedbackGeloestDurchRecID,
  String? loesung,
}) =>
    VorgangStruct(
      recID: recID,
      creatorID: creatorID,
      betreff: betreff,
      beschreibungMD: beschreibungMD,
      kundenMitarbeiterRecID: kundenMitarbeiterRecID,
      mitarbeiterRecID: mitarbeiterRecID,
      teamRecID: teamRecID,
      firmaRecID: firmaRecID,
      ticketTag: ticketTag,
      status: status,
      priorisierung: priorisierung,
      kategorie: kategorie,
      notiz: notiz,
      feedbackGeloestDurchRecID: feedbackGeloestDurchRecID,
      loesung: loesung,
    );
