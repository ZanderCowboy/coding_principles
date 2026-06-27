import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_controller.dart';

/// GRASP assignment patterns:
/// - Information Expert: put behaviour on the class that has the data ([Reminder.isOverdue]).
/// - Creator: delegate object creation to a dedicated factory.
/// - Controller: coordinate the use case ([ReminderController]).
class ReminderFactory {
  /// GRASP-Creator: central place to construct valid [Reminder] instances.
  Reminder create({required String title, required DateTime dueAt}) {
    return Reminder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      dueAt: dueAt,
    );
  }
}

/// Runs GRASP assignment patterns demo.
String runAssignmentPatternsDemo() {
  final factory = ReminderFactory();
  final controller = ReminderController(store: InMemoryReminderStore());
  final now = DateTime(2026, 6, 28, 10);

  final overdueReminder = factory.create(
    title: 'Renew license',
    dueAt: DateTime(2026, 6, 27),
  );

  // Information Expert — Reminder decides overdue, not the controller.
  final isOverdue = overdueReminder.isOverdue(now);

  controller.saveReminder(
    factory.create(
      title: 'Stretch break',
      dueAt: DateTime(2026, 6, 28, 12),
    ),
  );

  return 'Information Expert: "${overdueReminder.title}" overdue=$isOverdue\n'
      'Creator: factory built id=${overdueReminder.id.substring(0, 6)}...\n'
      'Controller: saved count=${controller.savedCount}';
}

/// Interview cheat sheet text for the detail screen.
const assignmentPatternsInterviewTips = [
  'Information Expert: assign responsibility to the class that has the data.',
  'Creator: choose the class that creates instances (often a factory).',
  'Controller: a non-UI class coordinates a use case (like a controller or bloc).',
];
