import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'time_tracking_widget_model.dart';
export 'time_tracking_widget_model.dart';

/// Zeiterfassung
class TimeTrackingWidgetWidget extends StatefulWidget {
  const TimeTrackingWidgetWidget({
    super.key,
    String? objectName,
    String? objectId,
  })  : this.objectName = objectName ?? '\"\"',
        this.objectId = objectId ?? '\"\"';

  final String objectName;
  final String objectId;

  @override
  State<TimeTrackingWidgetWidget> createState() =>
      _TimeTrackingWidgetWidgetState();
}

class _TimeTrackingWidgetWidgetState extends State<TimeTrackingWidgetWidget> {
  late TimeTrackingWidgetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TimeTrackingWidgetModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.timerUPController.timer.setPresetTime(
        mSec: valueOrDefault<int>(
          FFAppState().timerSafe,
          1000,
        ),
        add: false,
      );
      _model.timerUPController.onResetTimer();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    // On component dispose action.
    () async {
      FFAppState().timerSafe = _model.timerUPMilliseconds;
      FFAppState().timertest2 = _model.timerUPMilliseconds.toDouble();
      FFAppState().update(() {});
    }();

    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: 320.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Align(
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterFlowTimer(
              initialTime: _model.timerUPInitialTimeMs,
              getDisplayTime: (value) =>
                  StopWatchTimer.getDisplayTime(value, milliSecond: false),
              controller: _model.timerUPController,
              updateStateInterval: Duration(milliseconds: 1000),
              onChanged: (value, displayTime, shouldUpdate) {
                _model.timerUPMilliseconds = value;
                _model.timerUPValue = displayTime;
                if (shouldUpdate) safeSetState(() {});
              },
              onEnded: () async {
                FFAppState().timerSafe = _model.timerUPMilliseconds;
              },
              textAlign: TextAlign.start,
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.interTight(
                      fontWeight:
                          FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                    ),
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                  ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    _model.timerUPController.onStartTimer();
                  },
                  child: Icon(
                    Icons.not_started_outlined,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    _model.timerUPController.onStopTimer();
                  },
                  child: Icon(
                    Icons.pause,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    _model.timerUPController.onResetTimer();
                  },
                  child: Icon(
                    Icons.restart_alt,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
