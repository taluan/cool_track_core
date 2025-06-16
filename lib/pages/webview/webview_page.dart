import 'package:base_code_flutter/base_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'webview_cubit.dart';


class WebviewPage extends BaseStatelessWidget<WebviewCubit> {
  WebviewPage({super.key, super.title, required String url}) :
        super(createCubit: ()=> WebviewCubit(url: url));

  @override
  Widget body(BuildContext context) {
    if (cubit.isPdf) {
      return SfPdfViewer.network(
        cubit.url,
        headers: const {'accept': '*/*'},
        onDocumentLoadFailed: (details) async {
          await cubit.showError(message: details.description);
          // ignore: use_build_context_synchronously
          Navigator.maybePop(context);
        },
      );
    }
    return WebViewWidget(
      controller: cubit.controller,
    );
  }


}