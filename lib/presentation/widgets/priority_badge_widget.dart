// priority
import 'package:flutter/material.dart';

import '../../core/utils/title_case_helper.dart';

enum Priority { low, normal, high }

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    late Color color;
    switch (priority) {
      case 'high':
        color = Colors.redAccent;
        break;
      case 'normal':
        color = Colors.orangeAccent;
        break;
      default:
        color = Colors.green;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: Text(
            TitleCaseHelper.getString(priority),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
