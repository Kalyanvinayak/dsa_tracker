import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            TextField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_passwordController.text != _confirmPasswordController.text) {
                  setState(() => error = 'Passwords do not match');
                  return;
                }

                final result = await auth.register(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (result != null) {
                  setState(() => error = result);
                } else {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
