import 'package:flutter/material.dart';

class RecordingHeaderWidget extends StatelessWidget {
  const RecordingHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.mic,
          size: 64,
          color: Colors.black,
        ),
        SizedBox(height: 16),
        Text(
          "Record your audio",
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Record your audio with high quality.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
