
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'; // Import for Android features
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // Import for iOS features
import 'package:url_launcher/url_launcher.dart'; // Import for launching URLs

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  final String token;

  const WebViewPage(this.title, this.url, this.token);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  bool _isSSOLoaded = false;
  bool _isMainUrlLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
  }

  void _initializeWebViewController() async {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
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

  bool _isSSOUrl(String url) {
    return url.contains('auth/token/index.php');
  }

  bool _isExternalUrl(String url) {
    // Add your logic to determine if the URL is an external link
    // For example, checking if it is a Google Meet link or a certificate link
    return url.contains('googlemeet') || url.contains('mod/customcert/view.php')||url.contains('downloadown=1');
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
      appBar: AppBar(title: Text(widget.title),backgroundColor: Colors.black,),
      body: WebViewWidget(controller: _controller),
    );
  }
}
