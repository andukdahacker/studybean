import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

class ActionWidget extends StatefulWidget {
  const ActionWidget({
    super.key,
    required this.action,
    required this.onTap,
    required this.onLongPress,
    required this.onMarkAsComplete,
  });

  final MilestoneAction action;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMarkAsComplete;

  @override
  State<ActionWidget> createState() => _ActionWidgetState();
}

class _ActionWidgetState extends State<ActionWidget> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _key,
      onTap: () {
        widget.onTap();
      },
      onLongPress: () {
        widget.onLongPress();
      },
      child: Container(
        decoration: context.containerDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.action.name,
                      style: context.theme.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Checkbox(
                      value: widget.action.completed,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        widget.onMarkAsComplete();
                      })
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Estimated time: ${widget.action.duration} ${widget.action.durationUnit.value}',
                style: context.theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.action.description ?? '',
                style: context.theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
