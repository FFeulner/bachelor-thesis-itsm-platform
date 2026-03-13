import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'template_todo_termin_widget.dart' show TemplateTodoTerminWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateTodoTerminModel
    extends FlutterFlowModel<TemplateTodoTerminWidget> {
  ///  Local state fields for this component.

  String? mitarbeiter;

  String? typ;

  DateTime? startZeit;

  DateTime? endeZeit;

  bool? flexTermin;

  String? betreff;

  String? beschreibung;

  String? kundenMitarbeiter;

  String? firma;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (readOneTodo)] action in TemplateTodoTermin widget.
  ApiCallResponse? readOneToDo;
  // State field(s) for kundenMitarbeiterDropdown widget.
  String? kundenMitarbeiterDropdownValue;
  FormFieldController<String>? kundenMitarbeiterDropdownValueController;
  // State field(s) for FirmaDropdown widget.
  String? firmaDropdownValue;
  FormFieldController<String>? firmaDropdownValueController;
  // State field(s) for mitarbeiterDropdown widget.
  String? mitarbeiterDropdownValue;
  FormFieldController<String>? mitarbeiterDropdownValueController;
  // State field(s) for TypDropDown widget.
  String? typDropDownValue;
  FormFieldController<String>? typDropDownValueController;
  DateTime? datePicked1;
  DateTime? datePicked2;
  // State field(s) for BetreffTextField widget.
  FocusNode? betreffTextFieldFocusNode;
  TextEditingController? betreffTextFieldTextController;
  String? Function(BuildContext, String?)?
      betreffTextFieldTextControllerValidator;
  // State field(s) for beschreibungTextfield widget.
  FocusNode? beschreibungTextfieldFocusNode;
  TextEditingController? beschreibungTextfieldTextController;
  String? Function(BuildContext, String?)?
      beschreibungTextfieldTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Backend Call - API (createTodo)] action in Speichern widget.
  ApiCallResponse? cretateToDoakldha32;
  // Stores action output result for [Backend Call - API (updateTodo)] action in Speichern widget.
  ApiCallResponse? apiResult718;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    betreffTextFieldFocusNode?.dispose();
    betreffTextFieldTextController?.dispose();

    beschreibungTextfieldFocusNode?.dispose();
    beschreibungTextfieldTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController3?.dispose();
  }
}
