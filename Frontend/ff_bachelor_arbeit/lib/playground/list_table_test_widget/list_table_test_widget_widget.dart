import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'list_table_test_widget_model.dart';
export 'list_table_test_widget_model.dart';

class ListTableTestWidgetWidget extends StatefulWidget {
  const ListTableTestWidgetWidget({super.key});

  @override
  State<ListTableTestWidgetWidget> createState() =>
      _ListTableTestWidgetWidgetState();
}

class _ListTableTestWidgetWidgetState extends State<ListTableTestWidgetWidget> {
  late ListTableTestWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListTableTestWidgetModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [],
      ),
    );
  }
}
