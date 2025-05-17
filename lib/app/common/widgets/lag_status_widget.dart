import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LagStatusWidget extends StatefulWidget {
  const LagStatusWidget({super.key});

  @override
  State<LagStatusWidget> createState() => _LagStatusWidgetState();
}

class _LagStatusWidgetState extends State<LagStatusWidget> {
  int totalDays = 90;
  int targetQuestions = 450;
  late DateTime startDate;

  int questionsDone = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    startDate = DateTime(2024, 6, 1); // Change this to actual start date
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('progress')
        .doc(userId)
        .collection('daily_updates')
        .get();

    int total = 0;
for (var doc in snapshot.docs) {
  var value = doc.data()['questionsDone'];
  if (value is int) {
    total += value;
  } else if (value is double) {
    total += value.toInt(); // or handle it differently if needed
  }
}


    setState(() {
      questionsDone = total;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const CircularProgressIndicator();

    final today = DateTime.now();
    final daysElapsed = today.difference(startDate).inDays;
    final expectedQuestions = (daysElapsed * (targetQuestions / totalDays)).round();
    final difference = questionsDone - expectedQuestions;

    String status = difference >= 0 ? "You're on track 🎯" : "You're behind by ${-difference} questions ⚠️";
    Color statusColor = difference >= 0 ? Colors.green : Colors.red;

    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📊 Progress Status", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Days Elapsed: $daysElapsed / $totalDays"),
            Text("Questions Done: $questionsDone / $targetQuestions"),
            Text("Expected by now: $expectedQuestions"),
            const SizedBox(height: 10),
            Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
