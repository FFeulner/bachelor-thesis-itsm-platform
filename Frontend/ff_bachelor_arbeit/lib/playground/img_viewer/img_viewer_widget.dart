import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'img_viewer_model.dart';
export 'img_viewer_model.dart';

class ImgViewerWidget extends StatefulWidget {
  const ImgViewerWidget({
    super.key,
    required this.path,
  });

  final String? path;

  @override
  State<ImgViewerWidget> createState() => _ImgViewerWidgetState();
}

class _ImgViewerWidgetState extends State<ImgViewerWidget> {
  late ImgViewerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ImgViewerModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        functions.stringToImageFile(widget!.path)!,
        width: 200.0,
        height: 200.0,
        fit: BoxFit.contain,
      ),
    );
  }
}
