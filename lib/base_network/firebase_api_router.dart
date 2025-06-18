import 'package:base_code_flutter/base_core.dart';
import 'package:base_code_flutter/utils/helper_utils.dart';

class FirebaseTokenApiRouter extends ApiRouter {
  static const _subPath = 'FirebaseToken';

  FirebaseTokenApiRouter.addOrUpdate(
      {required String token, required String device_id, String? device_type})
      : super(
            path: '$_subPath',
            params: {
              "token": token,
              "device_id": device_id,
              "device_type": device_type,
            },
            method: Method.post,);

  FirebaseTokenApiRouter.delete(
      {required String device_id, required String user_id})
      : super(
    path: '$_subPath/clear-token',
    params: {
      "device_id": device_id,
      "user_id": user_id,
    },
    method: Method.delete,);
}
