import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String comment;
  final DateTime timestamp;

  CommentModel({
    required this.id,
    required this.userId,
    required this.comment,
    required this.timestamp,
  });

  factory CommentModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
