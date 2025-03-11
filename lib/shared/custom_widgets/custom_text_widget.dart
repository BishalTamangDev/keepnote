import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({
    super.key,
    required this.text,
    this.type = 'body',
    this.opacity = 1,
    this.maxLines = 100,
  });

  final String text;
  final double opacity;
  final String type;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'title':
        return Opacity(
          opacity: opacity,
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case 'label':
        return Opacity(
          opacity: opacity,
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        );
      default:
        return Opacity(
          opacity: opacity,
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        );
    }
  }
}
