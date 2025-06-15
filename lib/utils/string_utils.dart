import 'package:diacritic/diacritic.dart';
import 'package:encrypt/encrypt.dart';

const kEmailRegularExpression =
    "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
const kPhoneRegularExpression = r'(^(?:[+0]9)?[0-9]{10,12}$)';
final kAesKey = Key.fromUtf8('86MLSF45GE8S6J20AK45Q9KF5O6DDAQ1');
final kAesIv = IV.fromUtf8("F5502320F8429037");

extension StringExt on String {
  String aesEncrypt() {
    if (isEmpty) {
      return "";
    }
    final encrypter = Encrypter(AES(kAesKey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(this, iv: kAesIv);
    return encrypted.base64;
  }

  String aesDecrypt() {
    if (isEmpty) {
      return "";
    }
    final encrypter = Encrypter(AES(kAesKey, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(this, iv: kAesIv);
    return decrypted;
  }

  bool isEmailValid() {
    return (RegExp(kEmailRegularExpression).hasMatch(this));
  }

  bool isPhoneValid() {
    RegExp regex = RegExp(r'^0[^0][0-9]');
    return regex.hasMatch(this) && length == 10;
  }

  double toDouble() {
    if (isEmpty) {
      return 0;
    } else {
      return double.tryParse(replaceAll(".", ",").replaceAll(",", ".")) ?? 0;
    }
  }
  String removeDiacritic() {
    return removeDiacritics(this);
  }
}
