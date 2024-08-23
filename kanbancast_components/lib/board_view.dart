import 'package:flutter/material.dart';
import 'service/project_service.dart'; // Import the service
import 'components/status_buttons.dart'; // Import the new component
import 'components/upvote_button.dart';
import 'components/comments_section.dart'; // Import the upvote button component
import 'components/suggestion_modal.dart'; // Import the suggestion modal component

class BoardView extends StatefulWidget {
  final int projectId;
  final String apiKey;
  final Color containerColor;

  const BoardView({
    Key? key,
    this.projectId = 1,
    this.apiKey = "arwn30IP3lx3",
    this.containerColor = Colors.black,
  }) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  late ProjectService projectService;
  List<dynamic> statuses = [];
  String selectedTab = "Active";
  Map<int, bool> showComments =
      {}; // Track which tasks have their comments visible
  String commentContent = "";
  final TextEditingController commentController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    projectService = ProjectService(apiKey: widget.apiKey);
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      statuses = await projectService.fetchStatuses();
      setState(() {
        print(statuses);
      });
    } catch (error) {
      // Handle error, show a message, etc.
      print("Failed to load statuses: $error");
    }
  }

  List<dynamic> get tasksForSelectedTab {
    const requestedStatus = ["Requested"];
    const activeStatuses = ["To Do", "In Progress", "Pending", "Review"];
    const doneStatuses = ["Done", "Published"];

    final relevantStatuses = selectedTab == "Active"
        ? activeStatuses
        : selectedTab == "Done"
            ? doneStatuses
            : requestedStatus;

    return statuses
        .where((status) => relevantStatuses.contains(status['title']))
        .expand((status) => (status['tasks'] as List<dynamic>)
            .map((task) => {...task, 'status': status}))
        .toList();
  }

  void handleTabChanged(int index) {
    setState(() {
      if (index == 0) {
        selectedTab = "Requested";
      } else if (index == 1) {
        selectedTab = "Active";
      } else if (index == 2) {
        selectedTab = "Done";
      }
    });
  }

  void toggleComments(int taskId) {
    setState(() {
      showComments[taskId] = !(showComments[taskId] ?? false);
    });
  }

  void handleCommentChange(String value) {
    setState(() {
      commentContent = value;
    });
  }

  Future<void> voteTask(int taskId) async {
    try {
      int newVotes = await projectService.upvoteTask(taskId);

      setState(() {
        for (var status in statuses) {
          for (var task in status['tasks']) {
            if (task['id'] == taskId) {
              task['votes'] = newVotes;
              break;
            }
          }
        }
      });
    } catch (error) {
      // Handle any errors that occur during the upvote process
      print('Failed to upvote task: $error');
    }
  }

  void handleUpvoteComment(int commentId) async {
    try {
      int newVotes = await projectService.upvoteComment(commentId);
      setState(() {
        // Update the specific comment's vote count in your state
        for (var status in statuses) {
          for (var task in status['tasks']) {
            for (var comment in task['comments']) {
              if (comment['id'] == commentId) {
                comment['votes'] = newVotes;
                break;
              }
            }
          }
        }
      });
    } catch (error) {
      // Handle any errors that occur during the upvote process
      print('Failed to upvote comment: $error');
    }
  }

  Future<void> handleSubmitNewComment(int taskId) async {
    try {
      final newComment =
          await projectService.submitNewComment(taskId, commentContent);
      setState(() {
        // Add the new comment to the task's comments list
        final task =
            tasksForSelectedTab.firstWhere((task) => task['id'] == taskId);
        task['comments'].add(newComment);
        commentContent = ''; // Clear the comment content
      });
    } catch (error) {
      // Handle any errors that occur during the comment submission process
      print('Failed to submit comment: $error');
    }
  }

  void handleNewTaskSubmission(Map<String, dynamic> newTask) {
    setState(() {
      // Find the "Requested" status
      final requestedStatus = statuses
          .firstWhere((status) => status['title'].toLowerCase() == 'requested');
      // Add the new task to the "Requested" status
      requestedStatus['tasks'].add(newTask);
    });
  }

  void _showFeatureSuggestionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return SuggestionModal(
          titleController: titleController,
          descriptionController: descriptionController,
          projectService: projectService,
          onTaskCreated: handleNewTaskSubmission, // Callback to update UI
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
        body: Column(
          children: [
            StatusToggleButtons(
              selectedIndex: selectedTab == "Requested"
                  ? 0
                  : selectedTab == "Active"
                      ? 1
                      : 2,
              onTabChanged: handleTabChanged,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasksForSelectedTab.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: tasksForSelectedTab.length,
                      itemBuilder: (context, index) {
                        final task = tasksForSelectedTab[index];
                        final commentCount = task['comments']?.length ?? 0;
                        final commentsVisible =
                            showComments[task['id']] == true;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  UpvoteButton(
                                    voteCount: task['votes'] ?? 0,
                                    onUpvote: () {
                                      voteTask(task['id']);
                                    },
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task['title'],
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          task['description'] ?? '',
                                          style:
                                              const TextStyle(fontSize: 14.0),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              toggleComments(task['id']),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${commentsVisible
                                                        ? 'Hide Comments'
                                                        : 'Show Comments'} ($commentCount)',
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                              Icon(
                                                commentsVisible
                                                    ? Icons.expand_less
                                                    : Icons.expand_more,
                                                color: Colors.blueAccent,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              if (commentsVisible) ...[
                                CommentsSection(
                                  comments: task['comments'] ?? [],
                                  onCommentChange: handleCommentChange,
                                  onSubmitComment: () =>
                                      handleSubmitNewComment(task['id']),
                                  commentContent: commentContent,
                                  onUpvoteComment: handleUpvoteComment,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showFeatureSuggestionModal(context),
          backgroundColor: Colors.blueAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
