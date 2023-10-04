import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class WebViewScreenController extends GetxController {
  void onPageFinished(String url);
  void onProgress(int progress);
  void onPageStarted(String url);
  void onBackBtnClick();
}

class WebViewScreenControllerIMP extends WebViewScreenController {
  var loadingPercentage = 0;

  @override
  void onInit() {
    if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();
    if (GetPlatform.isIOS) WebView.platform = CupertinoWebView();
    super.onInit();
  }

  @override
  void onPageFinished(String url) {
    loadingPercentage = 100;
    update();
  }

  @override
  void onProgress(int progress) {
    loadingPercentage = progress;
    update();
  }

  @override
  void onPageStarted(String url) {
    loadingPercentage = 0;
    update();
  }

  @override
  void onBackBtnClick() {
    Get.back();
  }
}
