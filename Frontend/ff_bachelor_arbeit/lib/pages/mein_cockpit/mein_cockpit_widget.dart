import '/cockpits/mein_cockpit_main_tabs/mein_cockpit_main_tabs_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/layout_templates/template_action_bar/template_action_bar_widget.dart';
import '/layout_templates/template_status_bar/template_status_bar_widget.dart';
import '/masterlayout/master_layout/master_layout_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'mein_cockpit_model.dart';
export 'mein_cockpit_model.dart';

class MeinCockpitWidget extends StatefulWidget {
  const MeinCockpitWidget({super.key});

  static String routeName = 'MeinCockpit';
  static String routePath = '/meinCockpit';

  @override
  State<MeinCockpitWidget> createState() => _MeinCockpitWidgetState();
}

class _MeinCockpitWidgetState extends State<MeinCockpitWidget> {
  late MeinCockpitModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MeinCockpitModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: wrapWithModel(
            model: _model.masterLayoutModel,
            updateCallback: () => safeSetState(() {}),
            child: MasterLayoutWidget(
              timerObjectName: '',
              timerObjectId: '',
              statusBarBuilder: () => TemplateStatusBarWidget(),
              actionBarBuilder: () => TemplateActionBarWidget(),
              mainContentBuilder: () => MeinCockpitMainTabsWidget(),
              sidebarContentBuilder: () => SidebarTabsWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
