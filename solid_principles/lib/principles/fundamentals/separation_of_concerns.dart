import 'package:flutter/material.dart';
import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_controller.dart';

/// FUND-SoC: Separation of Concerns — UI renders; controller owns logic.
///
/// This widget only builds UI and forwards events. It does not validate or
/// persist reminders itself.
class ReminderForm extends StatelessWidget {
  const ReminderForm({
    required this.controller,
    required this.onSubmit,
    super.key,
  });

  final ReminderController controller;
  final void Function(String title) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Reminder title',
            errorText: controller.lastError,
          ),
          onSubmitted: onSubmit,
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => onSubmit('Demo reminder'),
          child: const Text('Add reminder'),
        ),
      ],
    );
  }
}

/// Logic-only demo — testable without [WidgetTester].
String runSeparationOfConcernsDemo() {
  final controller = ReminderController();
  final reminder = Reminder(
    id: 'soc-1',
    title: '',
    dueAt: DateTime.now(),
  );

  controller.saveReminder(reminder);
  return 'Widget layer: builds TextField + Button only\n'
      'Controller layer: validation error = "${controller.lastError}"';
}
