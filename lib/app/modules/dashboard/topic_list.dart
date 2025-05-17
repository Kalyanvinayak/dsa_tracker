import 'package:flutter/material.dart';
import '../../data/models/topic_model.dart';
import '../../data/services/firestore_service.dart';
import 'progress_update_page.dart';

class TopicListPage extends StatefulWidget {
  const TopicListPage({super.key});

  @override
  State<TopicListPage> createState() => _TopicListPageState();
}

class _TopicListPageState extends State<TopicListPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<TopicModel> _topics = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final topics = await _firestoreService.fetchTopics();
    setState(() {
      _topics = topics;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DSA Topics')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _topics.length,
              itemBuilder: (context, index) {
                final topic = _topics[index];
                return ListTile(
                  title: Text(topic.name),
                  subtitle: Text(topic.description),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProgressUpdatePage(topic: topic),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
