import 'package:flutter/material.dart';
import '../../data/models/emergency_meeting_model.dart';
import '../../data/services/firestore_service.dart';
import 'meeting_details.dart';

class EmergencyMeetingPage extends StatefulWidget {
  const EmergencyMeetingPage({super.key});

  @override
  State<EmergencyMeetingPage> createState() => _EmergencyMeetingPageState();
}

class _EmergencyMeetingPageState extends State<EmergencyMeetingPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<EmergencyMeetingModel> _meetings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  Future<void> _loadMeetings() async {
    final meetings = await _firestoreService.fetchEmergencyMeetings();
    setState(() {
      _meetings = meetings;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Meetings')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _meetings.isEmpty
              ? const Center(child: Text('No emergency meetings found.'))
              : ListView.builder(
                  itemCount: _meetings.length,
                  itemBuilder: (context, index) {
                    final meeting = _meetings[index];
                    return ListTile(
                      title: Text(meeting.title),
                      subtitle: Text(
                        '${meeting.datetime.toLocal()}'
                            .split('.')[0], // Format datetime
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                MeetingDetailPage(meeting: meeting),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
