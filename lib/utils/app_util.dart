import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../model/device_info_model.dart';
import 'helper_utils.dart';

class AppUtil {
  AppUtil._instance();
  static final AppUtil instance = AppUtil._instance();

  DeviceInfoModel? _deviceInfo;
  PackageInfo? _appInfo;
  String? _deviceId;


  Future<String?> getDeviceId() async {
    if (_deviceId == null) {
      const storage = FlutterSecureStorage();
      try {
        _deviceId = await storage.read(key: "device_id");
        if (_deviceId == null) {
          _deviceId = await MobileDeviceIdentifier().getDeviceId();
          if (_deviceId != null) {
            storage.write(key: "device_id", value: _deviceId!);
            return _deviceId;
          }
          _deviceId = (await getDeviceInfo())?.identifierForVendor ?? encodeBase64String(DateTime.now().toString());
          if (_deviceId != null) {
            storage.write(key: "device_id", value: _deviceId!);
          }
        }
      } catch (e) {
        storage.delete(key: 'device_id');
        _deviceId = await MobileDeviceIdentifier().getDeviceId();
        if (_deviceId != null) {
          return _deviceId;
        }
      }
    }
    return _deviceId;
  }

  Future<PackageInfo?> getAppInfo() async {
    if (_appInfo != null) {
      return _appInfo;
    }
    try {
      _appInfo = await PackageInfo.fromPlatform();
    } catch (_) {}
    return _appInfo;
  }

  Future<DeviceInfoModel?> getDeviceInfo() async {
    if (_deviceInfo != null) {
      return _deviceInfo;
    }
    try {
      if (Platform.isAndroid) {
        _deviceInfo = _readAndroidBuildData(await DeviceInfoPlugin().androidInfo);
      } else if (Platform.isIOS) {
        _deviceInfo = _readIosDeviceInfo(await DeviceInfoPlugin().iosInfo);
      }
    } catch (_) {}
    return _deviceInfo;
  }

  DeviceInfoModel _readAndroidBuildData(AndroidDeviceInfo data) {
    return DeviceInfoModel(
        deviceName: data.brand,
        deviceModel: data.model,
        systemName: data.version.codename,
        systemVersion: data.version.baseOS ?? data.version.release,
        identifierForVendor: "${data.brand}.${data.id}.${data.bootloader}");
  }

  DeviceInfoModel _readIosDeviceInfo(IosDeviceInfo data) {
    return DeviceInfoModel(
        deviceName: "${data.utsname.machine}_${data.name}",
        deviceModel: data.model,
        systemName: data.systemName,
        systemVersion: data.systemVersion,
        identifierForVendor: data.identifierForVendor);
  }
}