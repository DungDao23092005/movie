import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;

  const RetryButton({
    super.key,
    required this.onPressed,
    this.text = "Thử lại",
    this.icon = Icons.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(140, 45),
      ),
    );
  }
}