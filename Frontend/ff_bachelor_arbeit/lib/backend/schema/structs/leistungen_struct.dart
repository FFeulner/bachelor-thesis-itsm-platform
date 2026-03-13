// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LeistungenStruct extends BaseStruct {
  LeistungenStruct({
    String? recID,
    String? creator,
    String? firmaRecID,
    String? kundenvertragRecID,
    String? kundenvertragPreiseRecID,
    String? vorgangRecID,
    String? mitarbeiterRecID,
    String? leistungstext,
    int? auslastungsgrad,
    int? kulanzabzug,
    String? kulanzabzugGrund,
    String? leistungsstart1,
    String? leistungsende1,
    String? leistungsstart2,
    String? leistungsende2,
    bool? erscheintNichtAufRechnungIntern,
    bool? pruefungNotwendig,
    bool? wFCPreisberechnung,
    String? wFCPreisberechnungLast,
    int? arbeitszeitMinutenNetto,
    int? preisProEinheit,
    String? einheit,
    int? summeEuro,
    int? summeEuroKulanz,
    bool? loeschen,
  })  : _recID = recID,
        _creator = creator,
        _firmaRecID = firmaRecID,
        _kundenvertragRecID = kundenvertragRecID,
        _kundenvertragPreiseRecID = kundenvertragPreiseRecID,
        _vorgangRecID = vorgangRecID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _leistungstext = leistungstext,
        _auslastungsgrad = auslastungsgrad,
        _kulanzabzug = kulanzabzug,
        _kulanzabzugGrund = kulanzabzugGrund,
        _leistungsstart1 = leistungsstart1,
        _leistungsende1 = leistungsende1,
        _leistungsstart2 = leistungsstart2,
        _leistungsende2 = leistungsende2,
        _erscheintNichtAufRechnungIntern = erscheintNichtAufRechnungIntern,
        _pruefungNotwendig = pruefungNotwendig,
        _wFCPreisberechnung = wFCPreisberechnung,
        _wFCPreisberechnungLast = wFCPreisberechnungLast,
        _arbeitszeitMinutenNetto = arbeitszeitMinutenNetto,
        _preisProEinheit = preisProEinheit,
        _einheit = einheit,
        _summeEuro = summeEuro,
        _summeEuroKulanz = summeEuroKulanz,
        _loeschen = loeschen;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "Creator" field.
  String? _creator;
  String get creator => _creator ?? '';
  set creator(String? val) => _creator = val;

  bool hasCreator() => _creator != null;

  // "firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

  // "kundenvertrag_RecID" field.
  String? _kundenvertragRecID;
  String get kundenvertragRecID => _kundenvertragRecID ?? '';
  set kundenvertragRecID(String? val) => _kundenvertragRecID = val;

  bool hasKundenvertragRecID() => _kundenvertragRecID != null;

  // "kundenvertrag_preise_RecID" field.
  String? _kundenvertragPreiseRecID;
  String get kundenvertragPreiseRecID => _kundenvertragPreiseRecID ?? '';
  set kundenvertragPreiseRecID(String? val) => _kundenvertragPreiseRecID = val;

  bool hasKundenvertragPreiseRecID() => _kundenvertragPreiseRecID != null;

  // "Vorgang_RecID" field.
  String? _vorgangRecID;
  String get vorgangRecID => _vorgangRecID ?? '';
  set vorgangRecID(String? val) => _vorgangRecID = val;

  bool hasVorgangRecID() => _vorgangRecID != null;

  // "mitarbeiter_RecID" field.
  String? _mitarbeiterRecID;
  String get mitarbeiterRecID => _mitarbeiterRecID ?? '';
  set mitarbeiterRecID(String? val) => _mitarbeiterRecID = val;

  bool hasMitarbeiterRecID() => _mitarbeiterRecID != null;

  // "Leistungstext" field.
  String? _leistungstext;
  String get leistungstext => _leistungstext ?? '';
  set leistungstext(String? val) => _leistungstext = val;

  bool hasLeistungstext() => _leistungstext != null;

  // "Auslastungsgrad" field.
  int? _auslastungsgrad;
  int get auslastungsgrad => _auslastungsgrad ?? 0;
  set auslastungsgrad(int? val) => _auslastungsgrad = val;

  void incrementAuslastungsgrad(int amount) =>
      auslastungsgrad = auslastungsgrad + amount;

  bool hasAuslastungsgrad() => _auslastungsgrad != null;

  // "Kulanzabzug" field.
  int? _kulanzabzug;
  int get kulanzabzug => _kulanzabzug ?? 0;
  set kulanzabzug(int? val) => _kulanzabzug = val;

  void incrementKulanzabzug(int amount) => kulanzabzug = kulanzabzug + amount;

  bool hasKulanzabzug() => _kulanzabzug != null;

  // "Kulanzabzug_Grund" field.
  String? _kulanzabzugGrund;
  String get kulanzabzugGrund => _kulanzabzugGrund ?? '';
  set kulanzabzugGrund(String? val) => _kulanzabzugGrund = val;

  bool hasKulanzabzugGrund() => _kulanzabzugGrund != null;

  // "Leistungsstart1" field.
  String? _leistungsstart1;
  String get leistungsstart1 => _leistungsstart1 ?? '';
  set leistungsstart1(String? val) => _leistungsstart1 = val;

  bool hasLeistungsstart1() => _leistungsstart1 != null;

  // "Leistungsende1" field.
  String? _leistungsende1;
  String get leistungsende1 => _leistungsende1 ?? '';
  set leistungsende1(String? val) => _leistungsende1 = val;

  bool hasLeistungsende1() => _leistungsende1 != null;

  // "Leistungsstart2" field.
  String? _leistungsstart2;
  String get leistungsstart2 => _leistungsstart2 ?? '';
  set leistungsstart2(String? val) => _leistungsstart2 = val;

  bool hasLeistungsstart2() => _leistungsstart2 != null;

  // "Leistungsende2" field.
  String? _leistungsende2;
  String get leistungsende2 => _leistungsende2 ?? '';
  set leistungsende2(String? val) => _leistungsende2 = val;

  bool hasLeistungsende2() => _leistungsende2 != null;

  // "Erscheint_nicht_Auf_Rechnung_Intern" field.
  bool? _erscheintNichtAufRechnungIntern;
  bool get erscheintNichtAufRechnungIntern =>
      _erscheintNichtAufRechnungIntern ?? false;
  set erscheintNichtAufRechnungIntern(bool? val) =>
      _erscheintNichtAufRechnungIntern = val;

  bool hasErscheintNichtAufRechnungIntern() =>
      _erscheintNichtAufRechnungIntern != null;

  // "Pruefung_notwendig" field.
  bool? _pruefungNotwendig;
  bool get pruefungNotwendig => _pruefungNotwendig ?? false;
  set pruefungNotwendig(bool? val) => _pruefungNotwendig = val;

  bool hasPruefungNotwendig() => _pruefungNotwendig != null;

  // "WF_C_Preisberechnung" field.
  bool? _wFCPreisberechnung;
  bool get wFCPreisberechnung => _wFCPreisberechnung ?? false;
  set wFCPreisberechnung(bool? val) => _wFCPreisberechnung = val;

  bool hasWFCPreisberechnung() => _wFCPreisberechnung != null;

  // "WF_C_Preisberechnung_last" field.
  String? _wFCPreisberechnungLast;
  String get wFCPreisberechnungLast => _wFCPreisberechnungLast ?? '';
  set wFCPreisberechnungLast(String? val) => _wFCPreisberechnungLast = val;

  bool hasWFCPreisberechnungLast() => _wFCPreisberechnungLast != null;

  // "Arbeitszeit_Minuten_Netto" field.
  int? _arbeitszeitMinutenNetto;
  int get arbeitszeitMinutenNetto => _arbeitszeitMinutenNetto ?? 0;
  set arbeitszeitMinutenNetto(int? val) => _arbeitszeitMinutenNetto = val;

  void incrementArbeitszeitMinutenNetto(int amount) =>
      arbeitszeitMinutenNetto = arbeitszeitMinutenNetto + amount;

  bool hasArbeitszeitMinutenNetto() => _arbeitszeitMinutenNetto != null;

  // "Preis_pro_Einheit" field.
  int? _preisProEinheit;
  int get preisProEinheit => _preisProEinheit ?? 0;
  set preisProEinheit(int? val) => _preisProEinheit = val;

  void incrementPreisProEinheit(int amount) =>
      preisProEinheit = preisProEinheit + amount;

  bool hasPreisProEinheit() => _preisProEinheit != null;

  // "Einheit" field.
  String? _einheit;
  String get einheit => _einheit ?? '';
  set einheit(String? val) => _einheit = val;

  bool hasEinheit() => _einheit != null;

  // "Summe_Euro" field.
  int? _summeEuro;
  int get summeEuro => _summeEuro ?? 0;
  set summeEuro(int? val) => _summeEuro = val;

  void incrementSummeEuro(int amount) => summeEuro = summeEuro + amount;

  bool hasSummeEuro() => _summeEuro != null;

  // "Summe_Euro_Kulanz" field.
  int? _summeEuroKulanz;
  int get summeEuroKulanz => _summeEuroKulanz ?? 0;
  set summeEuroKulanz(int? val) => _summeEuroKulanz = val;

  void incrementSummeEuroKulanz(int amount) =>
      summeEuroKulanz = summeEuroKulanz + amount;

  bool hasSummeEuroKulanz() => _summeEuroKulanz != null;

  // "Loeschen" field.
  bool? _loeschen;
  bool get loeschen => _loeschen ?? false;
  set loeschen(bool? val) => _loeschen = val;

  bool hasLoeschen() => _loeschen != null;

  static LeistungenStruct fromMap(Map<String, dynamic> data) =>
      LeistungenStruct(
        recID: data['RecID'] as String?,
        creator: data['Creator'] as String?,
        firmaRecID: data['firma_RecID'] as String?,
        kundenvertragRecID: data['kundenvertrag_RecID'] as String?,
        kundenvertragPreiseRecID: data['kundenvertrag_preise_RecID'] as String?,
        vorgangRecID: data['Vorgang_RecID'] as String?,
        mitarbeiterRecID: data['mitarbeiter_RecID'] as String?,
        leistungstext: data['Leistungstext'] as String?,
        auslastungsgrad: castToType<int>(data['Auslastungsgrad']),
        kulanzabzug: castToType<int>(data['Kulanzabzug']),
        kulanzabzugGrund: data['Kulanzabzug_Grund'] as String?,
        leistungsstart1: data['Leistungsstart1'] as String?,
        leistungsende1: data['Leistungsende1'] as String?,
        leistungsstart2: data['Leistungsstart2'] as String?,
        leistungsende2: data['Leistungsende2'] as String?,
        erscheintNichtAufRechnungIntern:
            data['Erscheint_nicht_Auf_Rechnung_Intern'] as bool?,
        pruefungNotwendig: data['Pruefung_notwendig'] as bool?,
        wFCPreisberechnung: data['WF_C_Preisberechnung'] as bool?,
        wFCPreisberechnungLast: data['WF_C_Preisberechnung_last'] as String?,
        arbeitszeitMinutenNetto:
            castToType<int>(data['Arbeitszeit_Minuten_Netto']),
        preisProEinheit: castToType<int>(data['Preis_pro_Einheit']),
        einheit: data['Einheit'] as String?,
        summeEuro: castToType<int>(data['Summe_Euro']),
        summeEuroKulanz: castToType<int>(data['Summe_Euro_Kulanz']),
        loeschen: data['Loeschen'] as bool?,
      );

  static LeistungenStruct? maybeFromMap(dynamic data) => data is Map
      ? LeistungenStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'Creator': _creator,
        'firma_RecID': _firmaRecID,
        'kundenvertrag_RecID': _kundenvertragRecID,
        'kundenvertrag_preise_RecID': _kundenvertragPreiseRecID,
        'Vorgang_RecID': _vorgangRecID,
        'mitarbeiter_RecID': _mitarbeiterRecID,
        'Leistungstext': _leistungstext,
        'Auslastungsgrad': _auslastungsgrad,
        'Kulanzabzug': _kulanzabzug,
        'Kulanzabzug_Grund': _kulanzabzugGrund,
        'Leistungsstart1': _leistungsstart1,
        'Leistungsende1': _leistungsende1,
        'Leistungsstart2': _leistungsstart2,
        'Leistungsende2': _leistungsende2,
        'Erscheint_nicht_Auf_Rechnung_Intern': _erscheintNichtAufRechnungIntern,
        'Pruefung_notwendig': _pruefungNotwendig,
        'WF_C_Preisberechnung': _wFCPreisberechnung,
        'WF_C_Preisberechnung_last': _wFCPreisberechnungLast,
        'Arbeitszeit_Minuten_Netto': _arbeitszeitMinutenNetto,
        'Preis_pro_Einheit': _preisProEinheit,
        'Einheit': _einheit,
        'Summe_Euro': _summeEuro,
        'Summe_Euro_Kulanz': _summeEuroKulanz,
        'Loeschen': _loeschen,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'Creator': serializeParam(
          _creator,
          ParamType.String,
        ),
        'firma_RecID': serializeParam(
          _firmaRecID,
          ParamType.String,
        ),
        'kundenvertrag_RecID': serializeParam(
          _kundenvertragRecID,
          ParamType.String,
        ),
        'kundenvertrag_preise_RecID': serializeParam(
          _kundenvertragPreiseRecID,
          ParamType.String,
        ),
        'Vorgang_RecID': serializeParam(
          _vorgangRecID,
          ParamType.String,
        ),
        'mitarbeiter_RecID': serializeParam(
          _mitarbeiterRecID,
          ParamType.String,
        ),
        'Leistungstext': serializeParam(
          _leistungstext,
          ParamType.String,
        ),
        'Auslastungsgrad': serializeParam(
          _auslastungsgrad,
          ParamType.int,
        ),
        'Kulanzabzug': serializeParam(
          _kulanzabzug,
          ParamType.int,
        ),
        'Kulanzabzug_Grund': serializeParam(
          _kulanzabzugGrund,
          ParamType.String,
        ),
        'Leistungsstart1': serializeParam(
          _leistungsstart1,
          ParamType.String,
        ),
        'Leistungsende1': serializeParam(
          _leistungsende1,
          ParamType.String,
        ),
        'Leistungsstart2': serializeParam(
          _leistungsstart2,
          ParamType.String,
        ),
        'Leistungsende2': serializeParam(
          _leistungsende2,
          ParamType.String,
        ),
        'Erscheint_nicht_Auf_Rechnung_Intern': serializeParam(
          _erscheintNichtAufRechnungIntern,
          ParamType.bool,
        ),
        'Pruefung_notwendig': serializeParam(
          _pruefungNotwendig,
          ParamType.bool,
        ),
        'WF_C_Preisberechnung': serializeParam(
          _wFCPreisberechnung,
          ParamType.bool,
        ),
        'WF_C_Preisberechnung_last': serializeParam(
          _wFCPreisberechnungLast,
          ParamType.String,
        ),
        'Arbeitszeit_Minuten_Netto': serializeParam(
          _arbeitszeitMinutenNetto,
          ParamType.int,
        ),
        'Preis_pro_Einheit': serializeParam(
          _preisProEinheit,
          ParamType.int,
        ),
        'Einheit': serializeParam(
          _einheit,
          ParamType.String,
        ),
        'Summe_Euro': serializeParam(
          _summeEuro,
          ParamType.int,
        ),
        'Summe_Euro_Kulanz': serializeParam(
          _summeEuroKulanz,
          ParamType.int,
        ),
        'Loeschen': serializeParam(
          _loeschen,
          ParamType.bool,
        ),
      }.withoutNulls;

  static LeistungenStruct fromSerializableMap(Map<String, dynamic> data) =>
      LeistungenStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        creator: deserializeParam(
          data['Creator'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['firma_RecID'],
          ParamType.String,
          false,
        ),
        kundenvertragRecID: deserializeParam(
          data['kundenvertrag_RecID'],
          ParamType.String,
          false,
        ),
        kundenvertragPreiseRecID: deserializeParam(
          data['kundenvertrag_preise_RecID'],
          ParamType.String,
          false,
        ),
        vorgangRecID: deserializeParam(
          data['Vorgang_RecID'],
          ParamType.String,
          false,
        ),
        mitarbeiterRecID: deserializeParam(
          data['mitarbeiter_RecID'],
          ParamType.String,
          false,
        ),
        leistungstext: deserializeParam(
          data['Leistungstext'],
          ParamType.String,
          false,
        ),
        auslastungsgrad: deserializeParam(
          data['Auslastungsgrad'],
          ParamType.int,
          false,
        ),
        kulanzabzug: deserializeParam(
          data['Kulanzabzug'],
          ParamType.int,
          false,
        ),
        kulanzabzugGrund: deserializeParam(
          data['Kulanzabzug_Grund'],
          ParamType.String,
          false,
        ),
        leistungsstart1: deserializeParam(
          data['Leistungsstart1'],
          ParamType.String,
          false,
        ),
        leistungsende1: deserializeParam(
          data['Leistungsende1'],
          ParamType.String,
          false,
        ),
        leistungsstart2: deserializeParam(
          data['Leistungsstart2'],
          ParamType.String,
          false,
        ),
        leistungsende2: deserializeParam(
          data['Leistungsende2'],
          ParamType.String,
          false,
        ),
        erscheintNichtAufRechnungIntern: deserializeParam(
          data['Erscheint_nicht_Auf_Rechnung_Intern'],
          ParamType.bool,
          false,
        ),
        pruefungNotwendig: deserializeParam(
          data['Pruefung_notwendig'],
          ParamType.bool,
          false,
        ),
        wFCPreisberechnung: deserializeParam(
          data['WF_C_Preisberechnung'],
          ParamType.bool,
          false,
        ),
        wFCPreisberechnungLast: deserializeParam(
          data['WF_C_Preisberechnung_last'],
          ParamType.String,
          false,
        ),
        arbeitszeitMinutenNetto: deserializeParam(
          data['Arbeitszeit_Minuten_Netto'],
          ParamType.int,
          false,
        ),
        preisProEinheit: deserializeParam(
          data['Preis_pro_Einheit'],
          ParamType.int,
          false,
        ),
        einheit: deserializeParam(
          data['Einheit'],
          ParamType.String,
          false,
        ),
        summeEuro: deserializeParam(
          data['Summe_Euro'],
          ParamType.int,
          false,
        ),
        summeEuroKulanz: deserializeParam(
          data['Summe_Euro_Kulanz'],
          ParamType.int,
          false,
        ),
        loeschen: deserializeParam(
          data['Loeschen'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'LeistungenStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LeistungenStruct &&
        recID == other.recID &&
        creator == other.creator &&
        firmaRecID == other.firmaRecID &&
        kundenvertragRecID == other.kundenvertragRecID &&
        kundenvertragPreiseRecID == other.kundenvertragPreiseRecID &&
        vorgangRecID == other.vorgangRecID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        leistungstext == other.leistungstext &&
        auslastungsgrad == other.auslastungsgrad &&
        kulanzabzug == other.kulanzabzug &&
        kulanzabzugGrund == other.kulanzabzugGrund &&
        leistungsstart1 == other.leistungsstart1 &&
        leistungsende1 == other.leistungsende1 &&
        leistungsstart2 == other.leistungsstart2 &&
        leistungsende2 == other.leistungsende2 &&
        erscheintNichtAufRechnungIntern ==
            other.erscheintNichtAufRechnungIntern &&
        pruefungNotwendig == other.pruefungNotwendig &&
        wFCPreisberechnung == other.wFCPreisberechnung &&
        wFCPreisberechnungLast == other.wFCPreisberechnungLast &&
        arbeitszeitMinutenNetto == other.arbeitszeitMinutenNetto &&
        preisProEinheit == other.preisProEinheit &&
        einheit == other.einheit &&
        summeEuro == other.summeEuro &&
        summeEuroKulanz == other.summeEuroKulanz &&
        loeschen == other.loeschen;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creator,
        firmaRecID,
        kundenvertragRecID,
        kundenvertragPreiseRecID,
        vorgangRecID,
        mitarbeiterRecID,
        leistungstext,
        auslastungsgrad,
        kulanzabzug,
        kulanzabzugGrund,
        leistungsstart1,
        leistungsende1,
        leistungsstart2,
        leistungsende2,
        erscheintNichtAufRechnungIntern,
        pruefungNotwendig,
        wFCPreisberechnung,
        wFCPreisberechnungLast,
        arbeitszeitMinutenNetto,
        preisProEinheit,
        einheit,
        summeEuro,
        summeEuroKulanz,
        loeschen
      ]);
}

LeistungenStruct createLeistungenStruct({
  String? recID,
  String? creator,
  String? firmaRecID,
  String? kundenvertragRecID,
  String? kundenvertragPreiseRecID,
  String? vorgangRecID,
  String? mitarbeiterRecID,
  String? leistungstext,
  int? auslastungsgrad,
  int? kulanzabzug,
  String? kulanzabzugGrund,
  String? leistungsstart1,
  String? leistungsende1,
  String? leistungsstart2,
  String? leistungsende2,
  bool? erscheintNichtAufRechnungIntern,
  bool? pruefungNotwendig,
  bool? wFCPreisberechnung,
  String? wFCPreisberechnungLast,
  int? arbeitszeitMinutenNetto,
  int? preisProEinheit,
  String? einheit,
  int? summeEuro,
  int? summeEuroKulanz,
  bool? loeschen,
}) =>
    LeistungenStruct(
      recID: recID,
      creator: creator,
      firmaRecID: firmaRecID,
      kundenvertragRecID: kundenvertragRecID,
      kundenvertragPreiseRecID: kundenvertragPreiseRecID,
      vorgangRecID: vorgangRecID,
      mitarbeiterRecID: mitarbeiterRecID,
      leistungstext: leistungstext,
      auslastungsgrad: auslastungsgrad,
      kulanzabzug: kulanzabzug,
      kulanzabzugGrund: kulanzabzugGrund,
      leistungsstart1: leistungsstart1,
      leistungsende1: leistungsende1,
      leistungsstart2: leistungsstart2,
      leistungsende2: leistungsende2,
      erscheintNichtAufRechnungIntern: erscheintNichtAufRechnungIntern,
      pruefungNotwendig: pruefungNotwendig,
      wFCPreisberechnung: wFCPreisberechnung,
      wFCPreisberechnungLast: wFCPreisberechnungLast,
      arbeitszeitMinutenNetto: arbeitszeitMinutenNetto,
      preisProEinheit: preisProEinheit,
      einheit: einheit,
      summeEuro: summeEuro,
      summeEuroKulanz: summeEuroKulanz,
      loeschen: loeschen,
    );
