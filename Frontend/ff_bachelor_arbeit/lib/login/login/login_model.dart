import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (RefreshToken)] action in login widget.
  ApiCallResponse? refreshTokenAnmeldung;
  // Stores action output result for [Backend Call - API (OfflineLogin)] action in Button widget.
  ApiCallResponse? offlineLogin;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
