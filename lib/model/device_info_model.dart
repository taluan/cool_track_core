class DeviceInfoModel {
//name: iPhone 12 Pro Max, systemName: iOS, systemVersion: 14.4, model: iPhone, localizedModel: iPhone, identifierForVendor
String deviceName;
String systemName;
String systemVersion;
String deviceModel;
String? identifierForVendor;

DeviceInfoModel({required this.deviceName, required this.systemName, required this.systemVersion,
      required this.deviceModel, required this.identifierForVendor});
}