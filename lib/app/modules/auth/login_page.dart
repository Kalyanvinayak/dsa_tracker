import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await auth.login(_emailController.text.trim(), _passwordController.text.trim());
                if (result != null) {
                  setState(() => error = result);
                } else {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text("Don't have an account? Register"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
              child: const Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
