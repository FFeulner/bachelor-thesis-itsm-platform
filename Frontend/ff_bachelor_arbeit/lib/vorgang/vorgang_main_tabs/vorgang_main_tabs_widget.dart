import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/listen/cmdb_liste/cmdb_liste_widget.dart';
import '/listen/kommunikation_liste/kommunikation_liste_widget.dart';
import '/listen/leitsungs_liste/leitsungs_liste_widget.dart';
import '/listen/vorgangs_liste/vorgangs_liste_widget.dart';
import '/vorgang/vorgang_tab/vorgang_tab_widget.dart';
import 'dart:ui';
import '/backend/schema/structs/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'vorgang_main_tabs_model.dart';
export 'vorgang_main_tabs_model.dart';

class VorgangMainTabsWidget extends StatefulWidget {
  const VorgangMainTabsWidget({super.key});

  @override
  State<VorgangMainTabsWidget> createState() => _VorgangMainTabsWidgetState();
}

class _VorgangMainTabsWidgetState extends State<VorgangMainTabsWidget>
    with TickerProviderStateMixin {
  late VorgangMainTabsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VorgangMainTabsModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      safeSetState(() {
        _model.tabBarController!.animateTo(
          FFAppState().indexSchieber,
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });

      FFAppState().indexSchieber = 0;
      _model.updatePage(() {});
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: min(
          valueOrDefault<int>(
            FFAppState().indexSchieber,
            0,
          ),
          5),
    )..addListener(() => safeSetState(() {}));

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

    return Column(
      children: [
        Align(
          alignment: Alignment(0.0, 0),
          child: TabBar(
            labelColor: FlutterFlowTheme.of(context).primaryText,
            unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
            labelStyle: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                ),
            unselectedLabelStyle: FlutterFlowTheme.of(context)
                .titleMedium
                .override(
                  font: GoogleFonts.interTight(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            indicatorColor: FlutterFlowTheme.of(context).primary,
            tabs: [
              Tab(
                text: 'Vorgänge',
              ),
              Tab(
                text: 'Details',
              ),
              Tab(
                text: 'CMDB',
              ),
              Tab(
                text: 'SOPs',
              ),
              Tab(
                text: 'Kommunikation',
              ),
              Tab(
                text: 'Leistungen',
              ),
            ],
            controller: _model.tabBarController,
            onTap: (i) async {
              [
                () async {},
                () async {},
                () async {},
                () async {},
                () async {},
                () async {}
              ][i]();
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _model.tabBarController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              wrapWithModel(
                model: _model.vorgangsListeModel,
                updateCallback: () => safeSetState(() {}),
                child: VorgangsListeWidget(),
              ),
              wrapWithModel(
                model: _model.vorgangTabModel,
                updateCallback: () => safeSetState(() {}),
                child: VorgangTabWidget(
                  typ: 'vorgang',
                ),
              ),
              wrapWithModel(
                model: _model.cmdbListeModel,
                updateCallback: () => safeSetState(() {}),
                child: CmdbListeWidget(),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [],
              ),
              Visibility(
                visible: FFAppState().selectedVorgangObject != null,
                child: wrapWithModel(
                  model: _model.kommunikationListeModel,
                  updateCallback: () => safeSetState(() {}),
                  child: KommunikationListeWidget(
                    filter:
                        'Vorgang_RecID:${VorgangStruct.maybeFromMap(FFAppState().selectedVorgangObject)?.recID}',
                  ),
                ),
              ),
              Visibility(
                visible: FFAppState().selectedVorgangObject != null,
                child: wrapWithModel(
                  model: _model.leitsungsListeModel,
                  updateCallback: () => safeSetState(() {}),
                  child: LeitsungsListeWidget(
                    filter:
                        'Vorgang_RecID:${VorgangStruct.maybeFromMap(FFAppState().selectedVorgangObject)?.recID}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
