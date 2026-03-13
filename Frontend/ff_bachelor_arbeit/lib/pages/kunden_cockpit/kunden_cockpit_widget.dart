import '/cockpits/kunden_cockpit_main_tabs/kunden_cockpit_main_tabs_widget.dart';
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
import 'kunden_cockpit_model.dart';
export 'kunden_cockpit_model.dart';

class KundenCockpitWidget extends StatefulWidget {
  const KundenCockpitWidget({super.key});

  static String routeName = 'KundenCockpit';
  static String routePath = '/kundenCockpit';

  @override
  State<KundenCockpitWidget> createState() => _KundenCockpitWidgetState();
}

class _KundenCockpitWidgetState extends State<KundenCockpitWidget> {
  late KundenCockpitModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KundenCockpitModel());

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
              mainContentBuilder: () => KundenCockpitMainTabsWidget(),
              sidebarContentBuilder: () => SidebarTabsWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
