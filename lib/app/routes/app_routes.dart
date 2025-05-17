// lib/app/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../modules/auth/login_page.dart';
import '../modules/auth/register_page.dart';
import '../modules/auth/forgot_password_page.dart';
import '../modules/dashboard/dashboard_page.dart';
import '../modules/dashboard/progress_update_page.dart';
import '../modules/dashboard/topic_list.dart';
import '../modules/leaderboard/leaderboard_page.dart';
import '../modules/emergency/emergency_meeting.dart';
import '../modules/doubts/ask_doubt_page.dart';
import '../modules/doubts/doubt_forum_page.dart';
import '../data/services/auth_service.dart';
import 'package:provider/provider.dart';


class AppRoutes {
  static const String authCheck = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String progressUpdate = '/progress-update';
  static const String topicList = '/topic-list';
  static const String leaderboard = '/leaderboard';
  static const String emergencyMeeting = '/emergency';
  static const String doubtForum = '/doubts';
  static const String askDoubt = '/ask-doubt';
  static const String forgotPassword = '/forgot-password';
  

  static Map<String, WidgetBuilder> get routes => {
  login: (_) => const LoginPage(),
  register: (_) => const RegisterPage(),
  dashboard: (_) => const DashboardPage(),
  topicList: (_) => const TopicListPage(),
  leaderboard: (_) => const LeaderboardPage(),
  emergencyMeeting: (_) => const EmergencyMeetingPage(),
  doubtForum: (_) => const DoubtForumPage(),
  askDoubt: (_) => const AskDoubtPage(),
  forgotPassword: (_) => const ForgotPasswordPage(),
};

}
