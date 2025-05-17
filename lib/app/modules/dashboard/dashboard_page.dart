import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/progress_model.dart';
import '../../data/models/topic_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../common/widgets/progress_card.dart';
import '../../common/widgets/lag_status_widget.dart';
import '../../routes/app_routes.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ProgressModel? todayProgress;
  int totalDays = 90;
  int completedDays = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  Future<void> fetchProgress() async {
    final user = context.read<AuthService>().currentUser;
    if (user == null) return;
    final firestore = FirestoreService();

    final progress = await firestore.getTodayProgress(user.uid);

    final startDate = DateTime(2024, 6, 1); // Replace with actual prep start date
    final today = DateTime.now();
    final daysElapsed = today.difference(startDate).inDays;

    setState(() {
      todayProgress = progress;
      completedDays = daysElapsed;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final laggingDays = totalDays - completedDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchProgress,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const LagStatusWidget(),
                  const SizedBox(height: 16),
                  ProgressCard(
                    title: 'Today\'s Progress',
                    subtitle: 'Track your daily DSA efforts.',
                    questionsDone: todayProgress?.questionsDone ?? 0,
                    topicsStudied: todayProgress?.topicsStudied ?? 0,
                    newTopics: todayProgress?.newTopics ?? 0,
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: completedDays / totalDays,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade800,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Day $completedDays of $totalDays',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: laggingDays <= 0 ? Colors.green : Colors.red,
                    child: ListTile(
                      title: Text(
                        laggingDays <= 0
                            ? "You're on track!"
                            : "Lagging by $laggingDays days!",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Let\'s speed up the grind 🚀'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Navigation Buttons Section
                  ElevatedButton(
                    onPressed: () {
                      // You need to pass a TopicModel when navigating
                      // For example, pass a dummy or first topic here
                      final dummyTopic = TopicModel(id: 'default', name: 'Sample Topic', description: "Hello");
                      Navigator.pushNamed(
                        context,
                        AppRoutes.progressUpdate,
                        arguments: dummyTopic,
                      );
                    },
                    child: const Text('Update Progress'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.topicList),
                    child: const Text('View Topics'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.leaderboard),
                    child: const Text('Leaderboard'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.emergencyMeeting),
                    child: const Text('Emergency Meeting'),
                  ),

                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.doubtForum),
                    child: const Text('Doubt Forum'),
                  ),
                ],
              ),
            ),
    );
  }
}
