import 'package:flutter/material.dart';
import '../../data/models/doubt_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/services/firestore_service.dart';
import 'package:provider/provider.dart';
import '../../data/services/auth_service.dart';

class DoubtDetailPage extends StatefulWidget {
  final DoubtModel doubt;

  const DoubtDetailPage({super.key, required this.doubt});

  @override
  State<DoubtDetailPage> createState() => _DoubtDetailPageState();
}

class _DoubtDetailPageState extends State<DoubtDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<CommentModel> _comments = [];
  bool _loading = true;
  final TextEditingController _commentController = TextEditingController();
  bool _postingComment = false;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final comments =
        await _firestoreService.fetchComments(widget.doubt.id);
    setState(() {
      _comments = comments;
      _loading = false;
    });
  }

  Future<void> _postComment() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() => _postingComment = true);

    try {
      await _firestoreService.addComment(
        doubtId: widget.doubt.id,
        userId: authService.currentUser?.uid ?? '',
        comment: commentText,
      );
      _commentController.clear();
      _loadComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post comment: $e')));
    } finally {
      setState(() => _postingComment = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.doubt.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.doubt.description),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? const Center(child: Text('No comments yet.'))
                      : ListView.builder(
                          itemCount: _comments.length,
                          itemBuilder: (context, index) {
                            final comment = _comments[index];
                            return ListTile(
                              title: Text(comment.comment),
                              subtitle: Text('User: ${comment.userId}'),
                            );
                          },
                        ),
            ),
            const Divider(),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Add a comment',
                suffixIcon: _postingComment
                    ? const Padding(
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _postComment,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
