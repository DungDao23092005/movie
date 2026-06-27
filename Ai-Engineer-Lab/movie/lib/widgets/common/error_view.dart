import 'package:flutter/material.dart';

import 'retry_button.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  final String title;

  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.title = "Đã xảy ra lỗi",
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 72,
              color: Colors.red,
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 12),

            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 24),

            RetryButton(
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}