import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/modules/dashboard/dashboard_page.dart';
import 'app/modules/auth/login_page.dart';
import 'app/routes/app_routes.dart';
import 'app/data/services/auth_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DsaTrackerApp());
}

class DsaTrackerApp extends StatelessWidget {
  const DsaTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'DSA Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        // Remove routes or keep if you want navigation by routes later
        routes: AppRoutes.routes,
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            return authService.isAuthenticated ? const DashboardPage() : const LoginPage();
          },
        ),
      ),
    );
  }
}
