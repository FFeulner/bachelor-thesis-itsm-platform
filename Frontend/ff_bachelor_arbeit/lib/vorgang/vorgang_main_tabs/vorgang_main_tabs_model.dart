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
import 'vorgang_main_tabs_widget.dart' show VorgangMainTabsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VorgangMainTabsModel extends FlutterFlowModel<VorgangMainTabsWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for VorgangsListe component.
  late VorgangsListeModel vorgangsListeModel;
  // Model for VorgangTab component.
  late VorgangTabModel vorgangTabModel;
  // Model for CmdbListe component.
  late CmdbListeModel cmdbListeModel;
  // Model for KommunikationListe component.
  late KommunikationListeModel kommunikationListeModel;
  // Model for LeitsungsListe component.
  late LeitsungsListeModel leitsungsListeModel;

  @override
  void initState(BuildContext context) {
    vorgangsListeModel = createModel(context, () => VorgangsListeModel());
    vorgangTabModel = createModel(context, () => VorgangTabModel());
    cmdbListeModel = createModel(context, () => CmdbListeModel());
    kommunikationListeModel =
        createModel(context, () => KommunikationListeModel());
    leitsungsListeModel = createModel(context, () => LeitsungsListeModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    vorgangsListeModel.dispose();
    vorgangTabModel.dispose();
    cmdbListeModel.dispose();
    kommunikationListeModel.dispose();
    leitsungsListeModel.dispose();
  }
}
