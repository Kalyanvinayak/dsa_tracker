import 'package:flutter/material.dart';
import '../../data/models/doubt_model.dart';
import '../../data/services/firestore_service.dart';
import 'ask_doubt_page.dart';
import 'doubt_detail_page.dart';

class DoubtForumPage extends StatefulWidget {
  const DoubtForumPage({super.key});

  @override
  State<DoubtForumPage> createState() => _DoubtForumPageState();
}

class _DoubtForumPageState extends State<DoubtForumPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<DoubtModel> _doubts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadDoubts();
  }

  Future<void> _loadDoubts() async {
    final doubts = await _firestoreService.fetchDoubts();
    setState(() {
      _doubts = doubts;
      _loading = false;
    });
  }

  void _navigateToAskDoubt() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AskDoubtPage()),
    );
    if (result == true) {
      _loadDoubts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doubt Forum')),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAskDoubt,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _doubts.isEmpty
              ? const Center(child: Text('No doubts posted yet.'))
              : ListView.builder(
                  itemCount: _doubts.length,
                  itemBuilder: (context, index) {
                    final doubt = _doubts[index];
                    return ListTile(
                      title: Text(doubt.title),
                      subtitle: Text(
                          'Posted on ${doubt.timestamp.toLocal()}'.split('.')[0]),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoubtDetailPage(doubt: doubt),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
