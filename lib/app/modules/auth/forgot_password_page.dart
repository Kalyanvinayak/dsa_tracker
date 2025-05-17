import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? message;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            if (message != null)
              Text(message!, style: TextStyle(color: message!.startsWith('Error') ? Colors.red : Colors.green)),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await auth.resetPassword(_emailController.text.trim());
                setState(() {
                  message = result ?? 'Password reset link sent to your email.';
                });
              },
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
