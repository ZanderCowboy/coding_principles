import 'package:solid_principles/domain/reminder.dart';

/// FUND-CQS: Commands change state; queries read state — never mix both.
///
/// GRASP — Pure Fabrication: an in-memory store is not a domain concept;
/// we fabricate this class to keep persistence separate from [Reminder].
class InMemoryReminderStore {
  final Map<String, Reminder> _items = {};

  /// CQS command — mutates, returns void.
  Future<void> save(Reminder reminder) async {
    _items[reminder.id] = reminder;
  }

  /// CQS query — reads, does not mutate.
  Reminder? findById(String id) => _items[id];

  /// CQS query — list all without side effects.
  List<Reminder> findAll() => List.unmodifiable(_items.values);

  /// CQS command — remove an item.
  Future<void> delete(String id) async {
    _items.remove(id);
  }

  int get count => _items.length;

  // Anti-pattern (shown in comments only — do NOT do this):
  // Reminder saveAndReturn(Reminder r) { _items[r.id] = r; return r; }
}

/// Runs the Command Query Separation demo.
String runCommandQuerySeparationDemo() {
  final store = InMemoryReminderStore();
  final reminder = Reminder(
    id: 'cqs-1',
    title: 'Pay rent',
    dueAt: DateTime(2026, 6, 28),
  );

  store.save(reminder);
  final found = store.findById('cqs-1');

  return 'After save command: count=${store.count}\n'
      'Query findById: ${found?.title ?? "not found"}';
}
