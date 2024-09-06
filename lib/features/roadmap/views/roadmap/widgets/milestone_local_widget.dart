import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/roadmap.dart';

class MilestoneLocalWidget extends StatelessWidget {
  const MilestoneLocalWidget(
      {super.key, required this.milestone, required this.onTap});

  final Milestone milestone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: context.containerDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      milestone.name,
                      style: context.theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                milestone.durationText,
                style: context.theme.textTheme.bodyMedium,
              ),
              const SizedBox(
                height: 8,
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final action = milestone.actions![index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: action.completed
                              ? context.theme.colorScheme.primary
                              : Colors.grey,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: Text(
                          action.name,
                          style: context.theme.textTheme.bodyMedium?.copyWith(
                              decoration: action.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                              decorationColor: action.completed
                                  ? context.theme.colorScheme.primary
                                  : Colors.grey),
                        )),
                      ],
                    );
                  },
                  itemCount: milestone.actions?.length ?? 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
