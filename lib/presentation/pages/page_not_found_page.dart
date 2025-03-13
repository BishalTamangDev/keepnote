import 'package:flutter/material.dart';

class PageNotFoundPage extends StatelessWidget {
  const PageNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 24.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.05),
              child: Icon(
                Icons.hourglass_empty,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Opacity(opacity: 0.5, child: Text("Page Not Found!")),
          ],
        ),
      ),
    );
  }
}
