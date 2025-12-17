import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_core_localizations_en.dart';
import 'app_core_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppCoreLocalizations
/// returned by `AppCoreLocalizations.of(context)`.
///
/// Applications need to include `AppCoreLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_core_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppCoreLocalizations.localizationsDelegates,
///   supportedLocales: AppCoreLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppCoreLocalizations.supportedLocales
/// property.
abstract class AppCoreLocalizations {
  AppCoreLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppCoreLocalizations? of(BuildContext context) {
    return Localizations.of<AppCoreLocalizations>(
      context,
      AppCoreLocalizations,
    );
  }

  static const LocalizationsDelegate<AppCoreLocalizations> delegate =
      _AppCoreLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @close.
  ///
  /// In vi, this message translates to:
  /// **'Đóng'**
  String get close;

  /// No description provided for @agree.
  ///
  /// In vi, this message translates to:
  /// **'Đồng ý'**
  String get agree;

  /// No description provided for @confirm.
  ///
  /// In vi, this message translates to:
  /// **'Xác nhận'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In vi, this message translates to:
  /// **'Hủy'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In vi, this message translates to:
  /// **'Xong'**
  String get done;

  /// No description provided for @tiep_tuc.
  ///
  /// In vi, this message translates to:
  /// **'Tiếp tục'**
  String get tiep_tuc;

  /// No description provided for @bat_dau.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu'**
  String get bat_dau;

  /// No description provided for @bo_qua.
  ///
  /// In vi, this message translates to:
  /// **'Bỏ qua'**
  String get bo_qua;

  /// No description provided for @settings.
  ///
  /// In vi, this message translates to:
  /// **'Cấu hình'**
  String get settings;

  /// No description provided for @version.
  ///
  /// In vi, this message translates to:
  /// **'Phiên bản'**
  String get version;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;

  /// No description provided for @send.
  ///
  /// In vi, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @save.
  ///
  /// In vi, this message translates to:
  /// **'Lưu'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In vi, this message translates to:
  /// **'Xóa'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In vi, this message translates to:
  /// **'Sửa'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In vi, this message translates to:
  /// **'Thêm'**
  String get add;

  /// No description provided for @update.
  ///
  /// In vi, this message translates to:
  /// **'Cập nhật'**
  String get update;

  /// No description provided for @canh_bao_nhap_ho_ten.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên'**
  String get canh_bao_nhap_ho_ten;

  /// No description provided for @canh_bao_mat_khau_1.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get canh_bao_mat_khau_1;

  /// No description provided for @canh_bao_mat_khau_2.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải lớn hơn hoặc bằng 6 kí tự'**
  String get canh_bao_mat_khau_2;

  /// No description provided for @canh_bao_mat_khau_3.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu mới không trùng khớp'**
  String get canh_bao_mat_khau_3;

  /// No description provided for @canh_bao_mat_khau_4.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 1 kí tự in hoa và ít nhất 1 chữ số'**
  String get canh_bao_mat_khau_4;

  /// No description provided for @chup_anh.
  ///
  /// In vi, this message translates to:
  /// **'Chụp ảnh'**
  String get chup_anh;

  /// No description provided for @chon_tu_thu_vien.
  ///
  /// In vi, this message translates to:
  /// **'Chọn từ thư viện'**
  String get chon_tu_thu_vien;

  /// No description provided for @chon_tep.
  ///
  /// In vi, this message translates to:
  /// **'Chọn tệp'**
  String get chon_tep;
}

class _AppCoreLocalizationsDelegate
    extends LocalizationsDelegate<AppCoreLocalizations> {
  const _AppCoreLocalizationsDelegate();

  @override
  Future<AppCoreLocalizations> load(Locale locale) {
    return SynchronousFuture<AppCoreLocalizations>(
      lookupAppCoreLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppCoreLocalizationsDelegate old) => false;
}

AppCoreLocalizations lookupAppCoreLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppCoreLocalizationsEn();
    case 'vi':
      return AppCoreLocalizationsVi();
  }

  throw FlutterError(
    'AppCoreLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
