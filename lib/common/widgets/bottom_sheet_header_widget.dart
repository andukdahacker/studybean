import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';

class BottomSheetHeaderWidget extends StatelessWidget {
  const BottomSheetHeaderWidget({super.key, this.title, this.action});

  final String? title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.theme.dividerColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                title ?? '',
                style: context.theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),
            if (action != null)
              Align(alignment: Alignment.centerRight, child: action!),
          ],
        ),
      ),
    );
  }
}
