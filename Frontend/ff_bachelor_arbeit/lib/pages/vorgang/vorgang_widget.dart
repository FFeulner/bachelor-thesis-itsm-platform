import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/masterlayout/master_layout/master_layout_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import '/vorgang/vorgang_action_bar/vorgang_action_bar_widget.dart';
import '/vorgang/vorgang_main_tabs/vorgang_main_tabs_widget.dart';
import '/vorgang/vorgang_status_bar/vorgang_status_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'vorgang_model.dart';
export 'vorgang_model.dart';

class VorgangWidget extends StatefulWidget {
  const VorgangWidget({
    super.key,
    this.vorgangStatus,
  });

  final String? vorgangStatus;

  static String routeName = 'Vorgang';
  static String routePath = '/Vorgang';

  @override
  State<VorgangWidget> createState() => _VorgangWidgetState();
}

class _VorgangWidgetState extends State<VorgangWidget> {
  late VorgangModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VorgangModel());

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
            updateOnChange: true,
            child: MasterLayoutWidget(
              timerObjectName: '',
              timerObjectId: '',
              statusBarBuilder: () => VorgangStatusBarWidget(),
              actionBarBuilder: () => VorgangActionBarWidget(),
              mainContentBuilder: () => VorgangMainTabsWidget(),
              sidebarContentBuilder: () => SidebarTabsWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
