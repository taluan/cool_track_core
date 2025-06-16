class EmojiModel {
  String emoticonCode = "";
  String emoticonType = "";
  String name = "";

  EmojiModel.fromJson(Map<String, dynamic> json) {
    emoticonCode = json['emoticon_code'];
    emoticonType = json['emoticon_type'];
    name = json['dictionary_name'];
  }
}