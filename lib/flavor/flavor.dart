
enum FlavorType {dev, uat, pro}

class FlavorValue {
  String rootUrl;
  String cdnUrl;
  final String appName;
  final bool showLog;

  FlavorValue({required this.rootUrl, this.cdnUrl = "", required this.appName, this.showLog = false});
}

mixin AppFlavor {
  static late FlavorType _type;
  static late FlavorValue _value;
  static bool? _enabledLog;

  static bool get showLog {
    return _value.showLog;
  }

  static bool get enabledLog {
    return _enabledLog ?? false;
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

  static String get cdnUrl {
    return _value.cdnUrl;
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

  static void loadConfig({FlavorType flavorType = FlavorType.pro, required FlavorValue value, bool? enabledLog}) {
    _type = flavorType;
    _value = value;
    _enabledLog = enabledLog;
  }
}
