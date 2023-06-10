import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grap_food/core/assets/app_assets.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

enum WebViewLoadState {
  SUCCESS,
  NO_INTETNET_CONNECTION,
  FAILED_TO_LOAD,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String? baseUrl = "https://grapfood.vercel.app";
  String? baseUrl = "https://gyftsi.com/";

  String _previousPage = "";

  String? _cureentPage;

  PullToRefreshController? pullToRefreshController;

  InAppWebViewController? _webViewController;

  WebViewLoadState? webViewLoadState = WebViewLoadState.SUCCESS;

  double? progress;

  @override
  void initState() {
    super.initState();

    _cureentPage = baseUrl;

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _webViewController!.reload();
        } else if (Platform.isIOS) {
          _webViewController!.loadUrl(
              urlRequest: URLRequest(url: await _webViewController!.getUrl()));
        }
      },
    );
    pullToRefreshController = pullToRefreshController;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          var url = await _webViewController!.getUrl();

          print("URL IS : ${url.toString()}");

          if (url.toString() != baseUrl) {
            print("Texxxxttt");
            //_webViewController?.goBack();
            _webViewController?.loadUrl(
                urlRequest: URLRequest(url: Uri.parse(baseUrl!)));

            return false;
          } else {
            exit(0);
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xffFFFFFF),
          body: SizedBox(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewPadding.top -
                10,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned.fill(child: _loadView()),
                Align(alignment: Alignment.center, child: _buildProgressBar()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadView() {
    switch (webViewLoadState) {
      case WebViewLoadState.SUCCESS:
        // TODO: Handle this case.

        return _webView();

        break;
      case WebViewLoadState.NO_INTETNET_CONNECTION:
        // TODO: Handle this case.

        return _faildToLoadPage();
        break;
      case WebViewLoadState.FAILED_TO_LOAD:
        // TODO: Handle this case.

        return _faildToLoadPage();

        break;

      default:
        return Container();
    }
  }

  _webView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(baseUrl!)),
      initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
        verticalScrollBarEnabled: false,
        horizontalScrollBarEnabled: false,
        supportZoom: false,
      )),
      onWebViewCreated: (InAppWebViewController controller) {
        setState(() {
          webViewLoadState = WebViewLoadState.SUCCESS;
        });

        _webViewController = controller;
      },
      onLoadStart: (InAppWebViewController controller, Uri? url) {
        // setState(() {
        //   this.url = url;
        // });
      },
      onLoadStop: (InAppWebViewController controller, Uri? url) async {
        // setState(() {
        //   this.url = url;
        // });
      },
      onProgressChanged: (InAppWebViewController controller, int progress) {
        // setState(() {
        //   this.progress = progress / 100;
        // });

        setState(() {
          this.progress = progress / 100;
        });
      },
      onUpdateVisitedHistory: (c, v, b) async {
        _previousPage = _cureentPage!;
        var _url = await c.getUrl();

        _cureentPage = "${baseUrl}${_url!.path}";

        print("Current Page Path : ${_cureentPage}");
        print("Previous Page : ${_previousPage}");
      },
      onLoadError: (InAppWebViewController controller, Uri? url, int code,
          String message) async {
        setState(() {
          webViewLoadState = WebViewLoadState.FAILED_TO_LOAD;
        });
      },
      onPrint: (i, v) {
        print("Current url is : ${v}");
      },
      onLoadHttpError: (InAppWebViewController controller, Uri? url,
          int statusCode, String description) async {
        print("HTTP error $url: $statusCode, $description");

        webViewLoadState = WebViewLoadState.FAILED_TO_LOAD;
      },
    );
  }

  _faildToLoadPage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Image(
            image: AssetImage(AppAssets.no_internet),
            height: 240,
            width: 240,
            fit: BoxFit.cover,
          )),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xffFFFFFF)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.orange,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                _webViewController!.reload();

                setState(() {
                  webViewLoadState = WebViewLoadState.SUCCESS;
                });
              },
              child: const Text(
                "Refresh Now",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    _webViewController!.reload();
  }

  Widget _buildProgressBar() {
    if (progress != 1.0) {
      return SpinKitCubeGrid(
        size: 100,
        color: Colors.blue,
      );
    }
    return Container();
  }
}
