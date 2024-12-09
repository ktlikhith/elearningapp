
import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/providers/LP_provider.dart';
import 'package:elearning/providers/courseprovider.dart';
import 'package:elearning/providers/eventprovider.dart';
import 'package:elearning/providers/profile_provider.dart';
import 'package:elearning/routes/routes.dart';
import 'package:elearning/ui/My_learning/mylearning.dart';
import 'package:elearning/ui/My_learning/pdf_view_screen.dart';
import 'package:elearning/ui/Webview/tempviewfiles.dart';
import 'package:elearning/ui/download/downloadmanager.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Import for iOS features
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs
import 'dart:developer' as developer;

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final String token;
  final String? fileurl;

  const WebViewPage(this.title, this.url, this.token,[this.fileurl]);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  bool _isSSOLoaded = false;
  bool _isMainUrlLoaded = false;
       ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool isDialogOpen = false;

  @override
  void initState() {
    super.initState();
       initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
        // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,overlays: [SystemUiOverlay.top,]);
           SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initializeWebViewController();
    addFileSelectionListener();
  }
  @override
  void dispose() {
     _connectivitySubscription.cancel(); 
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: [SystemUiOverlay.top,SystemUiOverlay.bottom]);
    
    
_controller.loadRequest(Uri.parse('about:blank'));

 
    super.dispose();
  }
     
  // Initialize connectivity
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  // Update connectivity status
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    if (_connectionStatus == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      _dismissNoInternetDialog();
    }
  }

  // Show No Internet Dialog
  void _showNoInternetDialog() {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Opss No Internet Connection..'),
            content: const Text('Please check your connection. You can try reloading the page or explore the available offline content.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Reload'),
                onPressed: () 
                {  setState(() {
                     initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,overlays: [SystemUiOverlay.top,]);
    _initializeWebViewController();
    addFileSelectionListener();
                });},
                // onPressed: () async {
                //   final result = await _connectivity.checkConnectivity();
                //   _updateConnectionStatus(result);
                // },
              ),
              ElevatedButton(onPressed:(){  Navigator.of(context).pushNamed(RouterManger.downloads, arguments: widget.token);}, child:  const Text('Offline Content'),)
              
            ],
          );
        },
      );
    }
  }

  // Dismiss No Internet Dialog
  void _dismissNoInternetDialog() {
    if (isDialogOpen) {
 setState(() {
      initConnectivity();

      // Correct type for StreamSubscription<ConnectivityResult>
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack,overlays: [SystemUiOverlay.top,]);
    _initializeWebViewController();
    addFileSelectionListener();
 });
      Navigator.of(context, rootNavigator: true).pop();
      isDialogOpen = false;

    }
  }

  
  void addFileSelectionListener() async {
    if (Platform.isAndroid) {
      final androidController = _controller.platform as AndroidWebViewController;
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }
  Future<List<String>> _androidFilePicker(final FileSelectorParams params) async {
  final result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.path != null) {
    final file = File(result.files.single.path!);
    return [file.uri.toString()];
  }
  return [];
}



  void _initializeWebViewController() async {
     PlatformWebViewControllerCreationParams params =const PlatformWebViewControllerCreationParams();
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        
      );
    }  else if (WebViewPlatform.instance is AndroidWebViewPlatform) {
  params = AndroidWebViewControllerCreationParams
      .fromPlatformWebViewControllerCreationParams(
    params,

  );
}else {
      params =  PlatformWebViewControllerCreationParams();
    
      
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print("Page started loading: $url");
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
            if (!_isSSOLoaded || _isSSOUrl(url)) {
              setState(() {
                _isSSOLoaded = true;
              });
              if (!_isMainUrlLoaded && !_isSSOUrl(url)) {
                _loadMainUrl();
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            print("Web resource error: ${error.description}");
            if (error.errorType == WebResourceErrorType.unsupportedScheme) {
              print('google one unsupportedscheme ${error.url}');
              _handleUnknownUrlScheme(error.url);
            } 
          },
          
          onNavigationRequest: (NavigationRequest request) {
            print("Navigation request: ${request.url}");
            if (_isExternalUrl(request.url)) {
             _launchURL(request.url);
              return NavigationDecision.prevent;
            }
            if(_ispdfURL(request.url))
            {
              if(request.url.contains("webservice"))
              {
                String url=request.url+"?"+"token=${widget.token}";
                         Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) =>PDFViewScreen( url,token:  widget.token,istemp: true,),
  ),
);
                 return NavigationDecision.prevent;
              }else{
                String s1=request.url.split("pluginfile.php/")[0];
                 
                String s2=request.url.split("https://lxp-demo2.raptechsolutions.com/")[1];
                String url =s1+"webservice/"+s2+"?token=${widget.token}";
               
                
                          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) =>PDFViewScreen( url,token:  widget.token,istemp: true,),
  ),
);
                 
              }
  //             String url=request.url+"?forcedownload=1&"+"token=${widget.token}";

  //                           Navigator.push(
  // context,
  // MaterialPageRoute(
  //   builder: (context) =>PDFViewScreen(url,)));
              // final tmfv=new  tempfileviewManager();
              // tmfv.downloadFile(context, request.url, widget.token,);
//               Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) =>PdfViewerScreen(pdfUrl: request.url,token: widget.token,),
//   ),
// );
              
               return NavigationDecision.prevent;
                //  String getdwnloadUrlWithToken(String filePath1, String Token) {
                //                               return '$filePath1&token=$Token';
                //                             }
                // String? filename=getfilename(request.url);
                
              //   if(widget.fileurl!=null){
              //   String filename=widget.fileurl ?? "";
                
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (context) => PDFViewScreen(request.url),
              //                       ),
              //                     );
              //                        return NavigationDecision.prevent;
                
              //   }
              //  String getdwnloadUrlWithToken(String filePath1, String Token) {
              //                                 return '$filePath1&token=$Token';
              //                               }
              //   String? filename=getfilename(request.url);
              //   if(filename!=null){
              //  String url = getdwnloadUrlWithToken( request.url,widget.token);
              //  DownloadManager dm=new DownloadManager();
              //                               dm.downloadFile(
              //                                 context,
              //                                 url,
              //                                 filename,
              //                                 widget.token,
              //                                 "temp",
              //                                 "temp"
              //                               );
              //                               Navigator.of(context).pop();
              //   }
            }
            return NavigationDecision.navigate;
          },
        ),
      );
       

    // Load SSO after _controller is fully initialized
    await _loadSSO();
  }

  Future<void> _loadSSO() async {
    final ssoUrl =
        'https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}';
    print('Loading SSO URL: $ssoUrl');
    await _controller.loadRequest(Uri.parse(ssoUrl));
  }

  void _loadMainUrl() {
    print('Loading main URL: ${widget.url}');
    _controller.loadRequest(Uri.parse(widget.url));
    _isMainUrlLoaded = true;
  }

   _isSSOUrl(String url) {
    return url.contains('auth/token/index.php');
  }

  bool _isExternalUrl(String url) {
    // Add your logic to determine if the URL is an external link
    // For example, checking if it is a Google Meet link or a certificate link
    return url.contains('googlemeet') || url.contains('mod/customcert/view.php')||url.contains('downloadown=1')||url.contains('customcert');
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
   bool _ispdfURL(url){
    return url.contains('.pdf');

  }
  String? getfilename(url){
    
  // Split the URI at the '#Intent;' part
  final String filenameString = url.split('content/')[1];
  // Split the intent parameters by ';'
  final List<String> intentParams = filenameString.split('/');
  // Loop through the parameters to find the 'url' parameter
  for (String param in intentParams) {
    if (param.endsWith('.pdf')) {
      // Return the value after 'url='
      print('param');
      return param;
    }
  }
  return null;

  }

  void _handleUnknownUrlScheme(String? url) {
    if (url != null) {
      Uri uri = Uri.parse(url);
      if (uri.scheme == 'intent') {
        // Extract the actual URL from the intent URL
        final String? webUrl = _extractWebUrlFromIntent(url);
        print('web url extracted{$webUrl}');
        if (webUrl != null) {
          print("weburl launched");
          _isMainUrlLoaded = false;
          _launchURL(webUrl);
          _loadMainUrl();
        }
      } else {
        print("url launched");
        _launchURL(url);
      }
    }
  }
String? _extractWebUrlFromIntent(String intentUrl) {
  final Uri uri = Uri.parse(intentUrl);
  // Split the URI at the '#Intent;' part
  final String intentParamsString = intentUrl.split('&apn')[0];
  // Split the intent parameters by ';'
  final List<String> intentParams = intentParamsString.split('?link=');
  // Loop through the parameters to find the 'url' parameter
  for (String param in intentParams) {
    if (param.startsWith('https://meet.google.com')) {
      // Return the value after 'url='
      return param;
    }
  }
  return null;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),backgroundColor: Theme.of(context).primaryColor,
       leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),),
      
      body: WebViewWidget(controller: _controller),
    );
  }
}
