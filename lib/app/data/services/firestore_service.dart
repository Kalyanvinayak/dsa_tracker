import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/topic_model.dart';
import 'package:dsa_tracker/app/data/models/emergency_meeting_model.dart';
import '../models/comment_model.dart';
import '../models/doubt_model.dart';
import '../models/progress_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProgressModel?> getTodayProgress(String userId) async {
  final dateStr = DateTime.now().toIso8601String().substring(0, 10); // yyyy-MM-dd
  final docRef = _firestore
      .collection('progress')
      .doc(userId)
      .collection('daily_updates')
      .doc(dateStr);

  final doc = await docRef.get();
  if (doc.exists) {
    return ProgressModel.fromMap(doc.data()!); // You must have a fromMap method
  } else {
    return null;
  }
}

// Fetch all doubts ordered by newest
Future<List<DoubtModel>> fetchDoubts() async {
  final snapshot = await _firestore
      .collection('doubts')
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs.map((doc) => DoubtModel.fromDoc(doc)).toList();
}

// Add a new doubt
Future<void> addDoubt({
  required String title,
  required String description,
  required String userId,
}) async {
  await _firestore.collection('doubts').add({
    'title': title,
    'description': description,
    'userId': userId,
    'timestamp': FieldValue.serverTimestamp(),
  });
}

// Fetch comments for a doubt
Future<List<CommentModel>> fetchComments(String doubtId) async {
  final snapshot = await _firestore
      .collection('doubts')
      .doc(doubtId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs.map((doc) => CommentModel.fromDoc(doc)).toList();
}

// Add a comment to a doubt
Future<void> addComment({
  required String doubtId,
  required String userId,
  required String comment,
}) async {
  await _firestore
      .collection('doubts')
      .doc(doubtId)
      .collection('comments')
      .add({
    'userId': userId,
    'comment': comment,
    'timestamp': FieldValue.serverTimestamp(),
  });
}


  // Fetch all topics
  Future<List<TopicModel>> fetchTopics() async {
    final snapshot = await _firestore.collection('topics').get();
    return snapshot.docs
        .map((doc) => TopicModel.fromMap(doc.id, doc.data()))
        .toList();
  }
  // Fetch emergency meetings ordered by date/time descending
Future<List<EmergencyMeetingModel>> fetchEmergencyMeetings() async {
  final snapshot = await _firestore
      .collection('emergency_meetings')
      .orderBy('datetime', descending: true)
      .get();

  return snapshot.docs
      .map((doc) => EmergencyMeetingModel.fromDoc(doc))
      .toList();
}


  // Save daily progress for a user
  Future<void> saveDailyProgress({
    required String userId,
    required DateTime date,
    required int questionsDone,
    required int topicsStudied,
    required int newTopicsStudied,
    required Map<String, dynamic> topicProgress,
  }) async {
    final dateStr = date.toIso8601String().substring(0, 10); // yyyy-MM-dd
    final docRef = _firestore
        .collection('progress')
        .doc(userId)
        .collection('daily_updates')
        .doc(dateStr);

    await docRef.set({
      'questionsDone': questionsDone,
      'topicsStudied': topicsStudied,
      'newTopicsStudied': newTopicsStudied,
      'topicProgress': topicProgress,
    }, SetOptions(merge: true));
  }
}
