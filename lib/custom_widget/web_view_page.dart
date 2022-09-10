import 'package:base_scaffold/base_scaffold.dart';
import 'package:base_scaffold/base_toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String url;

  WebViewPage({this.title, this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  //Common Variables
  ThemeData themeData;

  bool showLoader = true;

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return BaseScaffold(
      toolbarLeftIconType: BaseToolbar.IMAGE_TYPE_ICON,
      toolbarLeftIcon: Icons.arrow_back_ios,
      toolbarLeftIconClick: () {
        navigationPageToBack();
      },
      toolbarTitle: widget.title,
      body: loginBody(),
      isScreenLoadingWithBackground: showLoader,
    );
  }

  Widget loginBody() {
    return WebView(
      debuggingEnabled: true,
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (String url) {
        setState(() {
          showLoader = true;
        });
      },
      onPageFinished: (String url) {
        setState(() {
          showLoader = false;
        });
      },
    );
  }

  void navigationPageToBack() {
    Navigator.pop(context);
  }

}
