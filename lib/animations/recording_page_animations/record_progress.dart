import 'dart:async';
import 'package:flutter/material.dart';

class DotsLoadingIndicator extends StatefulWidget {
  const DotsLoadingIndicator({Key? key}) : super(key: key);

  @override
  _DotsLoadingIndicatorState createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<DotsLoadingIndicator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedDot(0),
            const SizedBox(width: 8),
            _buildAnimatedDot(1),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedDot(2),
            const SizedBox(width: 8),
            _buildAnimatedDot(3),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _currentIndex == index ? 14 : 12,
      width: _currentIndex == index ? 14 : 12,
      decoration: BoxDecoration(
        color: _currentIndex == index ? const Color(0xFF3478F6) : Colors.grey.shade400,
        shape: BoxShape.circle,
      ),
    );
  }
}
