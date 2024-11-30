// // import 'package:flutter/material.dart';
// // import 'package:flutter_pdfview/flutter_pdfview.dart';

// // class PDFViewScreen extends StatefulWidget {
// //   final String filePath1;
// //   final String Token;

// //   PDFViewScreen(this.filePath1,this.Token);

// //   @override
// //   _PDFViewScreenState createState() => _PDFViewScreenState();
// // }

// // class _PDFViewScreenState extends State<PDFViewScreen> {
  
// //   String getPdfUrlWithToken(String filePath1, String Token) {
// //     print('$filePath1&token=$Token');
// //     return '$filePath1&token=$Token';
// //   }
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('PDF View'),
// //         backgroundColor: Theme.of(context).primaryColor,
// //         centerTitle: false,
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back, color: Colors.white),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //       ),
// //       body: PDFView(
// //         filePath: getPdfUrlWithToken(widget.filePath1, widget.Token),
// //         enableSwipe: true,
// //         swipeHorizontal: true,
// //         autoSpacing: false,
// //         pageFling: false,
// //         onRender: (pages) {
// //           print('Document rendered with $pages pages');
// //         },
// //         onError: (error) {
// //           print('Error loading PDF: $error');
// //         },
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';

// class PDFViewScreen extends StatefulWidget {
//   final String filePath;
  

//   PDFViewScreen(this.filePath,);

//   @override
//   _PDFViewScreenState createState() => _PDFViewScreenState();
// }

// class _PDFViewScreenState extends State<PDFViewScreen> {
  
//   String getPdfUrlWithToken(String filePath1, String Token) {
//     print('$filePath1&token=$Token');
//     return '$filePath1&token=$Token';
//   }
//   bool _isLoading = true;
//   String? _localFilePath;

//   @override
//   void initState() {
//     super.initState();
//     _loadPDF();
//   }

//   Future<void> _loadPDF() async {
//     try {
//       final url = widget.filePath;
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final bytes = response.bodyBytes;
//         final dir = await getApplicationDocumentsDirectory();
//         final file = File('${dir.path}/temp.pdf');
//         await file.writeAsBytes(bytes);

//         setState(() {
//           _localFilePath = file.path;
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load PDF');
//       }
//     } catch (e) {
//       print('Error loading PDF: $e');
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
  
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : _localFilePath != null
//               ? PDFView(
//                   filePath: _localFilePath,
//                 )
//               : Center(child: Text('Failed to load PDF')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PDFViewScreen extends StatefulWidget {
  final String filePath;
  final String? token;
  final bool? istemp;

  PDFViewScreen(this.filePath, {this.token,this.istemp});

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  bool _isLoading = true;
  String? _localFilePath;
  String? tempFilePath;

  @override
  void initState() {
    print(widget.filePath);
    super.initState();
    _loadPDF();
  }
  @override
  void dispose() {
    if (_localFilePath != null && widget.istemp==true) {
      File(_localFilePath!).deleteSync();
    }
    super.dispose();
  }
  Future<void> _loadPDF() async {
    try {
      if (_isLocalFile(widget.filePath)) {
        setState(() {
          _localFilePath = widget.filePath;
          _isLoading = false;
        });
      } else {
        final url = widget.token != null ? getPdfUrlWithToken(widget.filePath, widget.token!) : widget.filePath;
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final dir = await getApplicationDocumentsDirectory();
          final file = File('${dir.path}/temp.pdf');
          await file.writeAsBytes(bytes);

          setState(() {
            _localFilePath = file.path;
            tempFilePath=file.toString();
            _isLoading = false;
          });
        } else {
          throw Exception('Failed to load PDF');
        }
      }
    } catch (e) {
      print('Error loading PDF: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLocalFile(String path) {
    // Checks if the path is a local file path or a URL
    return !path.startsWith('http://') && !path.startsWith('https://');
  }

  String getPdfUrlWithToken(String filePath, String token) {
    return '$filePath&token=$token';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('PDF View'),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   centerTitle: false,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _localFilePath != null
              ? PDFView(
                  filePath: _localFilePath!,
                )
              : Center(child: Text('Failed to load PDF')),
    );
  }
}


