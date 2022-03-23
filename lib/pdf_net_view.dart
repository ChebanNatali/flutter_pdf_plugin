import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_plugin/pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

class PdfNetScaffold extends StatelessWidget {
  final String pdfUrl;
  final double? topPadding;
  final double? height;
  final double? width;
  final bool? swipeHorizontal;

  PdfNetScaffold({Key? key, required this.pdfUrl, this.topPadding,
    required this.height,
    required this.width,
    this.swipeHorizontal=false,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    _loadingFuture = createFileOfPdfUrl();
    return FutureBuilder<File>(
      //绑定 Future
      future: _loadingFuture,
      //默认显示的占位数据
      initialData: null,
      //需要更新数据对应的Widget
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.data == null) {
          return  const Center(
              child: CircularProgressIndicator(),

          );
        }
        return PdfScaffold(
          path: snapshot.data!.path,
          topPadding:topPadding,
          height: height,
          width: width,
          swipeHorizontal: swipeHorizontal,
        );
      },
    );
  }

  Future<File>? _loadingFuture;

  //将PDF下载到本地
  Future<File> createFileOfPdfUrl() async {
    final url = pdfUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
