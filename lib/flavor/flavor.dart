
enum FlavorType {dev, uat, pro}

class FlavorValue {
  String rootUrl;
  final String tenantDomain;
  final String appName;
  final bool showLog;

  FlavorValue({required this.rootUrl, required this.tenantDomain, required this.appName, this.showLog = false});
}

mixin AppFlavor {
  static late FlavorType _type;
  static late FlavorValue _value;

  static bool get showLog {
    return _value.showLog;
  }

  static void updateRootUrl(String url) {
    _value.rootUrl = url;
  }

  static FlavorValue get value {
    return _value;
  }

  static String get rootUrl {
    return _value.rootUrl;
  }

  static FlavorType get flavorType {
    return _type;
  }

  static bool get isUAT {
    return _type == FlavorType.uat;
  }

  static String get appName {
    return _value.appName;
  }

  static String getTenantDomain({required String tenant}) {
    return value.tenantDomain.replaceAll("{tenant}", tenant);
  }

  static String getApprovalFileUrl({required String filePath, required String fileName}) {
    return "$rootUrl/approval/file/common?${Uri(queryParameters: {'path': filePath, 'name': fileName}.map((key, value) => MapEntry(key, value.toString()))).query}";
  }

  static void loadConfig({FlavorType flavorType = FlavorType.pro, required FlavorValue value}) {
    _type = flavorType;
    _value = value;
  }
}
