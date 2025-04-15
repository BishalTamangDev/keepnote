import 'package:flutter/material.dart';

class ViewErrorPage extends StatelessWidget {
  const ViewErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text("An error occurred!")],
        ),
      ),
    );
  }
}
