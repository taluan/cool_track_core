

import 'package:base_code_flutter/utils/string_utils.dart';

import '../../generated/l10n.dart';

const kPassRegularExpression = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{7,}$';

mixin Validator {
  static String? validatePassword(String? pass) {
    if (pass == null || pass.isEmpty) {
      return S.current.canh_bao_mat_khau_1;
    } else if (pass.length < 6) {
      return S.current.canh_bao_mat_khau_2;
    }
    // else {
    //   RegExp regExp = new RegExp(kPassRegularExpression);
    //   if (regExp.hasMatch(pass) == false) {
    //     return S.current.canh_bao_mat_khau_4;
    //   }
    // }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Vui lòng nhập email";
    } else if (!RegExp(kEmailRegularExpression).hasMatch(email)) {
      return "Email không hợp lệ";
    }
    return null;
  }

  static String? validateNewPassword(String? pass, String? confirmPass) {
    if (pass == null) {
      return null;
    }
    final validatePass = validatePassword(confirmPass);
    if (validatePass == null) {
      if (pass != confirmPass) {
        return S.current.canh_bao_mat_khau_3;
      }
    }
    return validatePass;
  }

  static String? validatePhoneNumber(String? phone) {
    if (phone == null) {
      return null;
    }
    if (!phone.isPhoneValid()) {
      return "Số điện thoại không hợp lệ";
    }
    return null;
  }

  static String? validateEmpty(String? value,
      [String errorText = 'Vui lòng nhập đủ thông tin']) {
    if ((value ?? '').isEmpty) return errorText;
    return null;
  }
}
