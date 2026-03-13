import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'auth_redirect_widget.dart' show AuthRedirectWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AuthRedirectModel extends FlutterFlowModel<AuthRedirectWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (Callback)] action in auth-redirect widget.
  ApiCallResponse? callback;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
