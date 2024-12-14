import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_dialog_extension.dart';

class ChooseCreateRoadmapMethodWidget extends StatefulWidget {
  const ChooseCreateRoadmapMethodWidget({
    super.key,
    required this.onBack,
    required this.subjectName,
    required this.goal,
    required this.onCreateRoadmapManually,
    required this.onCreateRoadmapWithAI,
    this.credits,
  });

  final VoidCallback onBack;
  final String? subjectName;
  final String? goal;
  final VoidCallback onCreateRoadmapManually;
  final VoidCallback onCreateRoadmapWithAI;
  final int? credits;

  @override
  State<ChooseCreateRoadmapMethodWidget> createState() =>
      _ChooseCreateRoadmapMethodWidgetState();
}

class _ChooseCreateRoadmapMethodWidgetState
    extends State<ChooseCreateRoadmapMethodWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => widget.onBack.call(),
            child: Row(
              children: [
                const Icon(Icons.arrow_back),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  'Back to Choose Goals & Duration',
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Create Roadmap, with AI',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Text('You can spend Credits to generate new roadmap effortlessly.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              context.showCreditDialog();
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'You have ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextSpan(
                  text: '${widget.credits} credits',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
                const WidgetSpan(
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                  ),
                )
              ]),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {
              widget.onCreateRoadmapWithAI.call();
            },
            child: const Text('Create with AI (-1 credit)'),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Or, create it manually using no Credits',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          OutlinedButton(
            onPressed: () {
              widget.onCreateRoadmapManually.call();
            },
            child: const Text('Create manually'),
          ),
        ],
      ),
    );
  }
}
