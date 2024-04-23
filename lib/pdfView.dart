// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PDFView extends StatefulWidget {
//   final String pdfUrl;
//   const PDFView({super.key, required this.pdfUrl, });

//   @override
//   State<PDFView> createState() => _PDFViewState();
// }

// class _PDFViewState extends State<PDFView> {

//    final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
 
//   // String pdfUrl = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SfPdfViewer.network(widget.pdfUrl,
//         key: _pdfViewerKey,
//       ),);
//   }

// }