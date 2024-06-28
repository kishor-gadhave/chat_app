class ChatRoomModel {
  String? chatRoomId;
  Map<String, dynamic>? participants;
  String? lastMessage;

  ChatRoomModel({this.chatRoomId, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["chatroom"];
    participants = map["participants"];
    lastMessage = map["last message"];
  }

  Map<String, dynamic> toMap() {
    return {
      "chatroom": chatRoomId,
      "participants": participants,
      "last message": lastMessage
    };
  }
}