import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/playground/list_table_test_widget/list_table_test_widget_widget.dart';
import 'dart:ui';
import 'template_main_tabs_widget.dart' show TemplateMainTabsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TemplateMainTabsModel extends FlutterFlowModel<TemplateMainTabsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for ListTableTestWidget component.
  late ListTableTestWidgetModel listTableTestWidgetModel;

  @override
  void initState(BuildContext context) {
    listTableTestWidgetModel =
        createModel(context, () => ListTableTestWidgetModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    listTableTestWidgetModel.dispose();
  }
}
