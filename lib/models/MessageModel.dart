class MessageModel {
  String? massageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdOn;

  MessageModel({this.massageId, this.sender, this.text, this.seen, this.createdOn});

  MessageModel.fromMap(Map<String, dynamic> map) {
    massageId = map["messageId"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdOn = map["createdOn"].toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": massageId,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdOn": createdOn
    };
  }
}