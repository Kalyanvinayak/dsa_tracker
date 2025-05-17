import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../lib/firebase_options.dart';
import '../lib/app/app.dart';
import '../lib/app/routes/app_routes.dart';
import '../lib/app/modules/dashboard/dashboard_page.dart';
import '../lib/app/modules/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: AppRoutes.routes,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          // If the snapshot has user data, then they're already signed in
          if (snapshot.hasData && snapshot.data != null) {
            return DashboardPage();
          }
          
          // Otherwise, show the login page
          return LoginPage();
        },
      ),
    );
  }
}