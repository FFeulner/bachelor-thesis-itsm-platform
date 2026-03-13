import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/masterlayout/master_layout/master_layout_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import '/vorgang/vorgang_action_bar/vorgang_action_bar_widget.dart';
import '/vorgang/vorgang_main_tabs/vorgang_main_tabs_widget.dart';
import '/vorgang/vorgang_status_bar/vorgang_status_bar_widget.dart';
import 'vorgang_widget.dart' show VorgangWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VorgangModel extends FlutterFlowModel<VorgangWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for MasterLayout component.
  late MasterLayoutModel masterLayoutModel;

  @override
  void initState(BuildContext context) {
    masterLayoutModel = createModel(context, () => MasterLayoutModel());
  }

  @override
  void dispose() {
    masterLayoutModel.dispose();
  }
}
