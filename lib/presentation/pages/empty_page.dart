import 'package:flutter/material.dart';

class EmptyPage extends StatefulWidget {
  const EmptyPage({super.key});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hourglass_empty_outlined,
            size: 24.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          Opacity(opacity: 0.6, child: Text("Note hasn't been added yet!")),
        ],
      ),
    );
  }
}
