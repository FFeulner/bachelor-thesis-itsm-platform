import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'template_kommunikation_widget.dart' show TemplateKommunikationWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateKommunikationModel
    extends FlutterFlowModel<TemplateKommunikationWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (ReadOneVorgangGet)] action in TemplateKommunikation widget.
  ApiCallResponse? vorgangRead8addada3;
  // Stores action output result for [Backend Call - API (ReadOneKundenMitarbeiterGet)] action in TemplateKommunikation widget.
  ApiCallResponse? kundenMitarbeiterGet;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // Stores action output result for [Custom Action - uploadEmailAttachments] action in Button widget.
  List<String>? uploadEmailAttachment78313d;
  // Stores action output result for [Backend Call - API (CreateItemKommunikationPost)] action in Button widget.
  ApiCallResponse? apiResult4h7;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in Button widget.
  ApiCallResponse? apiResultlrh;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();
  }
}
