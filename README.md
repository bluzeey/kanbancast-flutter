# kanbancast_components

Flutter library for the Kanbancast component.

[![Kanbancast Demo](https://img.youtube.com/vi/c-vy1NnB4Os/0.jpg)](https://www.youtube.com/shorts/c-vy1NnB4Os)

## Getting Started

Follow these steps to integrate the Kanbancast component into your Flutter project:

1. Get an API key:
   - Create a project on [Kanbancast.com](https://kanbancast.com)
   - Obtain the project API key from your project settings

2. Add the kanbancast_components package to your project:

   With Flutter:

   ```
   $ flutter pub add kanbancast_components
   ```

   This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

   ```yaml
   dependencies:
     kanbancast_components: ^0.0.1
   ```

   Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

3. Import the package in your Dart code:
   ```dart
   import 'package:kanbancast_components/kanbancast_components.dart';
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

An example is available in the `/example` directory of the package repository.

## Tutorial
For a step-by-step tutorial on integrating the Kanbancast component in Flutter, visit our [Flutter Integration Tutorial](https://kanbancast.com/integrations/flutter).


## Changelog

For a detailed changelog, see the [CHANGELOG.md](CHANGELOG.md) file.

## Versions

For information about the latest and previous versions, visit the [package page on pub.dev](https://pub.dev/packages/kanbancast_components).

## Scores

For package scores and additional information, check the [pub.dev score page](https://pub.dev/packages/kanbancast_components/score).
