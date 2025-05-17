import 'package:cloud_firestore/cloud_firestore.dart';

class DoubtModel {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime timestamp;

  DoubtModel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.timestamp,
  });

  factory DoubtModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DoubtModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
