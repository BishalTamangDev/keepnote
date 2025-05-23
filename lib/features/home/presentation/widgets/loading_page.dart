import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../shared/custom_widgets/custom_text_widget.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Lottie.asset('assets/animations/loading.json', width: 75.0),
              const CustomTextWidget(text: "Fetching Your Notes", opacity: 0.7),
            ],
          ),
        ],
      ),
    );
  }
}
