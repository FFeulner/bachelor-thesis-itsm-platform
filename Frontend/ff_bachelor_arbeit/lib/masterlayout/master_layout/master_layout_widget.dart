import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/masterlayout/app_header/app_header_widget.dart';
import '/masterlayout/navigation_menu/navigation_menu_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import '/masterlayout/time_tracking_widget/time_tracking_widget_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'master_layout_model.dart';
export 'master_layout_model.dart';

/// Layoutkomponente
class MasterLayoutWidget extends StatefulWidget {
  const MasterLayoutWidget({
    super.key,
    required this.statusBarBuilder,
    required this.actionBarBuilder,
    required this.mainContentBuilder,
    required this.sidebarContentBuilder,
    required this.timerObjectName,
    required this.timerObjectId,
  });

  final Widget Function()? statusBarBuilder;
  final Widget Function()? actionBarBuilder;
  final Widget Function()? mainContentBuilder;
  final Widget Function()? sidebarContentBuilder;
  final String? timerObjectName;
  final String? timerObjectId;

  @override
  State<MasterLayoutWidget> createState() => _MasterLayoutWidgetState();
}

class _MasterLayoutWidgetState extends State<MasterLayoutWidget> {
  late MasterLayoutModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MasterLayoutModel());

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
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: double.infinity,
          height: 120.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: wrapWithModel(
            model: _model.appHeaderModel,
            updateCallback: () => safeSetState(() {}),
            child: AppHeaderWidget(),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 240.0,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                child: wrapWithModel(
                  model: _model.navigationMenuModel,
                  updateCallback: () => safeSetState(() {}),
                  child: NavigationMenuWidget(),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Builder(builder: (_) {
                          return widget.statusBarBuilder != null
                              ? widget.statusBarBuilder!()
                              : SizedBox.shrink();
                        }),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Builder(builder: (_) {
                          return widget.actionBarBuilder != null
                              ? widget.actionBarBuilder!()
                              : SizedBox.shrink();
                        }),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            shape: BoxShape.rectangle,
                          ),
                          child: Builder(builder: (_) {
                            return widget.mainContentBuilder != null
                                ? widget.mainContentBuilder!()
                                : SizedBox.shrink();
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 320.0,
                    height: 110.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).customColor1,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(1.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).customColor1,
                        width: 1.0,
                      ),
                    ),
                    child: wrapWithModel(
                      model: _model.timeTrackingWidgetModel,
                      updateCallback: () => safeSetState(() {}),
                      child: TimeTrackingWidgetWidget(),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      width: 320.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(1.0),
                          bottomRight: Radius.circular(0.0),
                          topLeft: Radius.circular(0.0),
                          topRight: Radius.circular(0.0),
                        ),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).customColor1,
                          width: 1.0,
                        ),
                      ),
                      child: wrapWithModel(
                        model: _model.sidebarTabsModel,
                        updateCallback: () => safeSetState(() {}),
                        child: SidebarTabsWidget(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
