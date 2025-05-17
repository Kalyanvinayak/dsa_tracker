import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final CollectionReference _progressRef = FirebaseFirestore.instance.collection('progress');

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final snapshot = await _progressRef
        .where('date', isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 30)))
        .get();

    // Aggregate by userId
    Map<String, Map<String, dynamic>> userTotals = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = data['userId'];
      final questions = data['questionsDone'] ?? 0;
      final topics = data['topicsStudied'] ?? 0;

      if (!userTotals.containsKey(userId)) {
        userTotals[userId] = {
          'userId': userId,
          'totalQuestions': 0,
          'totalTopics': 0,
        };
      }

      userTotals[userId]!['totalQuestions'] += questions;
      userTotals[userId]!['totalTopics'] += topics;
    }

    final resultList = userTotals.values.toList();

    // Sort descending by totalQuestions (you can add weights if needed)
    resultList.sort((a, b) => (b['totalQuestions']).compareTo(a['totalQuestions']));

    return resultList;
  }
}
