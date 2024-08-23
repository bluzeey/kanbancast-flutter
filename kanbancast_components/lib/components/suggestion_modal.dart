import 'package:flutter/material.dart';
import '../service/project_service.dart';

class SuggestionModal extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final ProjectService projectService; // Add the ProjectService instance
  final Function(Map<String, dynamic>) onTaskCreated; // Callback to update UI

  const SuggestionModal({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.projectService,
    required this.onTaskCreated,
  }) : super(key: key);

  void handleSubmit(BuildContext context) async {
    try {
      final newTask = await projectService.submitNewTask(
        titleController.text,
        descriptionController.text,
      );

      // Call the onTaskCreated callback to update the UI with the new task
      onTaskCreated(newTask);

      // Clear the input fields
      titleController.clear();
      descriptionController.clear();

      // Close the modal
      Navigator.pop(context);
    } catch (error) {
      // Handle any errors during the submission
      print('Failed to submit task: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Suggest a Feature',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(fontSize: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0, // Minimal vertical padding
              ),
            ),
            style: TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(fontSize: 14.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0, // Minimal vertical padding
              ),
            ),
            maxLines: 3,
            style: TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => handleSubmit(context),
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              primary: Colors.blueAccent, // Button background color
              onPrimary: Colors.white, // Text color
              textStyle:
                  const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
