class LogApiModel {
  String url = "";
  String params = "";
  String header = "";
  String response = "";
  int statusCode = 0;
  DateTime createdDate = DateTime.now();

  LogApiModel({this.url = "", this.params = "", this.header = "", this.response = "Đang chờ response"});
}