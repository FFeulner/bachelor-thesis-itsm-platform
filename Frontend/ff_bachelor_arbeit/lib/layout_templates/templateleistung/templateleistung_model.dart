import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'templateleistung_widget.dart' show TemplateleistungWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateleistungModel extends FlutterFlowModel<TemplateleistungWidget> {
  ///  Local state fields for this component.

  DateTime? startZeit;

  DateTime? endeZeit;

  String? vertrag;

  String? firma;

  String? mitarbeiter;

  int? auslastungsgrad;

  int? abrechnungKulanzteil;

  bool? vogesetzterSollPruefen;

  bool? erscheintNichtAufRechnung;

  String? leistungsBeschreibung;

  String? kulanzGrund;

  String? grund;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (ReadOneLeistungenGet)] action in Templateleistung widget.
  ApiCallResponse? leistungen813618;
  // State field(s) for VetragDropdown widget.
  String? vetragDropdownValue;
  FormFieldController<String>? vetragDropdownValueController;
  // State field(s) for FirmaDropdown widget.
  String? firmaDropdownValue;
  FormFieldController<String>? firmaDropdownValueController;
  // State field(s) for MitarbeiterDropdown widget.
  String? mitarbeiterDropdownValue;
  FormFieldController<String>? mitarbeiterDropdownValueController;
  // State field(s) for FlowPushDropdown widget.
  String? flowPushDropdownValue;
  FormFieldController<String>? flowPushDropdownValueController;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for Auslastungsgrad widget.
  int? auslastungsgradValue;
  FormFieldController<int>? auslastungsgradValueController;
  // State field(s) for Einheiten widget.
  FocusNode? einheitenFocusNode;
  TextEditingController? einheitenTextController;
  String? Function(BuildContext, String?)? einheitenTextControllerValidator;
  // State field(s) for Beschreibung widget.
  FocusNode? beschreibungFocusNode;
  TextEditingController? beschreibungTextController;
  String? Function(BuildContext, String?)? beschreibungTextControllerValidator;
  // State field(s) for KulanzAnteil widget.
  int? kulanzAnteilValue;
  FormFieldController<int>? kulanzAnteilValueController;
  // State field(s) for KulanzGrund widget.
  FocusNode? kulanzGrundFocusNode;
  TextEditingController? kulanzGrundTextController;
  String? Function(BuildContext, String?)? kulanzGrundTextControllerValidator;
  // State field(s) for CheckboxPruefen widget.
  bool? checkboxPruefenValue;
  // State field(s) for CheckboxNichtAufRechnung widget.
  bool? checkboxNichtAufRechnungValue;
  // State field(s) for Grund widget.
  FocusNode? grundFocusNode;
  TextEditingController? grundTextController;
  String? Function(BuildContext, String?)? grundTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // Stores action output result for [Backend Call - API (CreateItemLeistungenPost)] action in Speichern widget.
  ApiCallResponse? createLeistungajdladghua;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in Speichern widget.
  ApiCallResponse? apiResultlrhdadad;
  // Stores action output result for [Backend Call - API (UpdateItemLeistungenPut)] action in Speichern widget.
  ApiCallResponse? updateLeistungdakdga;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in Speichern widget.
  ApiCallResponse? apiResultlrhadasdas;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    einheitenFocusNode?.dispose();
    einheitenTextController?.dispose();

    beschreibungFocusNode?.dispose();
    beschreibungTextController?.dispose();

    kulanzGrundFocusNode?.dispose();
    kulanzGrundTextController?.dispose();

    grundFocusNode?.dispose();
    grundTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController5?.dispose();
  }
}
