import 'task.dart';

class Status {
  final int id;
  final String title;
  final String slug;
  final int order;
  final List<Task> tasks;

  Status({
    required this.id,
    required this.title,
    required this.slug,
    required this.order,
    required this.tasks,
  });
}
