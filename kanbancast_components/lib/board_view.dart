import 'package:flutter/material.dart';
import 'service/project_service.dart'; // Import the service

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

  void submitNewComment(int taskId) {
    // Logic to submit new comment goes here
    print("Submitting comment for task $taskId: $commentContent");
    setState(() {
      // Add logic to handle the submission of the new comment
      commentContent = ""; // Clear the input after submitting
    });
  }

  void voteTask(int taskId) {
    // Increment vote count for the task (this should be updated with your actual logic)
    setState(() {
      final task =
          tasksForSelectedTab.firstWhere((task) => task['id'] == taskId);
      task['votes'] = (task['votes'] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              isSelected: [
                selectedTab == "Requested",
                selectedTab == "Active",
                selectedTab == "Done",
              ],
              onPressed: (int index) {
                handleTabChanged(index);
              },
              borderRadius: BorderRadius.circular(8.0),
              fillColor: Colors.blueAccent,
              selectedColor: Colors.white,
              color: Colors.black,
              constraints: BoxConstraints(
                minHeight: 40.0,
                minWidth: MediaQuery.of(context).size.width / 3.5,
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Requested"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Active"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Done"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: tasksForSelectedTab.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: tasksForSelectedTab.length,
                    itemBuilder: (context, index) {
                      final task = tasksForSelectedTab[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_upward),
                                        color: Colors.blueAccent,
                                        onPressed: () {
                                          voteTask(task['id']);
                                        },
                                      ),
                                      Text(
                                        '${task['votes'] ?? 0}',
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
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
                                        style: const TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(showComments[task['id']] == true
                                      ? Icons.expand_less
                                      : Icons.expand_more),
                                  onPressed: () => toggleComments(task['id']),
                                ),
                              ],
                            ),
                            if (showComments[task['id']] == true) ...[
                              const Divider(),
                              Column(
                                children: task['comments']
                                        ?.map<Widget>(
                                          (comment) => ListTile(
                                            title: Text(comment['content']),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                              ),
                              const Divider(),
                              TextField(
                                onChanged: handleCommentChange,
                                decoration: InputDecoration(
                                  hintText: 'Add a comment',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                controller:
                                    TextEditingController(text: commentContent),
                              ),
                              const SizedBox(height: 8.0),
                              ElevatedButton(
                                onPressed: () => submitNewComment(task['id']),
                                child: const Text('Post'),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
