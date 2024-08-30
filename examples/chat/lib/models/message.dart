import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final Timestamp createdAt;
  final String id;
  final String uid;
  final Timestamp updatedAt;

  const Message({
    required this.content,
    required this.createdAt,
    required this.id,
    required this.uid,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    try {
      return Message(
        content: json['content']! as String,
        createdAt: json['createdAt']! as Timestamp,
        id: json['id']! as String,
        uid: json['uid']! as String,
        updatedAt: json['updatedAt']! as Timestamp,
      );
    } catch (e) {
      throw Exception('Error converting JSON data to "Message": $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'createdAt': createdAt,
      'id': id,
      'uid': uid,
      'updatedAt': updatedAt,
    };
  }
}
