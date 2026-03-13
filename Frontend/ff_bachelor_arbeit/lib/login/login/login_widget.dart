import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({
    super.key,
    this.code,
  });

  final String? code;

  static String routeName = 'login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Setzt alten AccessToken auf null
      FFAppState().accessToken = '';
      // Prüft ob RefreshToken vorhanden ist -> wenn leer wird normal angemeldet, ansonsten wird über den RefreshToken angemeldet
      if (FFAppState().refreshToken != '') {
        _model.refreshTokenAnmeldung = await AuthGroup.refreshTokenCall.call(
          refreshToken: FFAppState().refreshToken,
        );

        // RefreshToken Anmeldung möglich:
        // Nein = Abgelaufen, Problem, Störung
        // Ja = Anmeldung über RefreshToken
        if ((_model.refreshTokenAnmeldung?.succeeded ?? true) == true) {
          // Setzt Token aus der Anmeldung in den AppState
          FFAppState().accessToken = AuthResponseStruct.maybeFromMap(
                  (_model.refreshTokenAnmeldung?.jsonBody ?? ''))!
              .accessToken;
          FFAppState().refreshToken = AuthResponseStruct.maybeFromMap(
                  (_model.refreshTokenAnmeldung?.jsonBody ?? ''))!
              .refreshToken;
          FFAppState().idToken = AuthResponseStruct.maybeFromMap(
                  (_model.refreshTokenAnmeldung?.jsonBody ?? ''))!
              .idToken;
          safeSetState(() {});
          // StartSeite wählen

          context.pushNamed(MeinCockpitWidget.routeName);
        }
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: Image.asset(
                'assets/images/shutterstock_376532611-og.jpg',
              ).image,
            ),
          ),
          child: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      // CustomFunction "startZitadelLogin" generiert die Challange und den Code Veriffier für das PKCE Áuth und leitet an Zitadel weiter
                      await actions.startZitadelLogin(
                        context,
                      );
                    },
                    text: 'Login with Aegis',
                    options: FFButtonOptions(
                      width: 250.0,
                      height: 80.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () async {
                    _model.offlineLogin =
                        await AuthGroup.offlineLoginCall.call();

                    if ((_model.offlineLogin?.succeeded ?? true)) {
                      FFAppState().accessToken = getJsonField(
                        (_model.offlineLogin?.jsonBody ?? ''),
                        r'''$.access_token''',
                      ).toString();
                      FFAppState().idToken = getJsonField(
                        (_model.offlineLogin?.jsonBody ?? ''),
                        r'''$.id_token''',
                      ).toString();
                      await actions.speichereNutzerAusIdToken();
                    }

                    context.pushNamed(MeinCockpitWidget.routeName);

                    safeSetState(() {});
                  },
                  text: 'Offline Login',
                  options: FFButtonOptions(
                    width: 250.0,
                    height: 80.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).secondary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ].divide(SizedBox(height: 50.0)),
            ),
          ),
        ),
      ),
    );
  }
}
