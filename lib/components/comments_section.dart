import 'package:flutter/material.dart';
import 'upvote_button.dart'; // Import the UpvoteButton component

class CommentsSection extends StatefulWidget {
  final List<dynamic> comments;
  final Function(String) onCommentChange;
  final Future<void> Function() onSubmitComment; // Updated to be async
  final String commentContent;
  final Function(int) onUpvoteComment; // Callback for upvoting a comment

  const CommentsSection({
    Key? key,
    required this.comments,
    required this.onCommentChange,
    required this.onSubmitComment,
    required this.commentContent,
    required this.onUpvoteComment, // Add the onUpvoteComment callback
  }) : super(key: key);

  @override
  _CommentsSectionState createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  late TextEditingController _commentController;
  late List<dynamic> _comments; // Local copy of comments to update UI

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _comments = List.from(widget.comments); // Initialize with existing comments
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    try {
      await widget.onSubmitComment(); // Await the submission
      setState(() {
        _comments.add({
          'content': widget.commentContent,
          'votes': 0,
        }); // Add the new comment to the local list
        _commentController.clear(); // Clear the input field
      });
    } catch (error) {
      print('Failed to submit comment: $error'); // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Column(
          children: _comments
              .map<Widget>(
                (comment) => ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment['content'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      UpvoteButton(
                        voteCount: comment['votes'] ?? 0,
                        onUpvote: () => widget.onUpvoteComment(comment['id']),
                        showBorder:
                            false, // Optional: No border for comment upvote button
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        const Divider(),
        TextFormField(
          controller: _commentController,
          onChanged: widget.onCommentChange,
          decoration: InputDecoration(
            hintText: 'Add a comment',
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          ),
          style: const TextStyle(fontSize: 14.0),
        ),
        const SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueAccent, padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0), // Text color
            textStyle:
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5.0, // Shadow effect
          ), // Use the internal submit handler
          child: const Text('Post'),
        ),
      ],
    );
  }
}
