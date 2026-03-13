import '/cockpits/kunden_cockpit_main_tabs/kunden_cockpit_main_tabs_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/layout_templates/template_action_bar/template_action_bar_widget.dart';
import '/layout_templates/template_status_bar/template_status_bar_widget.dart';
import '/masterlayout/master_layout/master_layout_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import 'kunden_cockpit_widget.dart' show KundenCockpitWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class KundenCockpitModel extends FlutterFlowModel<KundenCockpitWidget> {
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
