import 'package:flutter/material.dart';
import '../../data/models/emergency_meeting_model.dart';

class MeetingDetailPage extends StatelessWidget {
  final EmergencyMeetingModel meeting;

  const MeetingDetailPage({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(meeting.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              meeting.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Date & Time: ${meeting.datetime.toLocal()}'.split('.')[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (meeting.location != null)
              Text('Location: ${meeting.location}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(meeting.description),
          ],
        ),
      ),
    );
  }
}
