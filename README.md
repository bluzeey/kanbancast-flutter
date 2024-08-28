# kanbancast-flutter

Flutter library for the Kanbancast component.

[![Kanbancast Demo](https://img.youtube.com/vi/c-vy1NnB4Os/0.jpg)](https://www.youtube.com/shorts/c-vy1NnB4Os)

## Getting Started

Follow these steps to integrate the Kanbancast component into your Flutter project:

1. Get an API key:
   - Create a project on [Kanbancast.com](https://kanbancast.com)
   - Obtain the project API key from your project settings

2. Add the kanbancast-flutter package to your `pubspec.yaml`:
   ```yaml
   dependencies:
     kanbancast_flutter: ^1.0.0
   ```

3. Import the package in your Dart code:
   ```dart
   import 'package:kanbancast_flutter/kanbancast_components.dart';
   ```

4. Use the BoardView component in your widget tree:
   ```dart
   BoardView(
     projectId: 1, // Replace with your project ID
     apiKey: 'your_api_key_here', // Replace with your API key
     containerColor: Colors.black, // Optional: Customize the container color
   )
   ```

## Example

An example is also present in the `/example` directory:
