import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';

class MilestoneDotWidget extends StatelessWidget {
  const MilestoneDotWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.primaryContainer,
          ),
        ),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
