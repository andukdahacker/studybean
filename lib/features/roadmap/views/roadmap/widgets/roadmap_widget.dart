import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studybean/common/extensions/context_theme.dart';

import '../../../models/roadmap.dart';

class RoadmapWidget extends StatefulWidget {
  const RoadmapWidget({super.key, required this.roadmap});

  final Roadmap roadmap;

  @override
  State<RoadmapWidget> createState() => _RoadmapWidgetState();
}

class _RoadmapWidgetState extends State<RoadmapWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/home/roadmap/${widget.roadmap.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.roadmap.subject?.name ?? '',
                    style: context.theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Icon(Icons.outlined_flag_rounded),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    '${widget.roadmap.milestones?.length ?? 0} milestone${(widget.roadmap.milestones?.length ?? 0) > 1 ? 's' : ''}',
                    style: context.theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  const Icon(Icons.call_to_action),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      widget.roadmap.goal,
                      style: context.theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
