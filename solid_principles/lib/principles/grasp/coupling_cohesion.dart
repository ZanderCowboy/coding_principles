import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/solid/interface_segregation/in_memory_reminder_repository.dart';
import 'package:solid_principles/principles/solid/interface_segregation/reminder_reader.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';

/// GRASP structure patterns:
/// - Low Coupling: depend on small abstractions, not many concrete types.
/// - High Cohesion: each class does one related set of tasks.
class ReminderWorkflow {
  ReminderWorkflow({
    required ReminderReader reader,
    required NotificationSender sender,
  })  : _reader = reader,
        _sender = sender;

  // Low Coupling: only two narrow dependencies.
  final ReminderReader _reader;
  final NotificationSender _sender;

  /// High Cohesion: this method only orchestrates notify-for-all — nothing else.
  Future<String> notifyAll() async {
    final reminders = _reader.findAll();
    if (reminders.isEmpty) {
      return 'No reminders to notify.';
    }

    final results = <String>[];
    for (final reminder in reminders) {
      final result = await _sender.send(reminder);
      results.add(result.message);
    }
    return results.join('\n');
  }
}

/// Runs Low Coupling / High Cohesion demo.
Future<String> runCouplingCohesionDemo() async {
  final repository = InMemoryReminderRepository();
  await repository.save(
    Reminder(id: '1', title: 'Standup', dueAt: DateTime(2026, 6, 28, 9)),
  );

  final workflow = ReminderWorkflow(
    reader: repository,
    sender: EmailSender(),
  );

  final output = await workflow.notifyAll();
  return 'Workflow depends on Reader + Sender only (low coupling)\n$output';
}

const couplingCohesionInterviewTips = [
  'Low Coupling: classes know as little as possible about each other.',
  'High Cohesion: everything in a class belongs together.',
  'In Flutter: keep widgets thin; push logic to controllers/services.',
];
