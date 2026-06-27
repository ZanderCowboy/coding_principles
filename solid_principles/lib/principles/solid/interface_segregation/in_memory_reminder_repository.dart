import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/solid/interface_segregation/reminder_reader.dart';

/// Implements both segregated interfaces on top of the CQS store.
class InMemoryReminderRepository implements ReminderReader, ReminderWriter {
  InMemoryReminderRepository([InMemoryReminderStore? store])
      : _store = store ?? InMemoryReminderStore();

  final InMemoryReminderStore _store;

  @override
  Reminder? findById(String id) => _store.findById(id);

  @override
  List<Reminder> findAll() => _store.findAll();

  @override
  Future<void> save(Reminder reminder) => _store.save(reminder);

  @override
  Future<void> delete(String id) => _store.delete(id);
}

/// SOLID-I: Depends only on [ReminderReader] — never sees write methods.
class ReminderSummaryService {
  ReminderSummaryService(this._reader);

  final ReminderReader _reader;

  String summarizeAll() {
    final reminders = _reader.findAll();
    if (reminders.isEmpty) {
      return 'No reminders yet.';
    }
    return reminders.map((r) => '• ${r.title}').join('\n');
  }
}

/// Runs the Interface Segregation demo.
Future<String> runInterfaceSegregationDemo() async {
  final repository = InMemoryReminderRepository();
  await repository.save(
    Reminder(id: '1', title: 'Walk dog', dueAt: DateTime(2026, 6, 28, 18)),
  );
  await repository.save(
    Reminder(id: '2', title: 'Buy groceries', dueAt: DateTime(2026, 6, 29)),
  );

  // Summary service only needs ReminderReader — not ReminderWriter.
  final summary = ReminderSummaryService(repository);
  return 'Summary (read-only client):\n${summary.summarizeAll()}';
}
