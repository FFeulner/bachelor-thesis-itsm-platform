import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/layout_templates/template_kommunikation/template_kommunikation_widget.dart';
import '/layout_templates/template_todo_termin/template_todo_termin_widget.dart';
import '/layout_templates/template_wiedervorlage/template_wiedervorlage_widget.dart';
import '/layout_templates/templateleistung/templateleistung_widget.dart';
import '/vorgang/vorgang_tab/vorgang_tab_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'vorgang_action_bar_model.dart';
export 'vorgang_action_bar_model.dart';

class VorgangActionBarWidget extends StatefulWidget {
  const VorgangActionBarWidget({super.key});

  @override
  State<VorgangActionBarWidget> createState() => _VorgangActionBarWidgetState();
}

class _VorgangActionBarWidgetState extends State<VorgangActionBarWidget>
    with TickerProviderStateMixin {
  late VorgangActionBarModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VorgangActionBarModel());

    animationsMap.addAll({
      'buttonOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation5': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation6': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation7': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation8': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation9': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation10': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation11': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
      'buttonOnActionTriggerAnimation12': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            color: Color(0x80FFFFFF),
            angle: 0.524,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Kategorisiert') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'In Bearbeitung') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Wiedervorlage') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Feedbackloop'))
                      FFButtonWidget(
                        onPressed: () async {
                          _model.apiResultkdeCopy =
                              await VorgangGroup.updateItemVorgangPutCall.call(
                            bearerAuth: FFAppState().accessToken,
                            recID: VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.recID,
                            mitarbeiterRecID: MitarbeiterStruct.maybeFromMap(
                                    FFAppState().currentUser)
                                ?.recID,
                            status: 'In Bearbeitung',
                          );

                          FFAppState().selectedVorgangObject =
                              functions.updateJson('Status', 'In Bearbeitung',
                                  FFAppState().selectedVorgangObject);
                          safeSetState(() {});
                          if ((_model.apiResultkdeCopy?.succeeded ?? true)) {
                            _model.apiResultlrh = await AktivitaetenGroup
                                .createItemAktivitaetenCall
                                .call(
                              bearerAuth: FFAppState().accessToken,
                              aktion:
                                  'Vorgang: ${VorgangStruct.maybeFromMap((_model.apiResultkdeCopy?.jsonBody ?? ''))?.betreff} Wird Weitergearbeitet  von ${CurrentUserStruct.maybeFromMap(FFAppState().currentUser)?.givenName}',
                              entityRecID: VorgangStruct.maybeFromMap(
                                      FFAppState().selectedVorgangObject)
                                  ?.recID,
                              aktionInhalt:
                                  (_model.apiResultkdeCopy?.jsonBody ?? '')
                                      .toString(),
                              entityTable: 'vorgang',
                              mitarbeiterRecID: MitarbeiterStruct.maybeFromMap(
                                      FFAppState().currentUser)
                                  ?.recID,
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('Fehler'),
                                  content: Text(
                                      'Die Anfrage konnte nicht durchgeführt werden'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          FFAppState().update(() {});

                          safeSetState(() {});
                        },
                        text: VorgangStruct.maybeFromMap(
                                        FFAppState().selectedVorgangObject)
                                    ?.status ==
                                'Kategorisiert'
                            ? 'Beginnen'
                            : 'Weiterarbeiten',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ).animateOnActionTrigger(
                        animationsMap['buttonOnActionTriggerAnimation1']!,
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                        FFAppState().selectedVorgangObject)
                                    ?.status !=
                                null &&
                            VorgangStruct.maybeFromMap(
                                        FFAppState().selectedVorgangObject)
                                    ?.status !=
                                '') &&
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status !=
                            'Neu') &&
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status !=
                            'Kategorisiert'))
                      FFButtonWidget(
                        onPressed: () async {
                          _model.apiResultkde =
                              await VorgangGroup.updateItemVorgangPutCall.call(
                            bearerAuth: FFAppState().accessToken,
                            recID: VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.recID,
                            mitarbeiterRecID: MitarbeiterStruct.maybeFromMap(
                                    FFAppState().currentUser)
                                ?.recID,
                            status: 'In Bearbeitung',
                          );

                          FFAppState().selectedVorgangObject =
                              functions.updateJson('Status', 'In Bearbeitung',
                                  FFAppState().selectedVorgangObject);
                          safeSetState(() {});
                          if ((_model.apiResultkde?.succeeded ?? true)) {
                            _model.apiResultlrhfasfs = await AktivitaetenGroup
                                .createItemAktivitaetenCall
                                .call(
                              bearerAuth: FFAppState().accessToken,
                              aktion:
                                  'Vorgang: ${VorgangStruct.maybeFromMap((_model.apiResultkde?.jsonBody ?? ''))?.betreff} übernommen  von ${CurrentUserStruct.maybeFromMap(FFAppState().currentUser)?.givenName}',
                              entityRecID: VorgangStruct.maybeFromMap((_model
                                          .vorgangputjkdabhjad7613?.jsonBody ??
                                      ''))
                                  ?.recID,
                              aktionInhalt:
                                  (_model.apiResultkde?.jsonBody ?? '')
                                      .toString(),
                              entityTable: 'vorgang',
                              mitarbeiterRecID: MitarbeiterStruct.maybeFromMap(
                                      FFAppState().currentUser)
                                  ?.recID,
                            );
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text('Fehler'),
                                  content: Text(
                                      'Die Anfrage konnte nicht durchgeführt werden'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          FFAppState().update(() {});

                          safeSetState(() {});
                        },
                        text: 'Übernehmen',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ).animateOnActionTrigger(
                        animationsMap['buttonOnActionTriggerAnimation2']!,
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                        FFAppState().selectedVorgangObject)
                                    ?.status !=
                                null &&
                            VorgangStruct.maybeFromMap(
                                        FFAppState().selectedVorgangObject)
                                    ?.status !=
                                '') &&
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status !=
                            'Neu'))
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateleistungWidget(
                                      typ: 'vorgangNeu',
                                      firmaRecID: FirmaStruct.maybeFromMap(
                                              FFAppState().selectedKundeFirma)
                                          ?.recID,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'Leistung',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation3']!,
                        ),
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'In Bearbeitung') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Feedbackloop'))
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateTodoTerminWidget(
                                      recID: '',
                                      firmaRecID: FirmaStruct.maybeFromMap(
                                              FFAppState().selectedKundeFirma)
                                          ?.recID,
                                      typ: 'vorgangNeu',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'Termin',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation4']!,
                        ),
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'In Bearbeitung') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Wiedervorlage') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Feedbackloop'))
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateWiedervorlageWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'Wiedervorlage',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation5']!,
                        ),
                      ),
                    if (VorgangStruct.maybeFromMap(
                                FFAppState().selectedVorgangObject)
                            ?.status ==
                        'In Bearbeitung')
                      FFButtonWidget(
                        onPressed: () async {
                          if (VorgangStruct.maybeFromMap(
                                          FFAppState().selectedVorgangObject)
                                      ?.loesung !=
                                  null &&
                              VorgangStruct.maybeFromMap(
                                          FFAppState().selectedVorgangObject)
                                      ?.loesung !=
                                  '') {
                            _model.vorgangputjkdabhjad7613 = await VorgangGroup
                                .updateItemVorgangPutCall
                                .call(
                              bearerAuth: FFAppState().accessToken,
                              recID: VorgangStruct.maybeFromMap(
                                      FFAppState().selectedVorgangObject)
                                  ?.recID,
                              status: 'Gelöst',
                              loesung: VorgangStruct.maybeFromMap(
                                      FFAppState().selectedVorgangObject)
                                  ?.loesung,
                            );

                            FFAppState().selectedVorgangObject =
                                functions.updateJson('Status', 'Gelöst',
                                    FFAppState().selectedVorgangObject);
                            safeSetState(() {});
                            if ((_model.vorgangputjkdabhjad7613?.succeeded ??
                                true)) {
                              _model.apiResultlrh53534 = await AktivitaetenGroup
                                  .createItemAktivitaetenCall
                                  .call(
                                bearerAuth: FFAppState().accessToken,
                                aktion:
                                    'Vorgang: ${VorgangStruct.maybeFromMap((_model.vorgangputjkdabhjad7613?.jsonBody ?? ''))?.betreff} gelöst von ${CurrentUserStruct.maybeFromMap(FFAppState().currentUser)?.givenName}',
                                entityRecID: VorgangStruct.maybeFromMap((_model
                                            .vorgangputjkdabhjad7613
                                            ?.jsonBody ??
                                        ''))
                                    ?.recID,
                                aktionInhalt:
                                    (_model.vorgangputjkdabhjad7613?.jsonBody ??
                                            '')
                                        .toString(),
                                entityTable: 'vorgang',
                                mitarbeiterRecID:
                                    MitarbeiterStruct.maybeFromMap(
                                            FFAppState().currentUser)
                                        ?.recID,
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Fehler'),
                                    content: Text(
                                        'Die Anfrage konnte nicht durchgeführt werden'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }

                            FFAppState().update(() {});
                          } else {
                            await showDialog(
                              context: context,
                              builder: (alertDialogContext) {
                                return AlertDialog(
                                  title: Text(
                                      'Bitte im Reiter Details die Lösung auswählen'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(alertDialogContext),
                                      child: Text('Ok'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }

                          safeSetState(() {});
                        },
                        text: 'Lösen',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ).animateOnActionTrigger(
                        animationsMap['buttonOnActionTriggerAnimation6']!,
                      ),
                    if (VorgangStruct.maybeFromMap(
                                FFAppState().selectedVorgangObject)
                            ?.status ==
                        'Gelöst')
                      FFButtonWidget(
                        onPressed: () async {
                          var confirmDialogResponse = await showDialog<bool>(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Ticket schließen?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, false),
                                        child: Text('Nein'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            alertDialogContext, true),
                                        child: Text('Ja'),
                                      ),
                                    ],
                                  );
                                },
                              ) ??
                              false;
                          if (confirmDialogResponse) {
                            _model.apiResult0wt = await VorgangGroup
                                .updateItemVorgangPutCall
                                .call(
                              bearerAuth: FFAppState().accessToken,
                              recID: VorgangStruct.maybeFromMap(
                                      FFAppState().selectedVorgangObject)
                                  ?.recID,
                              status: 'Geschlossen',
                            );

                            FFAppState().selectedVorgangObject =
                                functions.updateJson('Status', 'Geschlossen',
                                    FFAppState().selectedVorgangObject);
                            safeSetState(() {});
                            if ((_model.apiResult0wt?.succeeded ?? true)) {
                              _model.apiResultlrh324 = await AktivitaetenGroup
                                  .createItemAktivitaetenCall
                                  .call(
                                bearerAuth: FFAppState().accessToken,
                                aktion:
                                    'Vorgang: ${VorgangStruct.maybeFromMap((_model.apiResult0wt?.jsonBody ?? ''))?.betreff} geschlossen von ${CurrentUserStruct.maybeFromMap(FFAppState().currentUser)?.givenName}',
                                entityRecID: VorgangStruct.maybeFromMap(
                                        (_model.apiResult0wt?.jsonBody ?? ''))
                                    ?.recID,
                                aktionInhalt:
                                    (_model.apiResult0wt?.jsonBody ?? '')
                                        .toString(),
                                entityTable: 'vorgang',
                                mitarbeiterRecID:
                                    MitarbeiterStruct.maybeFromMap(
                                            FFAppState().currentUser)
                                        ?.recID,
                              );
                            } else {
                              await showDialog(
                                context: context,
                                builder: (alertDialogContext) {
                                  return AlertDialog(
                                    title: Text('Fehler'),
                                    content: Text(
                                        'Das Ticket konnte nicht geschlossen werden'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(alertDialogContext),
                                        child: Text('Ok'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }

                          FFAppState().update(() {});

                          safeSetState(() {});
                        },
                        text: 'Schließen',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryBackground,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ).animateOnActionTrigger(
                        animationsMap['buttonOnActionTriggerAnimation7']!,
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Kategorisiert') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'In Bearbeitung') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Gelöst') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Wiedervorlage'))
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateKommunikationWidget(
                                      typ: 'vorgang',
                                      vorgangRecID: VorgangStruct.maybeFromMap(
                                              FFAppState()
                                                  .selectedVorgangObject)
                                          ?.recID,
                                      projektRecID: '',
                                      replyGraphMSG: '',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'E-Mail',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation8']!,
                        ),
                      ),
                    if (false)
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateTodoTerminWidget(
                                      recID: VorgangStruct.maybeFromMap(
                                              FFAppState()
                                                  .selectedVorgangObject)!
                                          .recID,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          text: 'Aufgabe erstellen',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation9']!,
                        ),
                      ),
                    if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Kategorisiert') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'In Bearbeitung') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Wiedervorlage') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Feedbackloop') ||
                        (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            'Gelöst'))
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: TemplateKommunikationWidget(
                                      typ: 'Notiz',
                                      vorgangRecID: VorgangStruct.maybeFromMap(
                                              FFAppState()
                                                  .selectedVorgangObject)
                                          ?.recID,
                                      projektRecID: '',
                                      replyGraphMSG: '',
                                    ),
                                  ),
                                );
                              },
                            );

                            FFAppState().update(() {});
                          },
                          text: 'Kommentar',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation10']!,
                        ),
                      ),
                    if (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            null ||
                        VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.status ==
                            '')
                      Builder(
                        builder: (context) => FFButtonWidget(
                          onPressed: () async {
                            await showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: Container(
                                    height: 800.0,
                                    width: 1200.0,
                                    child: VorgangTabWidget(
                                      typ: 'erstellen',
                                    ),
                                  ),
                                );
                              },
                            );

                            FFAppState().update(() {});
                          },
                          text: 'Neu',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  font: GoogleFonts.interTight(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ).animateOnActionTrigger(
                          animationsMap['buttonOnActionTriggerAnimation11']!,
                        ),
                      ),
                  ].divide(SizedBox(width: 10.0)),
                ),
              ],
            ),
          ],
        ),
        if (VorgangStruct.maybeFromMap(FFAppState().selectedVorgangObject)
                ?.status ==
            'Neu')
          FFButtonWidget(
            onPressed: () async {
              var confirmDialogResponse = await showDialog<bool>(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text('Willst du das Ticket kategorisieren'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(alertDialogContext, false),
                            child: Text('Abbrechen'),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(alertDialogContext, true),
                            child: Text('Bestätigen'),
                          ),
                        ],
                      );
                    },
                  ) ??
                  false;
              if (confirmDialogResponse) {
                if ((VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.priorisierung !=
                            null &&
                        VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.priorisierung !=
                            '') &&
                    (VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.kategorie !=
                            null &&
                        VorgangStruct.maybeFromMap(
                                    FFAppState().selectedVorgangObject)
                                ?.kategorie !=
                            '')) {
                  _model.apiResults2p =
                      await VorgangGroup.updateItemVorgangPutCall.call(
                    bearerAuth: FFAppState().accessToken,
                    recID: VorgangStruct.maybeFromMap(
                            FFAppState().selectedVorgangObject)
                        ?.recID,
                    status: 'Kategorisiert',
                    priorisierung: VorgangStruct.maybeFromMap(
                            FFAppState().selectedVorgangObject)
                        ?.priorisierung,
                    kategorie: VorgangStruct.maybeFromMap(
                            FFAppState().selectedVorgangObject)
                        ?.kategorie,
                  );

                  FFAppState().selectedVorgangObject = functions.updateJson(
                      'Status',
                      'Kategorisiert',
                      FFAppState().selectedVorgangObject);
                  safeSetState(() {});
                  FFAppState().selectedVorgangObject = functions.updateJson(
                      'Status',
                      'Kategorisiert',
                      FFAppState().selectedVorgangObject);
                  safeSetState(() {});
                  if ((_model.apiResults2p?.succeeded ?? true)) {
                    _model.apiResultlrhadsda =
                        await AktivitaetenGroup.createItemAktivitaetenCall.call(
                      bearerAuth: FFAppState().accessToken,
                      aktion:
                          'Vorgang: ${VorgangStruct.maybeFromMap((_model.apiResults2p?.jsonBody ?? ''))?.betreff} kategorisiert von ${CurrentUserStruct.maybeFromMap(FFAppState().currentUser)?.givenName}',
                      entityRecID: VorgangStruct.maybeFromMap(
                              FFAppState().selectedVorgangObject)
                          ?.recID,
                      aktionInhalt:
                          (_model.apiResults2p?.jsonBody ?? '').toString(),
                      entityTable: 'vorgang',
                      mitarbeiterRecID: MitarbeiterStruct.maybeFromMap(
                              FFAppState().currentUser)
                          ?.recID,
                    );
                  } else {
                    confirmDialogResponse = await showDialog<bool>(
                          context: context,
                          builder: (alertDialogContext) {
                            return AlertDialog(
                              title: Text('Fehler'),
                              content: Text(
                                  (_model.apiResults2p?.jsonBody ?? '')
                                      .toString()),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(alertDialogContext, true),
                                  child: Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;
                  }
                } else {
                  await showDialog(
                    context: context,
                    builder: (alertDialogContext) {
                      return AlertDialog(
                        title: Text(
                            'Bitte im Reiter Details die Kategorie und Priorisierung auswählen'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(alertDialogContext),
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }

              FFAppState().update(() {});

              safeSetState(() {});
            },
            text: 'Kategorisieren',
            options: FFButtonOptions(
              height: 40.0,
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              color: FlutterFlowTheme.of(context).primaryBackground,
              textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.interTight(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).primary,
                    fontSize: 16.0,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
              elevation: 0.0,
              borderSide: BorderSide(
                color: FlutterFlowTheme.of(context).primary,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ).animateOnActionTrigger(
            animationsMap['buttonOnActionTriggerAnimation12']!,
          ),
      ],
    );
  }
}
