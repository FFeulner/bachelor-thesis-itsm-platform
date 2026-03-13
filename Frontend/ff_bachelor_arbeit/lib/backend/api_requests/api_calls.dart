import 'dart:convert';
import 'dart:typed_data';
import '../schema/structs/index.dart';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start auth Group Code

class AuthGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/auth/';
  }

  static Map<String, String> headers = {};
  static CallbackCall callbackCall = CallbackCall();
  static RefreshTokenCall refreshTokenCall = RefreshTokenCall();
  static RoleVerifyerCall roleVerifyerCall = RoleVerifyerCall();
  static LogoutPassiertMomentanViaCustomActionCall
      logoutPassiertMomentanViaCustomActionCall =
      LogoutPassiertMomentanViaCustomActionCall();
  static OfflineLoginCall offlineLoginCall = OfflineLoginCall();
}

class CallbackCall {
  Future<ApiCallResponse> call({
    String? code = '',
    String? verifier = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AuthGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "code": "${escapeStringForJson(code)}",
  "verifier": "${escapeStringForJson(verifier)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Callback',
      apiUrl: '${baseUrl}callback',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RefreshTokenCall {
  Future<ApiCallResponse> call({
    String? refreshToken = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AuthGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "refresh_token": "${escapeStringForJson(refreshToken)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RefreshToken',
      apiUrl: '${baseUrl}refresh',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class RoleVerifyerCall {
  Future<ApiCallResponse> call({
    String? idToken = '',
    String? rolle = '',
    String? accessToken = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AuthGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "id_token": "<id_token>",
  "access_token": "<access_token>",
  "rolle": "${escapeStringForJson(rolle)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RoleVerifyer',
      apiUrl: '${baseUrl}verify-role',
      callType: ApiCallType.POST,
      headers: {},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LogoutPassiertMomentanViaCustomActionCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AuthGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'logoutPassiertMomentanViaCustomAction',
      apiUrl: '${baseUrl}logout',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      bodyType: BodyType.NONE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class OfflineLoginCall {
  Future<ApiCallResponse> call({
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AuthGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "email": "flo@local",
  "sub": "ae42ec06-ed41-11f0-91c3-902e16ab1a7e",
  "roles": ["Enigma_User","admin"],
  "name": "Flo Feuler",
  "given_name": "Flo",
  "family_name": "Feuler",
  "nickname": "flo"
}
''';
    return ApiManager.instance.makeApiCall(
      callName: 'OfflineLogin',
      apiUrl: '${baseUrl}offline/login',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic accessToken(dynamic response) => getJsonField(
        response,
        r'''$.access_token''',
      );
  dynamic idToken(dynamic response) => getJsonField(
        response,
        r'''$.id_token''',
      );
}

/// End auth Group Code

/// Start vorgang Group Code

class VorgangGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllVorgangGetCall readAllVorgangGetCall = ReadAllVorgangGetCall();
  static CreateItemVorgangPostCall createItemVorgangPostCall =
      CreateItemVorgangPostCall();
  static ReadOneVorgangGetCall readOneVorgangGetCall = ReadOneVorgangGetCall();
  static UpdateItemVorgangPutCall updateItemVorgangPutCall =
      UpdateItemVorgangPutCall();
  static MarkDeleteVorgangPostCall markDeleteVorgangPostCall =
      MarkDeleteVorgangPostCall();
}

class ReadAllVorgangGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? fields = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = VorgangGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllVorgangGet',
      apiUrl: '${baseUrl}/vorgang/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
        'fields': fields,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemVorgangPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? betreff = '',
    String? creatorID = '',
    String? beschreibungMD = '',
    String? kundenMitarbeiterRecID = '',
    String? mitarbeiterRecID = '',
    String? teamRecID = '',
    String? ticketTag = '',
    String? status = '',
    String? firmaRecID = '',
    String? priorisierung = '',
    String? kategorie = '',
    String? notiz = '',
    String? quelle = '',
    List<String>? weitereKundenMitarbeiterRecIDList,
    String? feedbackGeloestDurchRecID = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = VorgangGroup.getBaseUrl(
      apiURl: apiURl,
    );
    final weitereKundenMitarbeiterRecID =
        _serializeList(weitereKundenMitarbeiterRecIDList);

    final ffApiRequestBody = '''
{
  "CreatorID": "${escapeStringForJson(creatorID)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung_MD": "${escapeStringForJson(beschreibungMD)}",
  "Kunden-Mitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "Mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Team_RecID": "${escapeStringForJson(teamRecID)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Ticket_Tag": "${escapeStringForJson(ticketTag)}",
  "Status": "${escapeStringForJson(status)}",
  "Kategorie": "${escapeStringForJson(kategorie)}",
  "Priorisierung": "${escapeStringForJson(priorisierung)}",
  "Notiz": "${escapeStringForJson(notiz)}",
  "Quelle": "${escapeStringForJson(quelle)}",
  "Weitere_Kunden_Mitarbeiter_RecID": ${weitereKundenMitarbeiterRecID},
  "Feedback_geloest_durchRecID": "${escapeStringForJson(feedbackGeloestDurchRecID)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemVorgangPost',
      apiUrl: '${baseUrl}/vorgang/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneVorgangGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = VorgangGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneVorgangGet',
      apiUrl: '${baseUrl}/vorgang/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemVorgangPutCall {
  Future<ApiCallResponse> call({
    String? recID = '',
    String? bearerAuth = '',
    String? betreff = '',
    String? creatorID = '',
    String? beschreibungMD = '',
    String? kundenMitarbeiterRecID = '',
    String? mitarbeiterRecID = '',
    String? teamRecID = '',
    String? ticketTag = '',
    String? status = '',
    String? firmaRecID = '',
    String? priorisierung = '',
    String? kategorie = '',
    String? notiz = '',
    List<String>? weitereKundenMitarbeiterRecIDList,
    String? feedbackGeloestDurchRecID = '',
    String? loesung = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = VorgangGroup.getBaseUrl(
      apiURl: apiURl,
    );
    final weitereKundenMitarbeiterRecID =
        _serializeList(weitereKundenMitarbeiterRecIDList);

    final ffApiRequestBody = '''
{
  "RecID": "${escapeStringForJson(recID)}",
  "CreatorID": "${escapeStringForJson(creatorID)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung_MD": "${escapeStringForJson(beschreibungMD)}",
  "Kunden-Mitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "Mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Team_RecID": "${escapeStringForJson(teamRecID)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Ticket_Tag": "${escapeStringForJson(ticketTag)}",
  "Status": "${escapeStringForJson(status)}",
  "Kategorie": "${escapeStringForJson(kategorie)}",
  "Priorisierung": "${escapeStringForJson(priorisierung)}",
  "Notiz": "${escapeStringForJson(notiz)}",
  "Weitere_Kunden_Mitarbeiter_RecID": ${weitereKundenMitarbeiterRecID},
  "Loesung": "${escapeStringForJson(loesung)}",
  "Feedback_geloest_durchRecID": "${escapeStringForJson(feedbackGeloestDurchRecID)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemVorgangPut',
      apiUrl: '${baseUrl}/vorgang/${recID}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteVorgangPostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = VorgangGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteVorgangPost',
      apiUrl: '${baseUrl}/vorgang/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End vorgang Group Code

/// Start mitarbeiter Group Code

class MitarbeiterGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllMitarbeiterGetCall readAllMitarbeiterGetCall =
      ReadAllMitarbeiterGetCall();
  static CreateItemMitarbeiterPostCall createItemMitarbeiterPostCall =
      CreateItemMitarbeiterPostCall();
  static ReadOneMitarbeiterGetCall readOneMitarbeiterGetCall =
      ReadOneMitarbeiterGetCall();
  static UpdateItemMitarbeiterPutCall updateItemMitarbeiterPutCall =
      UpdateItemMitarbeiterPutCall();
  static MarkDeleteMitarbeiterPostCall markDeleteMitarbeiterPostCall =
      MarkDeleteMitarbeiterPostCall();
}

class ReadAllMitarbeiterGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = MitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllMitarbeiterGet',
      apiUrl: '${baseUrl}/mitarbeiter/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemMitarbeiterPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = MitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Vorname": "",
  "Nachname": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemMitarbeiterPost',
      apiUrl: '${baseUrl}/mitarbeiter/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneMitarbeiterGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = MitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneMitarbeiterGet',
      apiUrl: '${baseUrl}/mitarbeiter/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemMitarbeiterPutCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = MitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Vorname": "",
  "Nachname": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemMitarbeiterPut',
      apiUrl: '${baseUrl}/mitarbeiter/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteMitarbeiterPostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = MitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteMitarbeiterPost',
      apiUrl: '${baseUrl}/mitarbeiter/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End mitarbeiter Group Code

/// Start kommunikation Group Code

class KommunikationGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllKommunikationGetCall readAllKommunikationGetCall =
      ReadAllKommunikationGetCall();
  static CreateItemKommunikationPostCall createItemKommunikationPostCall =
      CreateItemKommunikationPostCall();
  static ReadOneKommunikationGetCall readOneKommunikationGetCall =
      ReadOneKommunikationGetCall();
  static UpdateItemKommunikationPutCall updateItemKommunikationPutCall =
      UpdateItemKommunikationPutCall();
  static MarkDeleteKommunikationPostCall markDeleteKommunikationPostCall =
      MarkDeleteKommunikationPostCall();
}

class ReadAllKommunikationGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KommunikationGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllKommunikationGet',
      apiUrl: '${baseUrl}/kommunikation/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemKommunikationPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? creatorId = '',
    String? vorgangRecID = '',
    String? firmaRecID = '',
    String? kundenMitarbeiterRecID = '',
    String? mitarbeiterRecID = '',
    List<String>? attachmentPfadeList,
    String? richtung = '',
    String? betreff = '',
    String? beschreibungMD = '',
    String? typ = '',
    bool? versandNotwendig,
    String? projektRecID = '',
    String? sOPRecID = '',
    String? ticketTag = '',
    String? mailCC = '',
    String? mailTo = '',
    String? replyToGraphId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KommunikationGroup.getBaseUrl(
      apiURl: apiURl,
    );
    final attachmentPfade = _serializeList(attachmentPfadeList);

    final ffApiRequestBody = '''
{
  "CreatorId": "${escapeStringForJson(creatorId)}",
  "Vorgang_RecID": "${escapeStringForJson(vorgangRecID)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Kunden-Mitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "Mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Mail_CC": "${escapeStringForJson(mailCC)}",
  "Mail_To": "${escapeStringForJson(mailTo)}",
  "Attachment_Pfade": ${attachmentPfade},
  "Richtung": "${escapeStringForJson(richtung)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung_MD": "${escapeStringForJson(beschreibungMD)}",
  "Typ": "${escapeStringForJson(typ)}",
  "Versand_Notwendig": ${versandNotwendig},
  "Projekt_RecID": "${escapeStringForJson(projektRecID)}",
  "SOP_RecID": "${escapeStringForJson(sOPRecID)}",
  "Ticket_Tag": "${escapeStringForJson(ticketTag)}",
  "ReplyTo_Graph_ID": "${escapeStringForJson(replyToGraphId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemKommunikationPost',
      apiUrl: '${baseUrl}/kommunikation/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneKommunikationGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KommunikationGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneKommunikationGet',
      apiUrl: '${baseUrl}/kommunikation/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemKommunikationPutCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? creatorId = '',
    String? vorgangRecID = '',
    String? firmaRecID = '',
    String? kundenMitarbeiterRecID = '',
    String? mitarbeiterRecID = '',
    List<String>? attachmentPfadeList,
    String? richtung = '',
    String? betreff = '',
    String? beschreibungMD = '',
    String? typ = '',
    double? versandNotwendig,
    String? projektRecID = '',
    String? sOPRecID = '',
    String? ticketTag = '',
    String? mailCC = '',
    String? mailTo = '',
    String? replyToGraphId = '',
    bool? gelesenNotwendig,
    String? apiURl,
  }) async {
    gelesenNotwendig ??= null!;
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KommunikationGroup.getBaseUrl(
      apiURl: apiURl,
    );
    final attachmentPfade = _serializeList(attachmentPfadeList);

    final ffApiRequestBody = '''
{
  "CreatorId": "${escapeStringForJson(creatorId)}",
  "Vorgang_RecID": "${escapeStringForJson(vorgangRecID)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Kunden-Mitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "Mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Mail_CC": "${escapeStringForJson(mailCC)}",
  "Mail_To": "${escapeStringForJson(mailTo)}",
  "Attachment_Pfade": ${attachmentPfade},
  "Richtung": "${escapeStringForJson(richtung)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung_MD": "${escapeStringForJson(beschreibungMD)}",
  "Typ": "${escapeStringForJson(typ)}",
  "Versand_Notwendig": ${versandNotwendig},
  "Projekt_RecID": "${escapeStringForJson(projektRecID)}",
  "SOP_RecID": "${escapeStringForJson(sOPRecID)}",
  "Ticket_Tag": "${escapeStringForJson(ticketTag)}",
  "ReplyTo_Graph_ID": "${escapeStringForJson(replyToGraphId)}",
  "Gelesen_Notwendig": ${gelesenNotwendig}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemKommunikationPut',
      apiUrl: '${baseUrl}/kommunikation/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteKommunikationPostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KommunikationGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteKommunikationPost',
      apiUrl: '${baseUrl}/kommunikation/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End kommunikation Group Code

/// Start firma Group Code

class FirmaGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllFirmaGetCall readAllFirmaGetCall = ReadAllFirmaGetCall();
  static CreateItemFirmaPostCall createItemFirmaPostCall =
      CreateItemFirmaPostCall();
  static ReadOneFirmaGetCall readOneFirmaGetCall = ReadOneFirmaGetCall();
  static UpdateItemFirmaPutCall updateItemFirmaPutCall =
      UpdateItemFirmaPutCall();
  static MarkDeleteFirmaPostCall markDeleteFirmaPostCall =
      MarkDeleteFirmaPostCall();
}

class ReadAllFirmaGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = FirmaGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllFirmaGet',
      apiUrl: '${baseUrl}/firma/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemFirmaPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = FirmaGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Name": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemFirmaPost',
      apiUrl: '${baseUrl}/firma/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneFirmaGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = FirmaGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneFirmaGet',
      apiUrl: '${baseUrl}/firma/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemFirmaPutCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = FirmaGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Name": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemFirmaPut',
      apiUrl: '${baseUrl}/firma/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteFirmaPostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = FirmaGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteFirmaPost',
      apiUrl: '${baseUrl}/firma/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End firma Group Code

/// Start deletion_queue Group Code

class DeletionQueueGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllDeletionQueueGetCall readAllDeletionQueueGetCall =
      ReadAllDeletionQueueGetCall();
  static CreateItemDeletionQueuePostCall createItemDeletionQueuePostCall =
      CreateItemDeletionQueuePostCall();
  static ReadOneDeletionQueueGetCall readOneDeletionQueueGetCall =
      ReadOneDeletionQueueGetCall();
  static UpdateItemDeletionQueuePutCall updateItemDeletionQueuePutCall =
      UpdateItemDeletionQueuePutCall();
  static MarkDeleteDeletionQueuePostCall markDeleteDeletionQueuePostCall =
      MarkDeleteDeletionQueuePostCall();
}

class ReadAllDeletionQueueGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = DeletionQueueGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllDeletionQueueGet',
      apiUrl: '${baseUrl}/deletion_queue/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemDeletionQueuePostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = DeletionQueueGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "tabellenname": "",
  "datensatz_id": "",
  "grund": "",
  "snapshot_json": "",
  "status": "",
  "angefordert_von": "",
  "angefordert_am": "",
  "geprueft_von": "",
  "geprueft_am": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemDeletionQueuePost',
      apiUrl: '${baseUrl}/deletion_queue/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneDeletionQueueGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = DeletionQueueGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneDeletionQueueGet',
      apiUrl: '${baseUrl}/deletion_queue/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemDeletionQueuePutCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = DeletionQueueGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "tabellenname": "",
  "datensatz_id": "",
  "grund": "",
  "snapshot_json": "",
  "status": "",
  "angefordert_von": "",
  "angefordert_am": "",
  "geprueft_von": "",
  "geprueft_am": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemDeletionQueuePut',
      apiUrl: '${baseUrl}/deletion_queue/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteDeletionQueuePostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = DeletionQueueGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteDeletionQueuePost',
      apiUrl: '${baseUrl}/deletion_queue/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End deletion_queue Group Code

/// Start cmdb Group Code

class CmdbGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllCmdbGetCall readAllCmdbGetCall = ReadAllCmdbGetCall();
  static CreateItemCmdbPostCall createItemCmdbPostCall =
      CreateItemCmdbPostCall();
  static ReadOneCmdbGetCall readOneCmdbGetCall = ReadOneCmdbGetCall();
  static UpdateItemCmdbPutCall updateItemCmdbPutCall = UpdateItemCmdbPutCall();
  static MarkDeleteCmdbPostCall markDeleteCmdbPostCall =
      MarkDeleteCmdbPostCall();
}

class ReadAllCmdbGetCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = CmdbGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllCmdbGet',
      apiUrl: '${baseUrl}/cmdb/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemCmdbPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = CmdbGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Name": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemCmdbPost',
      apiUrl: '${baseUrl}/cmdb/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneCmdbGetCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = CmdbGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneCmdbGet',
      apiUrl: '${baseUrl}/cmdb/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemCmdbPutCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = CmdbGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "",
  "Name": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemCmdbPut',
      apiUrl: '${baseUrl}/cmdb/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteCmdbPostCall {
  Future<ApiCallResponse> call({
    String? itemId = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = CmdbGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteCmdbPost',
      apiUrl: '${baseUrl}/cmdb/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End cmdb Group Code

/// Start aktivitaeten Group Code

class AktivitaetenGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllAktivitaetenGetCall readAllAktivitaetenGetCall =
      ReadAllAktivitaetenGetCall();
  static CreateItemAktivitaetenCall createItemAktivitaetenCall =
      CreateItemAktivitaetenCall();
  static MarkDeleteAktivitaetenCall markDeleteAktivitaetenCall =
      MarkDeleteAktivitaetenCall();
}

class ReadAllAktivitaetenGetCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? fields = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AktivitaetenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllAktivitaetenGet',
      apiUrl: '${baseUrl}/aktivitaeten/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
        'fields': fields,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemAktivitaetenCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? aktion = '',
    String? aktionInhalt = '',
    String? entityRecID = '',
    String? entityTable = '',
    String? mitarbeiterRecID = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AktivitaetenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "aktion": "${escapeStringForJson(aktion)}",
  "aktion_inhalt": "${escapeStringForJson(aktionInhalt)}",
  "entity_RecID": "${escapeStringForJson(entityRecID)}",
  "entity_table": "${escapeStringForJson(entityTable)}",
  "mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemAktivitaeten',
      apiUrl: '${baseUrl}/aktivitaeten/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteAktivitaetenCall {
  Future<ApiCallResponse> call({
    String? recid = '',
    String? bearerAuth = '',
    String? grund = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = AktivitaetenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": "${escapeStringForJson(grund)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteAktivitaeten',
      apiUrl: '${baseUrl}/aktivitaeten/${recid}',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End aktivitaeten Group Code

/// Start kundenMitarbeiter Group Code

class KundenMitarbeiterGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllKundenMitarbeiterGetCall readAllKundenMitarbeiterGetCall =
      ReadAllKundenMitarbeiterGetCall();
  static CreateItemKundenMitarbeiterPostCall
      createItemKundenMitarbeiterPostCall =
      CreateItemKundenMitarbeiterPostCall();
  static ReadOneKundenMitarbeiterGetCall readOneKundenMitarbeiterGetCall =
      ReadOneKundenMitarbeiterGetCall();
  static UpdateItemKundenMitarbeiterPutCall updateItemKundenMitarbeiterPutCall =
      UpdateItemKundenMitarbeiterPutCall();
  static MarkDeleteKundenMitarbeiterPostCall
      markDeleteKundenMitarbeiterPostCall =
      MarkDeleteKundenMitarbeiterPostCall();
}

class ReadAllKundenMitarbeiterGetCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? searchMode = '',
    String? orderDir = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KundenMitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllKundenMitarbeiterGet',
      apiUrl: '${baseUrl}/kunden-mitarbeiter/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by ': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemKundenMitarbeiterPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? creatorID = '',
    String? nachname = '',
    String? vorname = '',
    String? firmaRecID = '',
    String? kommunikationAnrede = '',
    String? kommunikationVerabschiedung = '',
    String? rolle = '',
    String? notizen = '',
    String? telefon = '',
    String? mobil = '',
    String? eMail = '',
    String? eintritt = '',
    String? austritt = '',
    bool? vip,
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KundenMitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "${escapeStringForJson(creatorID)}",
  "Nachname": "${escapeStringForJson(nachname)}",
  "Vorname": "${escapeStringForJson(vorname)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Kommunikation_Anrede": "${escapeStringForJson(kommunikationAnrede)}",
  "Kommunikation_Verabschiedung": "${escapeStringForJson(kommunikationVerabschiedung)}",
  "Rolle": "${escapeStringForJson(rolle)}",
  "Notizen": "${escapeStringForJson(notizen)}",
  "Telefon": "${escapeStringForJson(telefon)}",
  "Mobil": "${escapeStringForJson(mobil)}",
  "e-mail": "${escapeStringForJson(eMail)}",
  "Eintritt": "${escapeStringForJson(eintritt)}",
  "Austritt": "${escapeStringForJson(austritt)}",
  "VIP": ${vip}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemKundenMitarbeiterPost',
      apiUrl: '${baseUrl}/kunden-mitarbeiter/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneKundenMitarbeiterGetCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? itemId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KundenMitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneKundenMitarbeiterGet',
      apiUrl: '${baseUrl}/kunden-mitarbeiter/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: true,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemKundenMitarbeiterPutCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? creatorID = '',
    String? nachname = '',
    String? vorname = '',
    String? firmaRecID = '',
    String? kommunikationAnrede = '',
    String? kommunikationVerabschiedung = '',
    String? rolle = '',
    String? notizen = '',
    String? telefon = '',
    String? mobil = '',
    String? eMail = '',
    String? eintritt = '',
    String? austritt = '',
    bool? vip,
    String? itemId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KundenMitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "CreatorID": "${escapeStringForJson(creatorID)}",
  "Nachname": "${escapeStringForJson(nachname)}",
  "Vorname": "${escapeStringForJson(vorname)}",
  "Firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Kommunikation_Anrede": "${escapeStringForJson(kommunikationAnrede)}",
  "Kommunikation_Verabschiedung": "${escapeStringForJson(kommunikationVerabschiedung)}",
  "Rolle": "${escapeStringForJson(rolle)}",
  "Notizen": "${escapeStringForJson(notizen)}",
  "Telefon": "${escapeStringForJson(telefon)}",
  "Mobil": "${escapeStringForJson(mobil)}",
  "e-mail": "${escapeStringForJson(eMail)}",
  "Eintritt": "${escapeStringForJson(eintritt)}",
  "Austritt": "${escapeStringForJson(austritt)}",
  "VIP": ${vip}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemKundenMitarbeiterPut',
      apiUrl: '${baseUrl}KundenMitarbeiter/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteKundenMitarbeiterPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? itemId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = KundenMitarbeiterGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": ""
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteKundenMitarbeiterPost',
      apiUrl: '${baseUrl}/kunden-mitarbeiter/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End kundenMitarbeiter Group Code

/// Start leistungen Group Code

class LeistungenGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllLeistungenGetCall readAllLeistungenGetCall =
      ReadAllLeistungenGetCall();
  static CreateItemLeistungenPostCall createItemLeistungenPostCall =
      CreateItemLeistungenPostCall();
  static ReadOneLeistungenGetCall readOneLeistungenGetCall =
      ReadOneLeistungenGetCall();
  static UpdateItemLeistungenPutCall updateItemLeistungenPutCall =
      UpdateItemLeistungenPutCall();
  static MarkDeleteLeistungenPostCall markDeleteLeistungenPostCall =
      MarkDeleteLeistungenPostCall();
}

class ReadAllLeistungenGetCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = LeistungenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadAllLeistungenGet',
      apiUrl: '${baseUrl}/leistungen/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by ': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItemLeistungenPostCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? creator = '',
    String? firmaRecID = '',
    String? kundenvertragRecID = '',
    String? kundenvertragPreiseRecID = '',
    String? vorgangRecID = '',
    String? mitarbeiterRecID = '',
    String? leistungstext = '',
    int? auslastungsgrad,
    double? kulanzabzug,
    String? kulanzabzugGrund = '',
    String? leistungsstart1 = '',
    String? leistungsende1 = '',
    String? leistungsende2 = '',
    bool? erscheintNichtAufRechnungIntern,
    bool? pruefungNotwendig,
    bool? wFCPreisberechnung,
    String? wFCPreisberechnungLast = '',
    int? arbeitszeitMinutenNetto,
    double? preisProEinheit,
    String? einheit = '',
    double? summeEuro,
    double? summeEuroKulanz,
    bool? loeschen,
    String? leistungsstart2 = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = LeistungenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "Creator": "${escapeStringForJson(creator)}",
  "firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "kundenvertrag_RecID": "${escapeStringForJson(kundenvertragRecID)}",
  "kundenvertrag_preise_RecID": "${escapeStringForJson(kundenvertragPreiseRecID)}",
  "Vorgang_RecID": "${escapeStringForJson(vorgangRecID)}",
  "mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Leistungstext": "${escapeStringForJson(leistungstext)}",
  "Auslastungsgrad": ${auslastungsgrad},
  "Kulanzabzug": ${kulanzabzug},
  "Kulanzabzug_Grund": "${escapeStringForJson(kulanzabzugGrund)}",
  "Leistungsstart1": "${escapeStringForJson(leistungsstart1)}",
  "Leistungsende1": "${escapeStringForJson(leistungsende1)}",
  "Leistungsstart2": "${escapeStringForJson(leistungsstart2)}",
  "Leistungsende2": "${escapeStringForJson(leistungsende2)}",
  "Erscheint_nicht_Auf_Rechnung_Intern": ${erscheintNichtAufRechnungIntern},
  "Pruefung_notwendig": ${pruefungNotwendig},
  "WF_C_Preisberechnung": ${wFCPreisberechnung},
  "WF_C_Preisberechnung_last": "${escapeStringForJson(wFCPreisberechnungLast)}",
  "Arbeitszeit_Minuten_Netto": ${arbeitszeitMinutenNetto},
  "Preis_pro_Einheit": ${preisProEinheit},
  "Einheit": "${escapeStringForJson(einheit)}",
  "Summe_Euro": ${summeEuro},
  "Summe_Euro_Kulanz": ${summeEuroKulanz},
  "Loeschen": ${loeschen}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateItemLeistungenPost',
      apiUrl: '${baseUrl}/leistungen/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneLeistungenGetCall {
  Future<ApiCallResponse> call({
    String? recID = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = LeistungenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'ReadOneLeistungenGet',
      apiUrl: '${baseUrl}/leistungen/${recID}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItemLeistungenPutCall {
  Future<ApiCallResponse> call({
    String? recID = '',
    String? bearerAuth = '',
    String? creator = '',
    String? firmaRecID = '',
    String? kundenvertragRecID = '',
    String? kundenvertragPreiseRecID = '',
    String? vorgangRecID = '',
    String? mitarbeiterRecID = '',
    String? leistungstext = '',
    int? auslastungsgrad,
    double? kulanzabzug,
    String? kulanzabzugGrund = '',
    String? leistungsstart1 = '',
    String? leistungsende1 = '',
    String? leistungsstart2 = '',
    String? leistungsende2 = '',
    bool? erscheintNichtAufRechnungIntern,
    bool? pruefungNotwendig,
    bool? wFCPreisberechnung,
    String? wFCPreisberechnungLast = '',
    int? arbeitszeitMinutenNetto,
    double? preisProEinheit,
    String? einheit = '',
    double? summeEuro,
    double? summeEuroKulanz,
    bool? loeschen,
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = LeistungenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "Creator": "${escapeStringForJson(creator)}",
  "firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "kundenvertrag_RecID": "${escapeStringForJson(kundenvertragRecID)}",
  "kundenvertrag_preise_RecID": "${escapeStringForJson(kundenvertragPreiseRecID)}",
  "Vorgang_RecID": "${escapeStringForJson(vorgangRecID)}",
  "mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Leistungstext": "${escapeStringForJson(leistungstext)}",
  "Auslastungsgrad": ${auslastungsgrad},
  "Kulanzabzug": ${kulanzabzug},
  "Kulanzabzug_Grund": "${escapeStringForJson(kulanzabzugGrund)}",
  "Leistungsstart1": "${escapeStringForJson(leistungsstart1)}",
  "Leistungsende1": "${escapeStringForJson(leistungsende1)}",
  "Leistungsstart2": "${escapeStringForJson(leistungsstart2)}",
  "Leistungsende2": "${escapeStringForJson(leistungsende2)}",
  "Erscheint_nicht_Auf_Rechnung_Intern": ${erscheintNichtAufRechnungIntern},
  "Pruefung_notwendig": ${pruefungNotwendig},
  "WF_C_Preisberechnung": ${wFCPreisberechnung},
  "WF_C_Preisberechnung_last": "${escapeStringForJson(wFCPreisberechnungLast)}",
  "Arbeitszeit_Minuten_Netto": ${arbeitszeitMinutenNetto},
  "Preis_pro_Einheit": ${preisProEinheit},
  "Einheit": "${escapeStringForJson(einheit)}",
  "Summe_Euro": ${summeEuro},
  "Summe_Euro_Kulanz": ${summeEuroKulanz},
  "Loeschen": ${loeschen}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateItemLeistungenPut',
      apiUrl: '${baseUrl}/leistungen/${recID}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteLeistungenPostCall {
  Future<ApiCallResponse> call({
    String? recID = '',
    String? bearerAuth = '',
    String? grund = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = LeistungenGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "grund": "${escapeStringForJson(grund)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'MarkDeleteLeistungenPost',
      apiUrl: '${baseUrl}/leistungen/${recID}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End leistungen Group Code

/// Start todo Group Code

class TodoGroup {
  static String getBaseUrl({
    String? apiURl,
  }) {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    return '${apiURl}/api/dynamic_crud';
  }

  static Map<String, String> headers = {};
  static ReadAllTodoCall readAllTodoCall = ReadAllTodoCall();
  static CreateTodoCall createTodoCall = CreateTodoCall();
  static ReadOneTodoCall readOneTodoCall = ReadOneTodoCall();
  static UpdateTodoCall updateTodoCall = UpdateTodoCall();
  static MarkDeleteTodoCall markDeleteTodoCall = MarkDeleteTodoCall();
}

class ReadAllTodoCall {
  Future<ApiCallResponse> call({
    String? firmaRecID = '',
    String? search = '',
    String? filter = '',
    bool? filterContains,
    int? limit,
    int? offset,
    String? orderBy = '',
    String? orderDir = '',
    String? searchMode = '',
    String? fields = '',
    String? bearerAuth = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = TodoGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'readAllTodo',
      apiUrl: '${baseUrl}/todo/',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {
        'firmaRecID': firmaRecID,
        'search': search,
        'filter': filter,
        'filter_contains': filterContains,
        'limit': limit,
        'offset': offset,
        'order_by': orderBy,
        'order_dir': orderDir,
        'search_mode': searchMode,
        'fields': fields,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateTodoCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? mitarbeiterRecID = '',
    String? betreff = '',
    String? beschreibung = '',
    String? deadlineType = '',
    String? datumStart = '',
    String? datumEnde = '',
    int? dringlichkeitsIndex,
    String? typ = '',
    String? kundenMitarbeiterRecID = '',
    String? firmaRecID = '',
    bool? flexTermin,
    String? vorgangRecID = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = TodoGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung": "${escapeStringForJson(beschreibung)}",
  "Deadline_Type": "${escapeStringForJson(deadlineType)}",
  "Datum_Start": "${escapeStringForJson(datumStart)}",
  "Datum_Ende": "${escapeStringForJson(datumEnde)}",
  "dringlichkeits_index": ${dringlichkeitsIndex},
  "Typ": "${escapeStringForJson(typ)}",
  "kundenMitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Flex_Termin": ${flexTermin},
  "vorgang_RecID": "${escapeStringForJson(vorgangRecID)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createTodo',
      apiUrl: '${baseUrl}/todo/',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ReadOneTodoCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? itemId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = TodoGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'readOneTodo',
      apiUrl: '${baseUrl}/todo/${itemId}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateTodoCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? itemId = '',
    String? mitarbeiterRecID = '',
    String? betreff = '',
    String? beschreibung = '',
    String? deadlineType = '',
    String? datumStart = '',
    String? datumEnde = '',
    int? dringlichkeitsIndex,
    String? typ = '',
    String? kundenMitarbeiterRecID = '',
    String? firmaRecID = '',
    bool? flexTermin,
    String? vorgangRecID = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = TodoGroup.getBaseUrl(
      apiURl: apiURl,
    );

    final ffApiRequestBody = '''
{
  "mitarbeiter_RecID": "${escapeStringForJson(mitarbeiterRecID)}",
  "Betreff": "${escapeStringForJson(betreff)}",
  "Beschreibung": "${escapeStringForJson(beschreibung)}",
  "Deadline_Type": "${escapeStringForJson(deadlineType)}",
  "Datum_Start": "${escapeStringForJson(datumStart)}",
  "Datum_Ende": "${escapeStringForJson(datumEnde)}",
  "dringlichkeits_index": ${dringlichkeitsIndex},
  "Typ": "${escapeStringForJson(typ)}",
  "kundenMitarbeiter_RecID": "${escapeStringForJson(kundenMitarbeiterRecID)}",
  "firma_RecID": "${escapeStringForJson(firmaRecID)}",
  "Flex_Termin": ${flexTermin},
  "vorgang_RecID": "${escapeStringForJson(vorgangRecID)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateTodo',
      apiUrl: '${baseUrl}/todo/${itemId}',
      callType: ApiCallType.PUT,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: true,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class MarkDeleteTodoCall {
  Future<ApiCallResponse> call({
    String? bearerAuth = '',
    String? itemId = '',
    String? apiURl,
  }) async {
    apiURl ??= FFDevEnvironmentValues().apiURl;
    final baseUrl = TodoGroup.getBaseUrl(
      apiURl: apiURl,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'markDeleteTodo',
      apiUrl: '${baseUrl}/todo/${itemId}/mark-delete',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${bearerAuth}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End todo Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
