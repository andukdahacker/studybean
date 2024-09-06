import 'package:flutter/material.dart';

extension ContextTheme on BuildContext {
  ThemeData get theme => Theme.of(this);

  BoxDecoration get containerDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      );
}