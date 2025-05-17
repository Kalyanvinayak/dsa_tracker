class ProgressModel {
  final String uid;
  final DateTime date;
  final int questionsDone;
  final int topicsStudied;
  final int newTopics;

  ProgressModel({
    required this.uid,
    required this.date,
    required this.questionsDone,
    required this.topicsStudied,
    required this.newTopics,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'date': date.toIso8601String(),
        'questionsDone': questionsDone,
        'topicsStudied': topicsStudied,
        'newTopics': newTopics,
      };

  factory ProgressModel.fromMap(Map<String, dynamic> map) {
    return ProgressModel(
      uid: map['uid'],
      date: DateTime.parse(map['date']),
      questionsDone: map['questionsDone'],
      topicsStudied: map['topicsStudied'],
      newTopics: map['newTopics'],
    );
  }
}
