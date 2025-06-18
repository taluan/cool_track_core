import 'package:base_code_flutter/base_network/firebase_api_router.dart';

import '../base_core.dart';

class FirebaseTokenService {
  FirebaseTokenService._instance();
  static final FirebaseTokenService instance = FirebaseTokenService._instance();

  Future<void> sendToken({required String token}) async {
    final deviceId = await appUtil.getDeviceId();
    final deviceInfo = await appUtil.getDeviceInfo();
    await apiClient.request(router: FirebaseTokenApiRouter.addOrUpdate(token: token, device_id: deviceId ?? "unknow", device_type: deviceInfo?.deviceModel), target: null);
  }

  Future<void> deleteToken(String userId) async {
    final deviceId = await appUtil.getDeviceId();
    await apiClient.request(router: FirebaseTokenApiRouter.delete(device_id: deviceId ?? "unknow", user_id: userId), target: null);
  }

}