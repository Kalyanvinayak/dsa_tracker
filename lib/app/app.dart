// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/services/auth_service.dart';
import 'routes/app_routes.dart';

class DsaTrackerApp extends StatelessWidget {
  const DsaTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Add other providers like FirestoreService if needed
      ],
      child: MaterialApp(
        title: 'DSA Tracker',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.authCheck,
        routes: AppRoutes.routes,
      ),
    );
  }
}
