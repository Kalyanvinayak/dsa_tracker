import 'package:flutter/material.dart';
import '../../data/services/leaderboard_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final LeaderboardService _leaderboardService = LeaderboardService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _leaderboard = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final data = await _leaderboardService.getLeaderboard();
    setState(() {
      _leaderboard = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _leaderboard.length,
              itemBuilder: (context, index) {
                final user = _leaderboard[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(user['name']),
                  trailing: Text('${user['totalQuestions']} questions'),
                );
              },
            ),
    );
  }
}
