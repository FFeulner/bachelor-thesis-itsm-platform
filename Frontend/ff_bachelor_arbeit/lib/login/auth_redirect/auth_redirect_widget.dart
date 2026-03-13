import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'auth_redirect_model.dart';
export 'auth_redirect_model.dart';

class AuthRedirectWidget extends StatefulWidget {
  const AuthRedirectWidget({
    super.key,
    required this.code,
  });

  final String? code;

  static String routeName = 'auth-redirect';
  static String routePath = '/auth-redirect';

  @override
  State<AuthRedirectWidget> createState() => _AuthRedirectWidgetState();
}

class _AuthRedirectWidgetState extends State<AuthRedirectWidget> {
  late AuthRedirectModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AuthRedirectModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Anmeldung im Backend
      _model.callback = await AuthGroup.callbackCall.call(
        code: widget!.code,
        verifier: FFAppState().authVerifier,
      );

      if ((_model.callback?.succeeded ?? true) == true) {
        // Setzt die Token von Zitadel in den AppState
        FFAppState().accessToken =
            AuthResponseStruct.maybeFromMap((_model.callback?.jsonBody ?? ''))!
                .accessToken;
        FFAppState().refreshToken =
            AuthResponseStruct.maybeFromMap((_model.callback?.jsonBody ?? ''))!
                .refreshToken;
        FFAppState().idToken =
            AuthResponseStruct.maybeFromMap((_model.callback?.jsonBody ?? ''))!
                .idToken;
        // Extrahhiert die Benutzer Daten des Users aus dem ID-Token und speichert diese im App State "currentUser" als Json
        await actions.speichereNutzerAusIdToken();
        // Navigation zur Start Seite

        context.goNamed(MeinCockpitWidget.routeName);
      } else {
        // Anmeldung Fehlgeschlagen -> Zurück zum Login

        context.goNamed(LoginWidget.routeName);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      ),
    );
  }
}
