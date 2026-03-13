import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'template_wiedervorlage_widget.dart' show TemplateWiedervorlageWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateWiedervorlageModel
    extends FlutterFlowModel<TemplateWiedervorlageWidget> {
  ///  Local state fields for this component.

  String? zeitWahl;

  String? grundDerWiedervorlage;

  String? kundenMitarbeiter;

  ///  State fields for stateful widgets in this component.

  DateTime? datePicked;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for kundenMitarbeiterDropdown widget.
  String? kundenMitarbeiterDropdownValue;
  FormFieldController<String>? kundenMitarbeiterDropdownValueController;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (createTodo)] action in Speichern widget.
  ApiCallResponse? apiResultmqv;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in Speichern widget.
  ApiCallResponse? apiResultlrh324;
  // Stores action output result for [Backend Call - API (UpdateItemVorgangPut)] action in Speichern widget.
  ApiCallResponse? apiResult0wt;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
