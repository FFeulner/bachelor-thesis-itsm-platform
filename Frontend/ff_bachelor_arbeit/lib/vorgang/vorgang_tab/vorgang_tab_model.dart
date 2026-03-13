import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'vorgang_tab_widget.dart' show VorgangTabWidget;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VorgangTabModel extends FlutterFlowModel<VorgangTabWidget> {
  ///  Local state fields for this component.

  String? notiz;

  List<String> weitereKundenMitarbeiter = [];
  void addToWeitereKundenMitarbeiter(String item) =>
      weitereKundenMitarbeiter.add(item);
  void removeFromWeitereKundenMitarbeiter(String item) =>
      weitereKundenMitarbeiter.remove(item);
  void removeAtIndexFromWeitereKundenMitarbeiter(int index) =>
      weitereKundenMitarbeiter.removeAt(index);
  void insertAtIndexInWeitereKundenMitarbeiter(int index, String item) =>
      weitereKundenMitarbeiter.insert(index, item);
  void updateWeitereKundenMitarbeiterAtIndex(
          int index, Function(String) updateFn) =>
      weitereKundenMitarbeiter[index] =
          updateFn(weitereKundenMitarbeiter[index]);

  String? betreff;

  String? loesung;

  String? loesungBestaetigtDurch;

  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Backend Call - API (ReadOneVorgangGet)] action in VorgangTab widget.
  ApiCallResponse? vorgangRead83131dq;
  // Stores action output result for [Backend Call - API (ReadOneKundenMitarbeiterGet)] action in VorgangTab widget.
  ApiCallResponse? kundenMitarbeiterGet;
  // Stores action output result for [Backend Call - API (UpdateItemVorgangPut)] action in VorgangTab widget.
  ApiCallResponse? addasdadUpdate;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in VorgangTab widget.
  ApiCallResponse? apiResultlrh;
  // State field(s) for BetreffTextField widget.
  FocusNode? betreffTextFieldFocusNode;
  TextEditingController? betreffTextFieldTextController;
  String? Function(BuildContext, String?)?
      betreffTextFieldTextControllerValidator;
  // State field(s) for Checkbox widget.
  bool? checkboxValue;
  // State field(s) for BetroffenePersonDropDown widget.
  String? betroffenePersonDropDownValue;
  FormFieldController<String>? betroffenePersonDropDownValueController;
  // State field(s) for WeiterPersonenDropDown widget.
  List<String>? weiterPersonenDropDownValue;
  FormFieldController<List<String>>? weiterPersonenDropDownValueController;
  // State field(s) for KategorieDropDown widget.
  String? kategorieDropDownValue;
  FormFieldController<String>? kategorieDropDownValueController;
  // State field(s) for PrioDropDown widget.
  String? prioDropDownValue;
  FormFieldController<String>? prioDropDownValueController;
  // State field(s) for BeschreibungextField widget.
  FocusNode? beschreibungextFieldFocusNode;
  TextEditingController? beschreibungextFieldTextController;
  String? Function(BuildContext, String?)?
      beschreibungextFieldTextControllerValidator;
  // State field(s) for NotizenTextField widget.
  FocusNode? notizenTextFieldFocusNode;
  TextEditingController? notizenTextFieldTextController;
  String? Function(BuildContext, String?)?
      notizenTextFieldTextControllerValidator;
  // State field(s) for LoesungTextField widget.
  FocusNode? loesungTextFieldFocusNode;
  TextEditingController? loesungTextFieldTextController;
  String? Function(BuildContext, String?)?
      loesungTextFieldTextControllerValidator;
  // State field(s) for LoesungBestetigtDropDown widget.
  String? loesungBestetigtDropDownValue;
  FormFieldController<String>? loesungBestetigtDropDownValueController;
  // State field(s) for KeineBesttigungCheckbox widget.
  bool? keineBesttigungCheckboxValue;
  // Stores action output result for [Backend Call - API (CreateItemVorgangPost)] action in Button widget.
  ApiCallResponse? apiResult2tc;
  // Stores action output result for [Backend Call - API (CreateItemAktivitaeten)] action in Button widget.
  ApiCallResponse? apiResultlrhadsda;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    betreffTextFieldFocusNode?.dispose();
    betreffTextFieldTextController?.dispose();

    beschreibungextFieldFocusNode?.dispose();
    beschreibungextFieldTextController?.dispose();

    notizenTextFieldFocusNode?.dispose();
    notizenTextFieldTextController?.dispose();

    loesungTextFieldFocusNode?.dispose();
    loesungTextFieldTextController?.dispose();
  }

  /// Action blocks.
  Future putAenderung(BuildContext context) async {}
}
