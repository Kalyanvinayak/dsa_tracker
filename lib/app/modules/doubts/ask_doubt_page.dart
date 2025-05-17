import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';

class AskDoubtPage extends StatefulWidget {
  const AskDoubtPage({super.key});

  @override
  State<AskDoubtPage> createState() => _AskDoubtPageState();
}

class _AskDoubtPageState extends State<AskDoubtPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  bool _loading = false;

  void _submitDoubt() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);

    final authService = Provider.of<AuthService>(context, listen: false);
    final firestoreService = FirestoreService();

    try {
      await firestoreService.addDoubt(
        title: _title,
        description: _description,
        userId: authService.currentUser?.uid ?? '',
      );
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting doubt: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Doubt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a title' : null,
                onSaved: (val) => _title = val ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter description' : null,
                onSaved: (val) => _description = val ?? '',
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitDoubt,
                      child: const Text('Post Doubt'),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
