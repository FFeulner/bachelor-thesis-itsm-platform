import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/masterlayout/app_header/app_header_widget.dart';
import '/masterlayout/navigation_menu/navigation_menu_widget.dart';
import '/masterlayout/sidebar_tabs/sidebar_tabs_widget.dart';
import '/masterlayout/time_tracking_widget/time_tracking_widget_widget.dart';
import 'dart:ui';
import 'master_layout_widget.dart' show MasterLayoutWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MasterLayoutModel extends FlutterFlowModel<MasterLayoutWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for AppHeader component.
  late AppHeaderModel appHeaderModel;
  // Model for NavigationMenu component.
  late NavigationMenuModel navigationMenuModel;
  // Model for TimeTrackingWidget component.
  late TimeTrackingWidgetModel timeTrackingWidgetModel;
  // Model for SidebarTabs component.
  late SidebarTabsModel sidebarTabsModel;

  @override
  void initState(BuildContext context) {
    appHeaderModel = createModel(context, () => AppHeaderModel());
    navigationMenuModel = createModel(context, () => NavigationMenuModel());
    timeTrackingWidgetModel =
        createModel(context, () => TimeTrackingWidgetModel());
    sidebarTabsModel = createModel(context, () => SidebarTabsModel());
  }

  @override
  void dispose() {
    appHeaderModel.dispose();
    navigationMenuModel.dispose();
    timeTrackingWidgetModel.dispose();
    sidebarTabsModel.dispose();
  }
}
