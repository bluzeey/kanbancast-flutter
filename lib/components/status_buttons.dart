import 'package:flutter/material.dart';

class StatusToggleButtons extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const StatusToggleButtons({
    Key? key,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ToggleButtons(
        isSelected: [
          selectedIndex == 0,
          selectedIndex == 1,
          selectedIndex == 2,
        ],
        onPressed: (int index) {
          onTabChanged(index);
        },
        borderRadius: BorderRadius.circular(8.0),
        fillColor: Colors.blueAccent,
        selectedColor: Colors.white,
        color: Colors.black,
        constraints: BoxConstraints(
          minHeight: 40.0,
          minWidth: MediaQuery.of(context).size.width / 3.5,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Requested",
              style: TextStyle(
                fontWeight:
                    selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Active",
              style: TextStyle(
                fontWeight:
                    selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Done",
              style: TextStyle(
                fontWeight:
                    selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
