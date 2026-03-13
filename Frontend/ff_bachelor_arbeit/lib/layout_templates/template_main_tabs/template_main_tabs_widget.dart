import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/playground/list_table_test_widget/list_table_test_widget_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'template_main_tabs_model.dart';
export 'template_main_tabs_model.dart';

class TemplateMainTabsWidget extends StatefulWidget {
  const TemplateMainTabsWidget({super.key});

  @override
  State<TemplateMainTabsWidget> createState() => _TemplateMainTabsWidgetState();
}

class _TemplateMainTabsWidgetState extends State<TemplateMainTabsWidget>
    with TickerProviderStateMixin {
  late TemplateMainTabsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TemplateMainTabsModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 0,
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
                text: 'ListView',
              ),
              Tab(
                text: 'Element',
              ),
              Tab(
                text: 'JunctionA',
              ),
              Tab(
                text: 'JunctionB',
              ),
            ],
            controller: _model.tabBarController,
            onTap: (i) async {
              [() async {}, () async {}, () async {}, () async {}][i]();
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _model.tabBarController,
            children: [
              wrapWithModel(
                model: _model.listTableTestWidgetModel,
                updateCallback: () => safeSetState(() {}),
                child: ListTableTestWidgetWidget(),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
