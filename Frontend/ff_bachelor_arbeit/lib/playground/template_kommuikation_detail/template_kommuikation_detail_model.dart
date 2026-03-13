import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/layout_templates/template_kommunikation/template_kommunikation_widget.dart';
import '/playground/img_viewer/img_viewer_widget.dart';
import '/playground/pdf_viewer/pdf_viewer_widget.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'template_kommuikation_detail_widget.dart'
    show TemplateKommuikationDetailWidget;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateKommuikationDetailModel
    extends FlutterFlowModel<TemplateKommuikationDetailWidget> {
  ///  Local state fields for this component.

  bool gelesenNotwendig = true;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - API (UpdateItemKommunikationPut)] action in Button widget.
  ApiCallResponse? apiResultgmf;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
