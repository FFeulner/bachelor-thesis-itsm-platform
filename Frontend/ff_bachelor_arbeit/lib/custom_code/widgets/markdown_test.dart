// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:file_picker/file_picker.dart';

class MarkdownTest extends StatefulWidget {
  final double? width;
  final double? height;

  final String? initialText;
  final bool? autofocus;
  final double? minHeight;
  final double? fontSize;
  final String? hintText;

  final String? uploadUrl;
  final String? authBearer;
  final String? uploadFieldName;
  final double? maxFileSizeMb;
  final String? baseImageUrl;

  final String? accessToken;
  final String? idToken;
  final String? recId;
  final String? uploadFolderFieldName;

  final bool mirrorToAppState;
  final int idlePreviewMs;

  const MarkdownTest({
    Key? key,
    this.width,
    this.height,
    this.initialText,
    this.autofocus,
    this.minHeight,
    this.fontSize,
    this.hintText,
    this.uploadUrl,
    this.authBearer,
    this.uploadFieldName,
    this.maxFileSizeMb,
    this.baseImageUrl,
    this.accessToken,
    this.idToken,
    this.recId,
    this.uploadFolderFieldName,
    this.mirrorToAppState = true,
    this.idlePreviewMs = 600,
  }) : super(key: key);

  @override
  State<MarkdownTest> createState() => _MarkdownTestState();
}

class _AttachmentDraft {
  final String filename;
  final String mime;
  final Uint8List bytes;
  final int size;

  String? _cachedDataUri;

  _AttachmentDraft({
    required this.filename,
    required this.mime,
    required this.bytes,
    required this.size,
  });

  String toDataUri() {
    return _cachedDataUri ??= () {
      final b64 = base64Encode(bytes);
      final safeName = filename.replaceAll(';', '_');
      return 'data:$mime;name=$safeName;base64,$b64';
    }();
  }

  static _AttachmentDraft? fromDataUri(String s) {
    try {
      if (!s.startsWith('data:')) return null;
      final parts = s.split(',');
      if (parts.length != 2) return null;
      final meta = parts[0];
      final b64 = parts[1];

      final mimeMatch = RegExp(r'^data:([^;]+)').firstMatch(meta);
      final nameMatch = RegExp(r'name=([^;]+)').firstMatch(meta);

      final mime = mimeMatch?.group(1) ?? 'application/octet-stream';
      final filename = nameMatch?.group(1) ?? 'attachment';
      final bytes = base64Decode(b64);
      return _AttachmentDraft(
        filename: filename,
        mime: mime,
        bytes: bytes,
        size: bytes.lengthInBytes,
      ).._cachedDataUri = s;
    } catch (_) {
      return null;
    }
  }
}

class _MarkdownTestState extends State<MarkdownTest>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _c;
  final FocusNode _kbdFocus = FocusNode();
  final FocusNode _editorFocus = FocusNode();

  Timer? _debounce;
  Timer? _idleTimer;

  bool _editing = true;

  bool _suppressBlurOnce = false;

  bool _dirty = false;
  String _lastCommittedText = '';

  final List<_AttachmentDraft> _attachments = [];

  late final RegExp _reImgMd;
  late final RegExp _reImgHtml;

  List<String> _extractImageUrls(String md) {
    final seen = <String>{};
    final urls = <String>[];

    for (final m in _reImgMd.allMatches(md)) {
      final u = m.group(1)!;
      if (seen.add(u)) urls.add(u);
    }
    for (final m in _reImgHtml.allMatches(md)) {
      final u = m.group(1)!;
      if (seen.add(u)) urls.add(u);
    }
    return urls;
  }

  void _markDirty() => _dirty = true;

  void _commitToAppState(String text) {
    if (!widget.mirrorToAppState) return;
    if (text == _lastCommittedText) return;

    final mightHaveImages = text.contains('![') || text.contains('<img');
    final urls = mightHaveImages ? _extractImageUrls(text) : <String>[];

    FFAppState().update(() {
      FFAppState().emailBodyMd = text;
      FFAppState().imageUrls = urls;
    });

    _lastCommittedText = text;
  }

  void _commitIfDirty() {
    if (!_dirty) return;
    _dirty = false;
    _commitToAppState(_c.text);
  }

  void _syncAttachmentsToAppState() {
    if (!widget.mirrorToAppState) return;
    final dataUris = _attachments.map((a) => a.toDataUri()).toList();
    FFAppState().update(() {
      FFAppState().emailAttachments = dataUris;
      FFAppState().lastUploadedImageUrl =
          dataUris.isNotEmpty ? dataUris.last : '';
    });
  }

  void _schedulePreview() {
    _idleTimer?.cancel();
    if (!mounted) return;

    final delay = widget.idlePreviewMs;
    if (delay <= 0) {
      if (!_editorFocus.hasFocus) {
        _commitIfDirty();
        setState(() => _editing = false);
      }
      return;
    }

    _idleTimer = Timer(Duration(milliseconds: delay), () {
      if (!_editorFocus.hasFocus) {
        _commitIfDirty();
        if (mounted) setState(() => _editing = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _reImgMd = RegExp(r'!\[[^\]]*\]\(([^)\s]+)(?:\s+"[^"]*")?\)');
    _reImgHtml = RegExp(
      r'''<img[^>]*\ssrc=["']([^"']+)["'][^>]*>''',
      caseSensitive: false,
    );

    final start = (FFAppState().emailBodyMd.isNotEmpty)
        ? FFAppState().emailBodyMd
        : (widget.initialText ?? '');
    _c = TextEditingController(text: start);
    _c.addListener(_onTextChanged);

    _editing = widget.autofocus ?? true;

    final existing = FFAppState().emailAttachments;
    for (final s in existing) {
      final d = _AttachmentDraft.fromDataUri(s);
      if (d != null) _attachments.add(d);
    }

    _editorFocus.addListener(() {
      if (!_editorFocus.hasFocus) {
        if (_suppressBlurOnce) return;

        _commitIfDirty();
        if (mounted) setState(() => _editing = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _markDirty();
      _commitIfDirty();
      _syncAttachmentsToAppState();

      if (!_editing) _schedulePreview();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _idleTimer?.cancel();
    _c.dispose();
    _kbdFocus.dispose();
    _editorFocus.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _markDirty();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (!_editing && mounted) setState(() => _editing = true);
      _schedulePreview();
    });
  }

  TextSelection get _sel => _c.selection;

  void _focusEditor({bool toEnd = false}) {
    FocusScope.of(context).requestFocus(_editorFocus);
    if (toEnd) {
      final len = _c.text.length;
      _c.selection = TextSelection.collapsed(offset: len);
    }
  }

  void _runFromToolbar(FutureOr<void> Function() fn) {
    _suppressBlurOnce = true;
    scheduleMicrotask(() => _suppressBlurOnce = false);

    final res = fn();
    if (res is Future) {
      res.whenComplete(_focusEditor);
    } else {
      _focusEditor();
    }
  }

  void _ensureEditing() {
    if (!_editing) setState(() => _editing = true);
    _focusEditor();
    _schedulePreview();
  }

  void _applyInline(String left, [String? right]) {
    final text = _c.text;
    final sel = _sel;
    _ensureEditing();

    final start = sel.start < 0 ? text.length : sel.start;
    final end = sel.end < 0 ? text.length : sel.end;
    final selected = text.substring(start, end);
    final r = right ?? left;

    final newText = text.replaceRange(start, end, '$left$selected$r');
    final newPos = start + left.length + selected.length + r.length;

    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newPos),
    );

    _markDirty();
    _commitIfDirty();
  }

  List<int> _lineRange() {
    final t = _c.text;
    int s = _sel.start < 0 ? t.length : _sel.start;
    int e = _sel.end < 0 ? t.length : _sel.end;
    s = t.lastIndexOf('\n', s - 1) + 1;
    final nextNl = t.indexOf('\n', e);
    e = nextNl == -1 ? t.length : nextNl;
    return <int>[s, e];
  }

  void _prefixLines(String prefix) {
    _ensureEditing();
    final t = _c.text;
    final r = _lineRange();
    final s = r[0], e = r[1];
    final block = t.substring(s, e);
    final lines = block.split('\n').map((l) => '$prefix$l').join('\n');
    final newText = t.replaceRange(s, e, lines);
    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: s + lines.length),
    );

    _markDirty();
    _commitIfDirty();
  }

  void _toggleHeading(int level) {
    final text = _c.text;
    final sel = _c.selection;
    _ensureEditing();

    final rawStart = sel.start < 0 ? text.length : sel.start;
    final rawEnd = sel.end < 0 ? text.length : sel.end;

    int start = text.lastIndexOf('\n', rawStart - 1) + 1;
    int end = text.indexOf('\n', rawEnd);
    if (end == -1) end = text.length;

    final block = text.substring(start, end);
    final lines = block.split('\n');

    final prefix = '${'#' * level} ';

    bool hasAllPrefixed = true;
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      if (!line.startsWith(prefix)) {
        hasAllPrefixed = false;
        break;
      }
    }

    final newLines = <String>[];
    for (final line in lines) {
      if (line.trim().isEmpty) {
        newLines.add(line);
        continue;
      }

      final noHeading = line.replaceFirst(RegExp(r'^\s{0,3}#{1,6}\s+'), '');

      if (hasAllPrefixed) {
        newLines.add(noHeading);
      } else {
        newLines.add('$prefix${noHeading.trimLeft()}');
      }
    }

    final replaced = newLines.join('\n');
    final newText = text.replaceRange(start, end, replaced);

    final delta = replaced.length - block.length;
    final newSelStart = start;
    final newSelEnd = (end + delta).clamp(0, newText.length);

    _c.value = TextEditingValue(
      text: newText,
      selection:
          TextSelection(baseOffset: newSelStart, extentOffset: newSelEnd),
    );

    _markDirty();
    _commitIfDirty();
  }

  void _insertCodeBlock() {
    _ensureEditing();
    final t = _c.text;
    final sel = _sel;
    final start = sel.start < 0 ? t.length : sel.start;
    final end = sel.end < 0 ? t.length : sel.end;
    final selected = t.substring(start, end);
    final block = selected.isEmpty ? 'code...' : selected;
    final insert = '```\n$block\n```\n';
    final newText = t.replaceRange(start, end, insert);
    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + insert.length),
    );

    _markDirty();
    _commitIfDirty();
  }

  void _quoteLines() => _prefixLines('> ');
  void _listBullets() => _prefixLines('- ');

  void _listOrdered() {
    _ensureEditing();
    final t = _c.text;
    final r = _lineRange();
    final s = r[0], e = r[1];
    final block = t.substring(s, e);
    int i = 1;
    final lines = block.split('\n').map((l) => '${i++}. $l').join('\n');
    final newText = t.replaceRange(s, e, lines);
    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: s + lines.length),
    );

    _markDirty();
    _commitIfDirty();
  }

  Future<void> _insertLink() async {
    _ensureEditing();
    final sel = _sel;
    final hasSelection = sel.isValid && !sel.isCollapsed;
    final current =
        hasSelection ? _c.text.substring(sel.start, sel.end) : 'Linktext';
    final url = await _ask('Link einfügen', 'https://');
    if (url == null || url.isEmpty) return;

    final insert = '[$current]($url)';
    final t = _c.text;
    final start = sel.start < 0 ? t.length : sel.start;
    final end = sel.end < 0 ? t.length : sel.end;
    final newText = t.replaceRange(start, end, insert);
    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + insert.length),
    );

    _markDirty();
    _commitIfDirty();
  }

  void _insertHr() {
    _ensureEditing();
    final t = _c.text;
    final pos = _sel.start < 0 ? t.length : _sel.start;
    const hr = '\n\n---\n\n';
    final newText = t.replaceRange(pos, pos, hr);
    _c.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: pos + hr.length),
    );

    _markDirty();
    _commitIfDirty();
  }

  Future<String?> _ask(String title, String initial) async {
    final tc = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: tc, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, tc.text.trim()),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAttachmentImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        withData: true,
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const ['png', 'jpg', 'jpeg', 'gif', 'webp', 'svg'],
      );
      if (result == null || result.files.isEmpty) return;

      final maxMb = (widget.maxFileSizeMb ?? 10);

      for (final f in result.files) {
        final bytes = f.bytes;
        if (bytes == null) continue;

        if (bytes.lengthInBytes > maxMb * 1024 * 1024) {
          _toast('Datei ${f.name} zu groß (> ${maxMb.toStringAsFixed(0)} MB).');
          continue;
        }

        final ext = (f.extension ?? '').toLowerCase();
        final mime = _guessMime(ext);

        _attachments.add(_AttachmentDraft(
          filename: f.name,
          mime: mime,
          bytes: bytes,
          size: bytes.lengthInBytes,
        ));
      }

      _syncAttachmentsToAppState();
      _toast('Anhänge hinzugefügt.');
      setState(() {});
    } catch (e) {
      _toast('Anhänge auswählen fehlgeschlagen: $e');
    }
  }

  String _guessMime(String ext) {
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      default:
        return 'application/octet-stream';
    }
  }

  void _removeAttachmentAt(int i) {
    if (i < 0 || i >= _attachments.length) return;
    _attachments.removeAt(i);
    _syncAttachmentsToAppState();
    setState(() {});
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final minH = widget.minHeight ?? 320.0;
    final fs = widget.fontSize ?? 14.0;

    final editor = RepaintBoundary(child: _buildEditor(fs));
    final preview = RepaintBoundary(child: _buildPreview(fs));

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Container(
        constraints: BoxConstraints(minHeight: minH),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            _buildAttachmentsBar(),
            _buildToolbar(),
            Expanded(
              child: AnimatedCrossFade(
                crossFadeState: _editing
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 160),
                firstChild: editor,
                secondChild: preview,
                layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                  return Stack(
                    children: <Widget>[
                      Positioned.fill(key: bottomKey, child: bottomChild),
                      Positioned.fill(key: topKey, child: topChild),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return FocusScope(
      canRequestFocus: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          IconButton(
            icon: const Icon(Icons.title),
            tooltip: 'H1',
            onPressed: () => _runFromToolbar(() => _toggleHeading(1)),
          ),
          IconButton(
            icon: const Icon(Icons.title_outlined),
            tooltip: 'H2',
            onPressed: () => _runFromToolbar(() => _toggleHeading(2)),
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            tooltip: 'H3',
            onPressed: () => _runFromToolbar(() => _toggleHeading(3)),
          ),
          const VerticalDivider(width: 8),
          IconButton(
            icon: const Icon(Icons.format_bold),
            tooltip: 'Bold',
            onPressed: () => _runFromToolbar(() => _applyInline('**')),
          ),
          IconButton(
            icon: const Icon(Icons.format_italic),
            tooltip: 'Italic',
            onPressed: () => _runFromToolbar(() => _applyInline('_')),
          ),
          IconButton(
            icon: const Icon(Icons.strikethrough_s),
            tooltip: 'Strike',
            onPressed: () => _runFromToolbar(() => _applyInline('~~')),
          ),
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Link',
            onPressed: () => _runFromToolbar(_insertLink),
          ),
          const VerticalDivider(width: 8),
          IconButton(
            icon: const Icon(Icons.format_list_bulleted),
            tooltip: 'Liste',
            onPressed: () => _runFromToolbar(() => _listBullets()),
          ),
          IconButton(
            icon: const Icon(Icons.format_list_numbered),
            tooltip: 'Nummeriert',
            onPressed: () => _runFromToolbar(() => _listOrdered()),
          ),
          IconButton(
            icon: const Icon(Icons.format_quote),
            tooltip: 'Zitat',
            onPressed: () => _runFromToolbar(() => _quoteLines()),
          ),
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Inline Code',
            onPressed: () => _runFromToolbar(() => _applyInline('`')),
          ),
          IconButton(
            icon: const Icon(Icons.data_object),
            tooltip: 'Codeblock',
            onPressed: () => _runFromToolbar(() => _insertCodeBlock()),
          ),
          const VerticalDivider(width: 8),
          IconButton(
            icon: const Icon(Icons.attach_file),
            tooltip: 'Bilder als Anhang hinzufügen',
            onPressed: () => _runFromToolbar(() => _pickAttachmentImages()),
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Trenner',
            onPressed: () => _runFromToolbar(() => _insertHr()),
          ),
        ]),
      ),
    );
  }

  Widget _buildEditor(double fs) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: RawKeyboardListener(
        focusNode: _kbdFocus,
        onKey: (_) {},
        child: TextField(
          controller: _c,
          focusNode: _editorFocus,
          autofocus: widget.autofocus ?? false,
          minLines: 10,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          style: TextStyle(fontSize: fs, height: 1.4),
          decoration: InputDecoration(
            hintText: widget.hintText ?? 'Schreibe in Markdown …',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPreview(double fs) {
    return InkWell(
      onTap: () {
        setState(() => _editing = true);
        _focusEditor(toEnd: true);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.topLeft,
        child: Markdown(
          data: _c.text.isEmpty ? '_(leer)_' : _c.text,
          selectable: true,
          shrinkWrap: true,
          softLineBreak: true,
          styleSheet: MarkdownStyleSheet(
            h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            h3: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            p: TextStyle(fontSize: fs),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentsBar() {
    if (_attachments.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_attachments.length, (i) {
            final a = _attachments[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      a.bytes,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Theme.of(context).dividerColor,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported, size: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -8,
                    top: -8,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, size: 18),
                      onPressed: () => _removeAttachmentAt(i),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
