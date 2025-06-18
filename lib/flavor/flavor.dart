
enum FlavorType {dev, uat, pro}
enum AppChannel {
  appCust('AppCust'),
  appSuper('AppSuper');
  final String name;
  const AppChannel(this.name);
}

class FlavorValue {
  String rootUrl;
  String cdnUrl;
  String socketUrl;
  final String appName;
  final bool showLog;

  FlavorValue({required this.rootUrl, this.cdnUrl = "", this.socketUrl = "", required this.appName, this.showLog = false});
}

mixin AppFlavor {
  static late FlavorType _type;
  static late FlavorValue _value;
  static late AppChannel _channel;
  static bool? _enabledLog;

  static String get appChannel => _channel.name;

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

  static String get socketUrl {
    return _value.socketUrl;
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

  static void loadConfig({FlavorType flavorType = FlavorType.pro, required FlavorValue value, required AppChannel channel, bool? enabledLog}) {
    _type = flavorType;
    _value = value;
    _channel = channel;
    _enabledLog = enabledLog;
  }
}
