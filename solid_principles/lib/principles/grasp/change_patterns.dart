import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';

/// GRASP change patterns:
/// - Pure Fabrication: invent a class that is not in the domain model (store).
/// - Protected Variations: shield clients from change via stable interfaces.
/// - Polymorphism: vary behaviour through subtypes (see SOLID-O / [NotificationSender]).
/// - Indirection: introduce an intermediary so callers stay decoupled (see SOLID-D).
class ChangePatternsDemo {
  ChangePatternsDemo({
    InMemoryReminderStore? store,
    NotificationSender? sender,
  })  : _store = store ?? InMemoryReminderStore(),
        _sender = sender ?? PushSender();

  // Pure Fabrication — storage is not a "real world" reminder concept.
  final InMemoryReminderStore _store;

  // Protected Variations + Indirection — callers use the interface, not Push/Email.
  final NotificationSender _sender;

  Future<String> run() async {
    final reminder = Reminder(
      id: 'chg-1',
      title: 'Deploy release',
      dueAt: DateTime(2026, 6, 28, 16),
    );

    await _store.save(reminder);
    final result = await _sender.send(reminder);

    return 'Pure Fabrication: InMemoryReminderStore persists data\n'
        'Protected Variations: sender channel=${_sender.channelName}\n'
        'Polymorphism/Indirection: swap EmailSender without changing this class\n'
        'Result: ${result.message}';
  }
}

Future<String> runChangePatternsDemo() => ChangePatternsDemo().run();

const changePatternsInterviewTips = [
  'Pure Fabrication: create helper classes (repositories, mappers) not in the domain.',
  'Protected Variations: use interfaces so implementation details can change safely.',
  'Polymorphism overlaps with Open/Closed — vary behaviour via subtypes.',
  'Indirection overlaps with Dependency Inversion — depend on abstractions.',
];
