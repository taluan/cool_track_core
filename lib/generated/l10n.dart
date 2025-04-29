// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Đóng`
  String get close {
    return Intl.message(
      'Đóng',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Đồng ý`
  String get agree {
    return Intl.message(
      'Đồng ý',
      name: 'agree',
      desc: '',
      args: [],
    );
  }

  /// `Xác nhận`
  String get confirm {
    return Intl.message(
      'Xác nhận',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Hủy`
  String get cancel {
    return Intl.message(
      'Hủy',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Xong`
  String get done {
    return Intl.message(
      'Xong',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Tiếp tục`
  String get tiep_tuc {
    return Intl.message(
      'Tiếp tục',
      name: 'tiep_tuc',
      desc: '',
      args: [],
    );
  }

  /// `Bắt đầu`
  String get bat_dau {
    return Intl.message(
      'Bắt đầu',
      name: 'bat_dau',
      desc: '',
      args: [],
    );
  }

  /// `Bỏ qua`
  String get bo_qua {
    return Intl.message(
      'Bỏ qua',
      name: 'bo_qua',
      desc: '',
      args: [],
    );
  }

  /// `Cấu hình`
  String get settings {
    return Intl.message(
      'Cấu hình',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Phiên bản`
  String get version {
    return Intl.message(
      'Phiên bản',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `Đăng xuất`
  String get logout {
    return Intl.message(
      'Đăng xuất',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Gửi`
  String get send {
    return Intl.message(
      'Gửi',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Lưu`
  String get save {
    return Intl.message(
      'Lưu',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Xóa`
  String get delete {
    return Intl.message(
      'Xóa',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Sửa`
  String get edit {
    return Intl.message(
      'Sửa',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Thêm`
  String get add {
    return Intl.message(
      'Thêm',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Cập nhật`
  String get update {
    return Intl.message(
      'Cập nhật',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng nhập họ và tên`
  String get canh_bao_nhap_ho_ten {
    return Intl.message(
      'Vui lòng nhập họ và tên',
      name: 'canh_bao_nhap_ho_ten',
      desc: '',
      args: [],
    );
  }

  /// `Vui lòng nhập mật khẩu`
  String get canh_bao_mat_khau_1 {
    return Intl.message(
      'Vui lòng nhập mật khẩu',
      name: 'canh_bao_mat_khau_1',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu phải lớn hơn hoặc bằng 6 kí tự`
  String get canh_bao_mat_khau_2 {
    return Intl.message(
      'Mật khẩu phải lớn hơn hoặc bằng 6 kí tự',
      name: 'canh_bao_mat_khau_2',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu mới không trùng khớp`
  String get canh_bao_mat_khau_3 {
    return Intl.message(
      'Mật khẩu mới không trùng khớp',
      name: 'canh_bao_mat_khau_3',
      desc: '',
      args: [],
    );
  }

  /// `Mật khẩu phải có ít nhất 1 kí tự in hoa và ít nhất 1 chữ số`
  String get canh_bao_mat_khau_4 {
    return Intl.message(
      'Mật khẩu phải có ít nhất 1 kí tự in hoa và ít nhất 1 chữ số',
      name: 'canh_bao_mat_khau_4',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
