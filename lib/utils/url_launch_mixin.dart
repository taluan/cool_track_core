import 'package:base_code_flutter/base_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

mixin UrlLaunchMixin on BaseCubit {

  Future<void> makePhoneCall(String phone) async {
    if (phone.isEmpty) {
      return;
    }
    showLoading();
    final url = 'tel:${phone.replaceAll(" ", "")}';
    // print(url);
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      debugPrint("Could not launch $url");
      showError(message: "Không thể gọi điện thoại đến số $phone");
    }
    hideLoading();
  }

  Future<void> openUrl(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
      );
    } else {
      showError(message: "Could not launch $url");
    }
  }

}