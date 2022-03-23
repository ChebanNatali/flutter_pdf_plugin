import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdf_plugin/pdf_viewer_plugin.dart';

class PdfScaffold extends StatefulWidget {
  final String path;
  final double? topPadding;
  final double? height;
  final double? width;
  final bool? swipeHorizontal;


  const PdfScaffold({
    Key? key,
    required this.path,
   this.topPadding,
    required this.height,
    required this.width,
    this.swipeHorizontal=false,
  }) : super(key: key);

  @override
  _PDFViewScaffoldState createState() => new _PDFViewScaffoldState();
}

class _PDFViewScaffoldState extends State<PdfScaffold> {
  final pdfViewerRef = new PDFViewerPlugin();
  Rect ?_rect;
  Timer ?_resizeTimer;

  @override
  void initState() {
    super.initState();
    pdfViewerRef.close();
  }

  @override
  void dispose() {
    super.dispose();
    pdfViewerRef.close();
    pdfViewerRef.dispose();
  }

  void launchOrResizePDFRect() {
    if (_rect == null) {
      _rect = _buildRect(context);
      pdfViewerRef.launch(
        widget.path,
        rect: _rect,
        swipeHorizontal: widget.swipeHorizontal,
      );
    } else {
      final rect = _buildRect(context);
      if (_rect != rect) {
        _rect = rect;
        _resizeTimer?.cancel();
        _resizeTimer = new Timer(new Duration(milliseconds: 300), () {
          pdfViewerRef.resize(_rect!);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
  launchOrResizePDFRect();

    return new Container(
        child: const SizedBox(width: 1,height: 1,)
    );
  }

  Rect _buildRect(BuildContext context) {
    final topPadding = widget.topPadding != null ? widget.topPadding : 0.0;
    final top =topPadding;
    var height = widget.height!;// - top!;
    if (height < 0.0) {
      height = 0.0;
    }
    return new Rect.fromLTWH(0.0, top!, widget.width!, height);
  }
}
