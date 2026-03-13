// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class KommunikationStruct extends BaseStruct {
  KommunikationStruct({
    String? recID,
    String? creatorId,
    String? vorgangRecID,
    String? firmaRecID,
    String? kundenMitarbeiterRecID,
    String? mitarbeiterRecID,
    String? mailCC,
    String? mailTo,
    List<String>? attachmentPfade,
    String? richtung,
    String? betreff,
    String? beschreibungMD,
    String? typ,
    String? gelesenAm,
    bool? gelesenNotwendig,
    bool? versandNotwendig,
    String? versandDatum,
    bool? unzugeordnet,
    String? projektRecID,
    String? sOPRecID,
    String? ticketTag,
    String? createdAt,
    String? internetMessageID,
    String? graphMsgID,
    String? conversationID,
    String? replyToGraphID,
  })  : _recID = recID,
        _creatorId = creatorId,
        _vorgangRecID = vorgangRecID,
        _firmaRecID = firmaRecID,
        _kundenMitarbeiterRecID = kundenMitarbeiterRecID,
        _mitarbeiterRecID = mitarbeiterRecID,
        _mailCC = mailCC,
        _mailTo = mailTo,
        _attachmentPfade = attachmentPfade,
        _richtung = richtung,
        _betreff = betreff,
        _beschreibungMD = beschreibungMD,
        _typ = typ,
        _gelesenAm = gelesenAm,
        _gelesenNotwendig = gelesenNotwendig,
        _versandNotwendig = versandNotwendig,
        _versandDatum = versandDatum,
        _unzugeordnet = unzugeordnet,
        _projektRecID = projektRecID,
        _sOPRecID = sOPRecID,
        _ticketTag = ticketTag,
        _createdAt = createdAt,
        _internetMessageID = internetMessageID,
        _graphMsgID = graphMsgID,
        _conversationID = conversationID,
        _replyToGraphID = replyToGraphID;

  // "RecID" field.
  String? _recID;
  String get recID => _recID ?? '';
  set recID(String? val) => _recID = val;

  bool hasRecID() => _recID != null;

  // "CreatorId" field.
  String? _creatorId;
  String get creatorId => _creatorId ?? '';
  set creatorId(String? val) => _creatorId = val;

  bool hasCreatorId() => _creatorId != null;

  // "Vorgang_RecID" field.
  String? _vorgangRecID;
  String get vorgangRecID => _vorgangRecID ?? '';
  set vorgangRecID(String? val) => _vorgangRecID = val;

  bool hasVorgangRecID() => _vorgangRecID != null;

  // "Firma_RecID" field.
  String? _firmaRecID;
  String get firmaRecID => _firmaRecID ?? '';
  set firmaRecID(String? val) => _firmaRecID = val;

  bool hasFirmaRecID() => _firmaRecID != null;

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

  // "Mail_CC" field.
  String? _mailCC;
  String get mailCC => _mailCC ?? '';
  set mailCC(String? val) => _mailCC = val;

  bool hasMailCC() => _mailCC != null;

  // "Mail_To" field.
  String? _mailTo;
  String get mailTo => _mailTo ?? '';
  set mailTo(String? val) => _mailTo = val;

  bool hasMailTo() => _mailTo != null;

  // "Attachment_Pfade" field.
  List<String>? _attachmentPfade;
  List<String> get attachmentPfade => _attachmentPfade ?? const [];
  set attachmentPfade(List<String>? val) => _attachmentPfade = val;

  void updateAttachmentPfade(Function(List<String>) updateFn) {
    updateFn(_attachmentPfade ??= []);
  }

  bool hasAttachmentPfade() => _attachmentPfade != null;

  // "Richtung" field.
  String? _richtung;
  String get richtung => _richtung ?? '';
  set richtung(String? val) => _richtung = val;

  bool hasRichtung() => _richtung != null;

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

  // "Typ" field.
  String? _typ;
  String get typ => _typ ?? '';
  set typ(String? val) => _typ = val;

  bool hasTyp() => _typ != null;

  // "Gelesen_Am" field.
  String? _gelesenAm;
  String get gelesenAm => _gelesenAm ?? '';
  set gelesenAm(String? val) => _gelesenAm = val;

  bool hasGelesenAm() => _gelesenAm != null;

  // "Gelesen_Notwendig" field.
  bool? _gelesenNotwendig;
  bool get gelesenNotwendig => _gelesenNotwendig ?? false;
  set gelesenNotwendig(bool? val) => _gelesenNotwendig = val;

  bool hasGelesenNotwendig() => _gelesenNotwendig != null;

  // "Versand_Notwendig" field.
  bool? _versandNotwendig;
  bool get versandNotwendig => _versandNotwendig ?? false;
  set versandNotwendig(bool? val) => _versandNotwendig = val;

  bool hasVersandNotwendig() => _versandNotwendig != null;

  // "Versand_Datum" field.
  String? _versandDatum;
  String get versandDatum => _versandDatum ?? '';
  set versandDatum(String? val) => _versandDatum = val;

  bool hasVersandDatum() => _versandDatum != null;

  // "Unzugeordnet" field.
  bool? _unzugeordnet;
  bool get unzugeordnet => _unzugeordnet ?? false;
  set unzugeordnet(bool? val) => _unzugeordnet = val;

  bool hasUnzugeordnet() => _unzugeordnet != null;

  // "Projekt_RecID" field.
  String? _projektRecID;
  String get projektRecID => _projektRecID ?? '';
  set projektRecID(String? val) => _projektRecID = val;

  bool hasProjektRecID() => _projektRecID != null;

  // "SOP_RecID" field.
  String? _sOPRecID;
  String get sOPRecID => _sOPRecID ?? '';
  set sOPRecID(String? val) => _sOPRecID = val;

  bool hasSOPRecID() => _sOPRecID != null;

  // "Ticket_Tag" field.
  String? _ticketTag;
  String get ticketTag => _ticketTag ?? '';
  set ticketTag(String? val) => _ticketTag = val;

  bool hasTicketTag() => _ticketTag != null;

  // "Created_at" field.
  String? _createdAt;
  String get createdAt => _createdAt ?? '';
  set createdAt(String? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "Internet_Message_ID" field.
  String? _internetMessageID;
  String get internetMessageID => _internetMessageID ?? '';
  set internetMessageID(String? val) => _internetMessageID = val;

  bool hasInternetMessageID() => _internetMessageID != null;

  // "Graph_Msg_ID" field.
  String? _graphMsgID;
  String get graphMsgID => _graphMsgID ?? '';
  set graphMsgID(String? val) => _graphMsgID = val;

  bool hasGraphMsgID() => _graphMsgID != null;

  // "Conversation_ID" field.
  String? _conversationID;
  String get conversationID => _conversationID ?? '';
  set conversationID(String? val) => _conversationID = val;

  bool hasConversationID() => _conversationID != null;

  // "ReplyTo_Graph_ID" field.
  String? _replyToGraphID;
  String get replyToGraphID => _replyToGraphID ?? '';
  set replyToGraphID(String? val) => _replyToGraphID = val;

  bool hasReplyToGraphID() => _replyToGraphID != null;

  static KommunikationStruct fromMap(Map<String, dynamic> data) =>
      KommunikationStruct(
        recID: data['RecID'] as String?,
        creatorId: data['CreatorId'] as String?,
        vorgangRecID: data['Vorgang_RecID'] as String?,
        firmaRecID: data['Firma_RecID'] as String?,
        kundenMitarbeiterRecID: data['Kunden-Mitarbeiter_RecID'] as String?,
        mitarbeiterRecID: data['Mitarbeiter_RecID'] as String?,
        mailCC: data['Mail_CC'] as String?,
        mailTo: data['Mail_To'] as String?,
        attachmentPfade: getDataList(data['Attachment_Pfade']),
        richtung: data['Richtung'] as String?,
        betreff: data['Betreff'] as String?,
        beschreibungMD: data['Beschreibung_MD'] as String?,
        typ: data['Typ'] as String?,
        gelesenAm: data['Gelesen_Am'] as String?,
        gelesenNotwendig: data['Gelesen_Notwendig'] as bool?,
        versandNotwendig: data['Versand_Notwendig'] as bool?,
        versandDatum: data['Versand_Datum'] as String?,
        unzugeordnet: data['Unzugeordnet'] as bool?,
        projektRecID: data['Projekt_RecID'] as String?,
        sOPRecID: data['SOP_RecID'] as String?,
        ticketTag: data['Ticket_Tag'] as String?,
        createdAt: data['Created_at'] as String?,
        internetMessageID: data['Internet_Message_ID'] as String?,
        graphMsgID: data['Graph_Msg_ID'] as String?,
        conversationID: data['Conversation_ID'] as String?,
        replyToGraphID: data['ReplyTo_Graph_ID'] as String?,
      );

  static KommunikationStruct? maybeFromMap(dynamic data) => data is Map
      ? KommunikationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'RecID': _recID,
        'CreatorId': _creatorId,
        'Vorgang_RecID': _vorgangRecID,
        'Firma_RecID': _firmaRecID,
        'Kunden-Mitarbeiter_RecID': _kundenMitarbeiterRecID,
        'Mitarbeiter_RecID': _mitarbeiterRecID,
        'Mail_CC': _mailCC,
        'Mail_To': _mailTo,
        'Attachment_Pfade': _attachmentPfade,
        'Richtung': _richtung,
        'Betreff': _betreff,
        'Beschreibung_MD': _beschreibungMD,
        'Typ': _typ,
        'Gelesen_Am': _gelesenAm,
        'Gelesen_Notwendig': _gelesenNotwendig,
        'Versand_Notwendig': _versandNotwendig,
        'Versand_Datum': _versandDatum,
        'Unzugeordnet': _unzugeordnet,
        'Projekt_RecID': _projektRecID,
        'SOP_RecID': _sOPRecID,
        'Ticket_Tag': _ticketTag,
        'Created_at': _createdAt,
        'Internet_Message_ID': _internetMessageID,
        'Graph_Msg_ID': _graphMsgID,
        'Conversation_ID': _conversationID,
        'ReplyTo_Graph_ID': _replyToGraphID,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'RecID': serializeParam(
          _recID,
          ParamType.String,
        ),
        'CreatorId': serializeParam(
          _creatorId,
          ParamType.String,
        ),
        'Vorgang_RecID': serializeParam(
          _vorgangRecID,
          ParamType.String,
        ),
        'Firma_RecID': serializeParam(
          _firmaRecID,
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
        'Mail_CC': serializeParam(
          _mailCC,
          ParamType.String,
        ),
        'Mail_To': serializeParam(
          _mailTo,
          ParamType.String,
        ),
        'Attachment_Pfade': serializeParam(
          _attachmentPfade,
          ParamType.String,
          isList: true,
        ),
        'Richtung': serializeParam(
          _richtung,
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
        'Typ': serializeParam(
          _typ,
          ParamType.String,
        ),
        'Gelesen_Am': serializeParam(
          _gelesenAm,
          ParamType.String,
        ),
        'Gelesen_Notwendig': serializeParam(
          _gelesenNotwendig,
          ParamType.bool,
        ),
        'Versand_Notwendig': serializeParam(
          _versandNotwendig,
          ParamType.bool,
        ),
        'Versand_Datum': serializeParam(
          _versandDatum,
          ParamType.String,
        ),
        'Unzugeordnet': serializeParam(
          _unzugeordnet,
          ParamType.bool,
        ),
        'Projekt_RecID': serializeParam(
          _projektRecID,
          ParamType.String,
        ),
        'SOP_RecID': serializeParam(
          _sOPRecID,
          ParamType.String,
        ),
        'Ticket_Tag': serializeParam(
          _ticketTag,
          ParamType.String,
        ),
        'Created_at': serializeParam(
          _createdAt,
          ParamType.String,
        ),
        'Internet_Message_ID': serializeParam(
          _internetMessageID,
          ParamType.String,
        ),
        'Graph_Msg_ID': serializeParam(
          _graphMsgID,
          ParamType.String,
        ),
        'Conversation_ID': serializeParam(
          _conversationID,
          ParamType.String,
        ),
        'ReplyTo_Graph_ID': serializeParam(
          _replyToGraphID,
          ParamType.String,
        ),
      }.withoutNulls;

  static KommunikationStruct fromSerializableMap(Map<String, dynamic> data) =>
      KommunikationStruct(
        recID: deserializeParam(
          data['RecID'],
          ParamType.String,
          false,
        ),
        creatorId: deserializeParam(
          data['CreatorId'],
          ParamType.String,
          false,
        ),
        vorgangRecID: deserializeParam(
          data['Vorgang_RecID'],
          ParamType.String,
          false,
        ),
        firmaRecID: deserializeParam(
          data['Firma_RecID'],
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
        mailCC: deserializeParam(
          data['Mail_CC'],
          ParamType.String,
          false,
        ),
        mailTo: deserializeParam(
          data['Mail_To'],
          ParamType.String,
          false,
        ),
        attachmentPfade: deserializeParam<String>(
          data['Attachment_Pfade'],
          ParamType.String,
          true,
        ),
        richtung: deserializeParam(
          data['Richtung'],
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
        typ: deserializeParam(
          data['Typ'],
          ParamType.String,
          false,
        ),
        gelesenAm: deserializeParam(
          data['Gelesen_Am'],
          ParamType.String,
          false,
        ),
        gelesenNotwendig: deserializeParam(
          data['Gelesen_Notwendig'],
          ParamType.bool,
          false,
        ),
        versandNotwendig: deserializeParam(
          data['Versand_Notwendig'],
          ParamType.bool,
          false,
        ),
        versandDatum: deserializeParam(
          data['Versand_Datum'],
          ParamType.String,
          false,
        ),
        unzugeordnet: deserializeParam(
          data['Unzugeordnet'],
          ParamType.bool,
          false,
        ),
        projektRecID: deserializeParam(
          data['Projekt_RecID'],
          ParamType.String,
          false,
        ),
        sOPRecID: deserializeParam(
          data['SOP_RecID'],
          ParamType.String,
          false,
        ),
        ticketTag: deserializeParam(
          data['Ticket_Tag'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['Created_at'],
          ParamType.String,
          false,
        ),
        internetMessageID: deserializeParam(
          data['Internet_Message_ID'],
          ParamType.String,
          false,
        ),
        graphMsgID: deserializeParam(
          data['Graph_Msg_ID'],
          ParamType.String,
          false,
        ),
        conversationID: deserializeParam(
          data['Conversation_ID'],
          ParamType.String,
          false,
        ),
        replyToGraphID: deserializeParam(
          data['ReplyTo_Graph_ID'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'KommunikationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is KommunikationStruct &&
        recID == other.recID &&
        creatorId == other.creatorId &&
        vorgangRecID == other.vorgangRecID &&
        firmaRecID == other.firmaRecID &&
        kundenMitarbeiterRecID == other.kundenMitarbeiterRecID &&
        mitarbeiterRecID == other.mitarbeiterRecID &&
        mailCC == other.mailCC &&
        mailTo == other.mailTo &&
        listEquality.equals(attachmentPfade, other.attachmentPfade) &&
        richtung == other.richtung &&
        betreff == other.betreff &&
        beschreibungMD == other.beschreibungMD &&
        typ == other.typ &&
        gelesenAm == other.gelesenAm &&
        gelesenNotwendig == other.gelesenNotwendig &&
        versandNotwendig == other.versandNotwendig &&
        versandDatum == other.versandDatum &&
        unzugeordnet == other.unzugeordnet &&
        projektRecID == other.projektRecID &&
        sOPRecID == other.sOPRecID &&
        ticketTag == other.ticketTag &&
        createdAt == other.createdAt &&
        internetMessageID == other.internetMessageID &&
        graphMsgID == other.graphMsgID &&
        conversationID == other.conversationID &&
        replyToGraphID == other.replyToGraphID;
  }

  @override
  int get hashCode => const ListEquality().hash([
        recID,
        creatorId,
        vorgangRecID,
        firmaRecID,
        kundenMitarbeiterRecID,
        mitarbeiterRecID,
        mailCC,
        mailTo,
        attachmentPfade,
        richtung,
        betreff,
        beschreibungMD,
        typ,
        gelesenAm,
        gelesenNotwendig,
        versandNotwendig,
        versandDatum,
        unzugeordnet,
        projektRecID,
        sOPRecID,
        ticketTag,
        createdAt,
        internetMessageID,
        graphMsgID,
        conversationID,
        replyToGraphID
      ]);
}

KommunikationStruct createKommunikationStruct({
  String? recID,
  String? creatorId,
  String? vorgangRecID,
  String? firmaRecID,
  String? kundenMitarbeiterRecID,
  String? mitarbeiterRecID,
  String? mailCC,
  String? mailTo,
  String? richtung,
  String? betreff,
  String? beschreibungMD,
  String? typ,
  String? gelesenAm,
  bool? gelesenNotwendig,
  bool? versandNotwendig,
  String? versandDatum,
  bool? unzugeordnet,
  String? projektRecID,
  String? sOPRecID,
  String? ticketTag,
  String? createdAt,
  String? internetMessageID,
  String? graphMsgID,
  String? conversationID,
  String? replyToGraphID,
}) =>
    KommunikationStruct(
      recID: recID,
      creatorId: creatorId,
      vorgangRecID: vorgangRecID,
      firmaRecID: firmaRecID,
      kundenMitarbeiterRecID: kundenMitarbeiterRecID,
      mitarbeiterRecID: mitarbeiterRecID,
      mailCC: mailCC,
      mailTo: mailTo,
      richtung: richtung,
      betreff: betreff,
      beschreibungMD: beschreibungMD,
      typ: typ,
      gelesenAm: gelesenAm,
      gelesenNotwendig: gelesenNotwendig,
      versandNotwendig: versandNotwendig,
      versandDatum: versandDatum,
      unzugeordnet: unzugeordnet,
      projektRecID: projektRecID,
      sOPRecID: sOPRecID,
      ticketTag: ticketTag,
      createdAt: createdAt,
      internetMessageID: internetMessageID,
      graphMsgID: graphMsgID,
      conversationID: conversationID,
      replyToGraphID: replyToGraphID,
    );
