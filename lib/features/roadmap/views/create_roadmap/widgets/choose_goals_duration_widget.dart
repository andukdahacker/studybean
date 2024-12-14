import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';

class DescribeGoalsWidget extends StatefulWidget {
  const DescribeGoalsWidget({
    super.key,
    required this.onBack,
    required this.goal,
    required this.onGoalChanged,
    required this.onNext,
    required this.subjectName,
  });

  final VoidCallback onBack;
  final Function(String) onGoalChanged;
  final String? goal;
  final VoidCallback onNext;
  final String? subjectName;

  @override
  State<DescribeGoalsWidget> createState() =>
      _DescribeGoalsWidgetState();
}

class _DescribeGoalsWidgetState extends State<DescribeGoalsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _goalController;

  final _goalFocusNode = FocusNode();


  @override
  void initState() {
    _goalController = TextEditingController()..text = widget.goal ?? '';

    super.initState();
  }

  @override
  void dispose() {
    _goalController.dispose();
    _goalFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
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
                        'Back to Choose Subject',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Choose a Study Goal and Duration',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'I am studying ${widget.subjectName ?? ''} to...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  focusNode: _goalFocusNode,
                  onEditingComplete: () {
                    _formKey.currentState?.validate();
                    _goalFocusNode.unfocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert your study goals here.';
                    }

                    return null;
                  },
                  controller: _goalController,
                  minLines: 3,
                  maxLines: 10,
                  onChanged: (value) {
                    widget.onGoalChanged.call(value);
                  },
                  decoration: const InputDecoration()
                      .applyDefaults(context.theme.inputDecorationTheme)
                      .copyWith(
                        hintText: 'Take a test, acquire a new skill, ...',
                      ),
                ),
              ],
            ),
          ),
        ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  widget.onNext.call();
                },
                child: const Text('Next'),
              ),
            ),
          ),
      ]),
    );
  }
}
