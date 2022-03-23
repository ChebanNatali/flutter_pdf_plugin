import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdf_plugin/pdf_viewer_scaffold.dart';
import 'package:flutter_pdf_plugin/pdf_net_view.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    title: 'Plugin example app',
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String pathPDF = "";
  final url = "https://norilsktgaz-mobile-app.ru/storage/2022/01/30/f48920783d3f7de322f9e0da5a17664444ee7d66.pdf";
  @override
  void initState() {
    super.initState();
   /* createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });*/
  }

  Future<File> createFileOfPdfUrl() async {

    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Plugin example app')),
      body: Center(
        child:PdfNetScaffold(
            pdfUrl: url,
            topPadding:100,
            height: mediaQuery.size.height-150,
            width: mediaQuery.size.width,
            swipeHorizontal:true
        )
       /* pathPDF.length>0?
        PdfScaffold(
          path: pathPDF,
          topPadding:100,
          height: mediaQuery.size.height-150,
          width: mediaQuery.size.width,
            swipeHorizontal:true
        ):
    const CircularProgressIndicator()*/
      ),
    );
  }
}

