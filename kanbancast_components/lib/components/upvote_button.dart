import 'package:flutter/material.dart';
import 'dart:math' as math;

class UpvoteButton extends StatelessWidget {
  final int voteCount;
  final VoidCallback onUpvote;
  final bool showBorder; // New parameter to control border visibility

  const UpvoteButton({
    Key? key,
    this.voteCount = 0,
    required this.onUpvote,
    this.showBorder = true, // Default value for border visibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpvote,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: showBorder ? Border.all(color: Colors.grey) : null,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.rotate(
                angle: 270 * math.pi / 180,
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                  size: 32,
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -8),
              child: Text(
                '$voteCount',
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
