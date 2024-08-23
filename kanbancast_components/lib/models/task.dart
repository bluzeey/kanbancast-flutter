import 'comment.dart';
import 'status.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final int order;
  int? votes;
  final int statusId;
  Status? status;
  List<Comment>? comments;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.order,
    this.votes,
    required this.statusId,
    this.status,
    this.comments,
  });
}
