class Comment {
  final int id;
  final String content;
  int votes;
  final int taskId;

  Comment({
    required this.id,
    required this.content,
    required this.votes,
    required this.taskId,
  });
}
