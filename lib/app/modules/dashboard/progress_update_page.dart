import 'package:flutter/material.dart';
import '../../data/models/topic_model.dart';
import '../../data/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressUpdatePage extends StatefulWidget {
  final TopicModel topic;

  const ProgressUpdatePage({super.key, required this.topic});

  @override
  State<ProgressUpdatePage> createState() => _ProgressUpdatePageState();
}

class _ProgressUpdatePageState extends State<ProgressUpdatePage> {
  final _questionsController = TextEditingController();
  final _topicsStudiedController = TextEditingController();
  final _newTopicsStudiedController = TextEditingController();

  bool _isSaving = false;

  final FirestoreService _firestoreService = FirestoreService();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _questionsController.dispose();
    _topicsStudiedController.dispose();
    _newTopicsStudiedController.dispose();
    super.dispose();
  }

  Future<void> _saveProgress() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final int questionsDone = int.tryParse(_questionsController.text) ?? 0;
    final int topicsStudied = int.tryParse(_topicsStudiedController.text) ?? 0;
    final int newTopicsStudied = int.tryParse(_newTopicsStudiedController.text) ?? 0;

    setState(() {
      _isSaving = true;
    });

    // Save daily progress for today
    final today = DateTime.now();

    await _firestoreService.saveDailyProgress(
      userId: user.uid,
      date: today,
      questionsDone: questionsDone,
      topicsStudied: topicsStudied,
      newTopicsStudied: newTopicsStudied,
      topicProgress: {
        widget.topic.id: {
          'questionsDone': questionsDone,
          'topicsStudied': topicsStudied,
          'newTopicsStudied': newTopicsStudied,
        }
      },
    );

    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Progress: ${widget.topic.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _questionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Questions Done Today',
              ),
            ),
            TextField(
              controller: _topicsStudiedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Topics Studied Today',
              ),
            ),
            TextField(
              controller: _newTopicsStudiedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'New Topics Studied',
              ),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveProgress,
                    child: const Text('Save Progress'),
                  ),
          ],
        ),
      ),
    );
  }
}
