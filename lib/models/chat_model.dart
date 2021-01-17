import 'package:equatable/equatable.dart';

class ChatModel extends Equatable {
  final String uid;
  final String peerId;
  final String message;
  final String username;
  final int createdAt;

  const ChatModel({
    this.uid,
    this.peerId,
    this.message,
    this.username,
    this.createdAt,
  });

  ChatModel copyWith({
    String uid,
    String peerId,
    String message,
    String username,
    int createdAt,
  }) {
    if ((uid == null || identical(uid, this.uid)) &&
        (peerId == null || identical(peerId, this.peerId)) &&
        (message == null || identical(message, this.message)) &&
        (username == null || identical(username, this.username)) &&
        (createdAt == null || identical(createdAt, this.createdAt))) {
      return this;
    }

    return new ChatModel(
      uid: uid ?? this.uid,
      peerId: peerId ?? this.peerId,
      message: message ?? this.message,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ChatModel{uid: $uid, peerId: $peerId, message: $message, username: $username, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          peerId == other.peerId &&
          message == other.message &&
          username == other.username &&
          createdAt == other.createdAt);

  @override
  int get hashCode => uid.hashCode ^ peerId.hashCode ^ message.hashCode ^ username.hashCode ^ createdAt.hashCode;

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return new ChatModel(
      uid: map['uid'] as String,
      peerId: map['peerId'] as String,
      message: map['message'] as String,
      username: map['username'] as String,
      createdAt: map['createdAt'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return <String, dynamic>{
      'uid': this.uid,
      'peerId': this.peerId,
      'message': this.message,
      'username': this.username,
      'createdAt': this.createdAt,
    };
  }

  //</editor-fold>

  @override
  List<Object> get props => [
        uid,
        peerId,
        message,
        username,
        createdAt,
      ];
}
