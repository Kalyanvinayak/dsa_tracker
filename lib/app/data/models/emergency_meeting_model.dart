import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyMeetingModel {
  final String id;
  final String title;
  final String description;
  final DateTime datetime;
  final String? location;

  EmergencyMeetingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.datetime,
    this.location,
  });

  factory EmergencyMeetingModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EmergencyMeetingModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      datetime: (data['datetime'] as Timestamp).toDate(),
      location: data['location'],
    );
  }
}
