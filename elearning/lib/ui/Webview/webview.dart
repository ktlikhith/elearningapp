// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;

//   WebViewPage(this.title, this.url);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   @override
//   void initState() {
//     super.initState();
//     if (WebView.platform == null) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }
 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
        
//         centerTitle: false,
        
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: WebView(
//         initialUrl: widget.url,
//         zoomEnabled: false,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebResourceError: (error) {
//           print('WebResourceError: $error');
//         },
//         onPageFinished: (String url) {
//           print('Page finished loading: $url');
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shimmer/shimmer.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;
//   final String token;

//   WebViewPage(this.title, this.url, this.token);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isSSOLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     if (WebView.platform == null) {
//       WebView.platform = SurfaceAndroidWebView();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String ssoUrl = "https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}";

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           WebView(
//             initialUrl: ssoUrl,
//             javascriptMode: JavascriptMode.unrestricted,
//             onWebViewCreated: (WebViewController webViewController) {
//               _controller = webViewController;
//             },
//             onPageFinished: (String url) async {
//               print(url);
//               if (!_isSSOLoaded && url.contains("https://lxp-demo2.raptechsolutions.com")) {
//                 // SSO URL loaded, now load the main content URL
//                 _isSSOLoaded = true;
//                 await _controller.loadUrl(widget.url);
//               } else if (_isSSOLoaded && url == widget.url) {
//                 // Main content URL loaded
//                 _controller.runJavascript(
//                   "document.querySelectorAll('iframe').forEach(function(iframe) { iframe.setAttribute('allow', 'fullscreen'); });"
//                 );
//                 setState(() {
//                   _isLoading = false;
//                   _hasError = false;
//                 });
//               }
//             },
//             onWebResourceError: (error) {
//               setState(() {
//                 _isLoading = false;
//                 _hasError = true;
//               });
//               print('WebResourceError: $error');
//             },
//           ),
//           if (_isLoading)
//             Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (_hasError)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, color: Colors.red, size: 64),
//                   SizedBox(height: 16),
//                   Text('Failed to load content', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _hasError = false;
//                       });
//                       _controller.loadUrl(ssoUrl);
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shimmer/shimmer.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;
//   final String token;

//   WebViewPage(this.title, this.url, this.token);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isSSOLoaded = false;

//   @override
//   void initState() {
//     super.initState();

//     final PlatformWebViewControllerCreationParams params = WebViewPlatform.instance is WebKitWebViewPlatform
//         ? WebKitWebViewControllerCreationParams(
//             allowsInlineMediaPlayback: true,
//             mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
//           )
//         : const PlatformWebViewControllerCreationParams();

//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             print('Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             print('Page finished loading: $url');
//             if (!_isSSOLoaded && url.contains("https://lxp-demo2.raptechsolutions.com")) {
//               _isSSOLoaded = true;
//               await _controller.loadRequest(Uri.parse(widget.url));
//             } else if (_isSSOLoaded && url == widget.url) {
//               await _controller.runJavaScript(
//                 "document.querySelectorAll('iframe').forEach(function(iframe) { iframe.setAttribute('allow', 'fullscreen'); });"
//               );
//               setState(() {
//                 _isLoading = false;
//                 _hasError = false;
//               });
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               _isLoading = false;
//               _hasError = true;
//             });
//             print('WebResourceError: $error');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (_hasError)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, color: Colors.red, size: 64),
//                   SizedBox(height: 16),
//                   Text('Failed to load content', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _hasError = false;
//                       });
//                       _controller.loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:webview_flutter_android/webview_flutter_android.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;
//   final String token;

//   WebViewPage(this.title, this.url, this.token);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isSSOLoaded = false;

//   @override
//   void initState() {
//     super.initState();

//     // Create platform-specific WebView controller parameters
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction:  const <PlaybackMediaTypes>{PlaybackMediaTypes.audio, PlaybackMediaTypes.video},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     // Instantiate the WebViewController with the platform-specific parameters
//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             print('Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             print('Page finished loading: $url');
//             if (!_isSSOLoaded && url.contains("https://lxp-demo2.raptechsolutions.com")) {
//               _isSSOLoaded = true;
//               await _controller.loadRequest(Uri.parse(widget.url));
//             } else if (_isSSOLoaded && url == widget.url) {
//               await _controller.runJavaScript(
//                 "document.querySelectorAll('iframe').forEach(function(iframe) { iframe.setAttribute('allow', 'fullscreen'); });"
//               );
//               setState(() {
//                 _isLoading = false;
//                 _hasError = false;
//               });
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               _isLoading = false;
//               _hasError = true;
//             });
//             print('WebResourceError: $error');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (_hasError)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, color: Colors.red, size: 64),
//                   SizedBox(height: 16),
//                   Text('Failed to load content', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _hasError = false;
//                       });
//                       _controller.loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;
//   final String token;

//   WebViewPage(this.title, this.url, this.token);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isSSOLoaded = false;

//   @override
//   void initState() {
//     super.initState();

//     // Create platform-specific WebView controller parameters
//     late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{PlaybackMediaTypes.audio, PlaybackMediaTypes.video},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     // Instantiate the WebViewController with the platform-specific parameters
//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             print('Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             print('Page finished loading: $url');
//             if (!_isSSOLoaded && url.contains("https://lxp-demo2.raptechsolutions.com")) {
//               _isSSOLoaded = true;
//               await _controller.loadRequest(Uri.parse(widget.url));
//             } else if (_isSSOLoaded && url == widget.url) {
//               await _controller.runJavaScript(
//                   "document.querySelectorAll('iframe').forEach(function(iframe) { iframe.setAttribute('allow', 'fullscreen'); });"
//               );
//               setState(() {
//                 _isLoading = false;
//                 _hasError = false;
//               });
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               _isLoading = false;
//               _hasError = true;
//             });
//             print('WebResourceError: $error');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           if (_hasError)
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.error, color: Colors.red, size: 64),
//                   SizedBox(height: 16),
//                   Text('Failed to load content', style: TextStyle(fontSize: 18)),
//                   SizedBox(height: 8),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _isLoading = true;
//                         _hasError = false;
//                       });
//                       _controller.loadRequest(Uri.parse(widget.url));
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// import 'package:shimmer/shimmer.dart';

// class WebViewPage extends StatefulWidget {
//   final String title;
//   final String url;
//   final String token;

//   WebViewPage(this.title, this.url, this.token);

//   @override
//   _WebViewPageState createState() => _WebViewPageState();
// }

// class _WebViewPageState extends State<WebViewPage> {
//   late WebViewController _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//   bool _isSSOLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//  late final PlatformWebViewControllerCreationParams params;
//     if (WebViewPlatform.instance is WebKitWebViewPlatform) {
//       params = WebKitWebViewControllerCreationParams(
//         allowsInlineMediaPlayback: true,
//         mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{PlaybackMediaTypes.audio, PlaybackMediaTypes.video},
//       );
//     } else {
//       params = const PlatformWebViewControllerCreationParams();
//     }

//     _controller = WebViewController.fromPlatformCreationParams(params)
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             print('Page started loading: $url');
//           },
//           onPageFinished: (String url) async {
//             print('Page finished loading: $url');
//             if (!_isSSOLoaded && url.contains("https://lxp-demo2.raptechsolutions.com")) {
//               _isSSOLoaded = true;
//               await _controller.loadRequest(Uri.parse(widget.url));
//             } else if (_isSSOLoaded && url == widget.url) {
//               await _controller.runJavaScript(
//                 "document.querySelectorAll('iframe').forEach(function(iframe) { iframe.setAttribute('allow', 'fullscreen'); });"
//               );
//               setState(() {
//                 _isLoading = false;
//                 _hasError = false;
//               });
//             }
//           },
//           onWebResourceError: (WebResourceError error) {
//             setState(() {
//               _isLoading = false;
//               _hasError = true;
//             });
//             print('WebResourceError: $error');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Theme.of(context).primaryColor,
//         centerTitle: false,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       backgroundColor: Theme.of(context).backgroundColor,
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             Center(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   width: double.infinity,
//                   height: double.infinity,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           // if (_hasError)
//           //   Center(
//           //     child: Column(
//           //       mainAxisAlignment: MainAxisAlignment.center,
//           //       children: [
//           //         Icon(Icons.error, color: Colors.red, size: 64),
//           //         SizedBox(height: 16),
//           //         Text('Failed to load content', style: TextStyle(fontSize: 18)),
//           //         SizedBox(height: 8),
//           //         ElevatedButton(
//           //           onPressed: () {
//           //             setState(() {
//           //               _isLoading = true;
//           //               _hasError = false;
//           //               _isSSOLoaded = false; // Reset SSO state
//           //             });
//           //             _controller.loadRequest(Uri.parse('https://lxp-demo2.raptechsolutions.com/auth/token/index.php?token=${widget.token}'));
//           //           },
//           //           child: Text('Retry SSO'),
//           //         ),
//           //       ],
//           //     ),
//             // ),
//         ],
//       ),
//     );
//   }
// }
