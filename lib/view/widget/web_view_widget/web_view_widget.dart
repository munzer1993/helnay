import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/web_view_widget_controller.dart/web_view_widget_controller.dart';
import 'package:project/core/constant/link_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  final String appBarTitle;
  final String url;

  const WebViewScreen(
      {super.key, required this.appBarTitle, required this.url});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebViewScreenControllerIMP>(
      init: WebViewScreenControllerIMP(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: InkWell(
            onTap: controller.onBackBtnClick,
            child: Icon(
              CupertinoIcons.left_chevron,
              color: Theme.of(context).primaryColor,
            ),
          ),
          elevation: 0,
          title:
              Text(appBarTitle, style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: Stack(
          children: [
            WebView(
              initialUrl: '${AppLink.base}$url',
              javascriptMode: JavascriptMode.unrestricted,
              onPageStarted: controller.onPageStarted,
              onProgress: controller.onProgress,
              onPageFinished: controller.onPageFinished,
            ),
            if (controller.loadingPercentage < 100)
              LinearProgressIndicator(
                value: controller.loadingPercentage / 100.0,
                color:
                    Theme.of(context).buttonTheme.colorScheme!.inversePrimary,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
              ),
          ],
        ),
      ),
    );
  }
}
