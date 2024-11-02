import 'package:flutter/material.dart';
import 'package:studybean/common/extensions/context_theme.dart';
import 'package:studybean/features/roadmap/models/duration_unit.dart';

class ChooseGoalsDurationWidget extends StatefulWidget {
  const ChooseGoalsDurationWidget({
    super.key,
    required this.onBack,
    required this.onDurationChanged,
    required this.selectedGoalDuration,
    required this.selectedGoalDurationUnit,
    required this.goal,
    required this.onGoalChanged,
    required this.onNext,
    required this.subjectName,
  });

  final VoidCallback onBack;
  final Function(int, DurationUnit) onDurationChanged;
  final int selectedGoalDuration;
  final DurationUnit selectedGoalDurationUnit;
  final Function(String) onGoalChanged;
  final String? goal;
  final VoidCallback onNext;
  final String? subjectName;

  @override
  State<ChooseGoalsDurationWidget> createState() =>
      _ChooseGoalsDurationWidgetState();
}

class _ChooseGoalsDurationWidgetState extends State<ChooseGoalsDurationWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _goalController;
  late final TextEditingController _durationController;

  final _goalFocusNode = FocusNode();
  final _durationFocusNode = FocusNode();

  bool _keyboardVisible = false;

  @override
  void initState() {
    _goalController = TextEditingController()..text = widget.goal ?? '';
    _durationController = TextEditingController()
      ..text = widget.selectedGoalDuration.toString();
    _goalFocusNode.addListener(() {
      setState(() {
        _keyboardVisible = _goalFocusNode.hasFocus;
      });
    });

    _durationFocusNode.addListener(() {
      setState(() {
        _keyboardVisible = _durationFocusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _goalController.dispose();
    _durationController.dispose();
    _goalFocusNode.dispose();
    _durationFocusNode.dispose();
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
                    _durationFocusNode.requestFocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please insert your study goals here.';
                    }

                    return null;
                  },
                  controller: _goalController,
                  onChanged: (value) {
                    widget.onGoalChanged.call(value);
                  },
                  decoration: const InputDecoration()
                      .applyDefaults(context.theme.inputDecorationTheme)
                      .copyWith(
                        hintText: 'Take a test, acquire a new skill, ...',
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'and I must achieve it within...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _durationFocusNode,
                        controller: _durationController,
                        onChanged: (value) {
                          if (value.isEmpty) return;
                          widget.onDurationChanged.call(
                            int.parse(value),
                            widget.selectedGoalDurationUnit,
                          );
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration()
                            .applyDefaults(context.theme.inputDecorationTheme)
                            .copyWith(
                              hintText: '3',
                            ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownMenu<DurationUnit>(
                        initialSelection: widget.selectedGoalDurationUnit,
                        onSelected: (unit) {
                          if (unit == null) return;

                          widget.onDurationChanged.call(
                            int.parse(_durationController.text),
                            unit,
                          );
                        },
                        dropdownMenuEntries: DurationUnit.values
                            .map(
                              (e) => DropdownMenuEntry<DurationUnit>(
                                value: e,
                                label: e.name,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox.shrink())
                  ],
                ),
              ],
            ),
          ),
        ),
        if (!_keyboardVisible)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (!(_formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  widget.onDurationChanged.call(
                    int.parse(_durationController.text),
                    widget.selectedGoalDurationUnit,
                  );

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
