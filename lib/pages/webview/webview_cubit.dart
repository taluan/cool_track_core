
import 'dart:io';

import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';


class WebviewCubit extends BaseCubit {

  late WebViewController controller;
  String url;
  WebviewCubit({
    required this.url
  }) {
    if (url.isNotEmpty && !url.startsWith("http")) {
      url = "${AppFlavor.cdnUrl}/$url";
    }
  }

  bool get isPdf => url.toLowerCase().contains('.pdf');



  @override
  void initCubit() {
    super.initCubit();
    if (isPdf) return;
    showLoading();
    final reg = RegExp('(.doc|.docx|.xls|.xlsx|.ppt|.pptx)\$');
    if (reg.hasMatch(url) && Platform.isAndroid) {
      url = 'https://view.officeapps.live.com/op/embed.aspx?src=$url';
    }
    debugPrint("webview url: $url");
    showLoading();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              hideLoading();
            }
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            hideLoading();
          },
          onWebResourceError: (WebResourceError error) {
            showError(message: error.toString());
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(url),
      );
      // ..addJavaScriptChannel(
      //   webViewChannelName,
      //   onMessageReceived: (message) =>
      //       onMessageReceived(jsonDecode(message.message)),
      // );
  }


  void refreshWebview() {
    controller.reload();
  }

  @override
  void dispose() {
    super.dispose();
  }
}