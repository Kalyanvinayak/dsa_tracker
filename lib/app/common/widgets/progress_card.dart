import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int questionsDone;
  final int topicsStudied;
  final int newTopics;

  const ProgressCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.questionsDone,
    required this.topicsStudied,
    required this.newTopics,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statColumn("Questions", questionsDone),
                _statColumn("Topics", topicsStudied),
                _statColumn("New", newTopics),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _statColumn(String label, int count) {
    return Column(
      children: [
        Text("$count", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
