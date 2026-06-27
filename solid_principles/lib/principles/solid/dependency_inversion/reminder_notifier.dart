import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/solid/interface_segregation/in_memory_reminder_repository.dart';
import 'package:solid_principles/principles/solid/interface_segregation/reminder_reader.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';

/// SOLID-D: High-level flow depends on abstractions, not concrete classes.
///
/// Manual constructor injection — production Multichoice uses injectable in core.
class ReminderNotifier {
  ReminderNotifier({
    required ReminderWriter writer,
    required NotificationSender sender,
  })  : _writer = writer,
        _sender = sender;

  final ReminderWriter _writer;
  final NotificationSender _sender;

  Future<String> createAndNotify(Reminder reminder) async {
    await _writer.save(reminder);
    final result = await _sender.send(reminder);
    return result.message;
  }
}

/// Runs the Dependency Inversion demo with injected fakes.
Future<String> runDependencyInversionDemo() async {
  final repository = InMemoryReminderRepository();
  final notifier = ReminderNotifier(
    writer: repository,
    sender: EmailSender(),
  );

  final message = await notifier.createAndNotify(
    Reminder(
      id: 'dip-1',
      title: 'Submit timesheet',
      dueAt: DateTime(2026, 6, 30),
    ),
  );

  return 'Notifier result: $message';
}
