import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/fundamentals/dry.dart';
import 'package:solid_principles/principles/grasp/assignment_patterns.dart';
import 'package:solid_principles/principles/solid/dependency_inversion/reminder_notifier.dart';
import 'package:solid_principles/principles/solid/interface_segregation/in_memory_reminder_repository.dart';
import 'package:solid_principles/principles/solid/interface_segregation/reminder_reader.dart';
import 'package:solid_principles/principles/solid/liskov_substitution/reliable_sender.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_controller.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SOLID', () {
    test('S — validator rejects empty title', () {
      const validator = ReminderValidator();

      expect(validator.validateTitle(''), ValidationMessages.formatEmptyTitle());
      expect(validator.validateTitle('Buy milk'), isNull);
    });

    test('O — new sender without changing ReminderNotificationService', () async {
      final reminder = Reminder(
        id: '1',
        title: 'Demo',
        dueAt: DateTime(2026, 6, 28),
      );

      final smsResult = await ReminderNotificationService(_SmsSender()).notify(
        reminder,
      );

      expect(smsResult.success, isTrue);
      expect(smsResult.message, contains('SMS'));
    });

    test('L — flaky sender is substitutable', () async {
      final reminder = Reminder(
        id: '1',
        title: 'Demo',
        dueAt: DateTime(2026, 6, 28),
      );

      Future<DeliveryResult> deliver(NotificationSender sender) =>
          sender.send(reminder);

      final reliable = await deliver(ReliableSender());
      final flaky = await deliver(FlakySender());

      expect(reliable.success, isTrue);
      expect(flaky.success, isFalse);
    });

    test('I — summary service depends on ReminderReader only', () async {
      final repository = InMemoryReminderRepository();
      await repository.save(
        Reminder(id: '1', title: 'One', dueAt: DateTime(2026, 6, 28)),
      );

      ReminderReader reader = repository;
      final summary = ReminderSummaryService(reader);

      expect(summary.summarizeAll(), contains('One'));
    });

    test('D — notifier works with injected dependencies', () async {
      final repository = InMemoryReminderRepository();
      final notifier = ReminderNotifier(
        writer: repository,
        sender: EmailSender(),
      );

      final message = await notifier.createAndNotify(
        Reminder(id: '1', title: 'Timesheet', dueAt: DateTime(2026, 6, 30)),
      );

      expect(message, contains('Email sent'));
      expect(repository.findById('1')?.title, 'Timesheet');
    });
  });

  group('Fundamentals', () {
    test('DRY — shared formatter message', () {
      expect(
        ValidationMessages.formatEmptyTitle(),
        ValidationMessages.formatEmptyTitle(),
      );
    });

    test('CQS — save mutates, findById reads without mutation', () async {
      final store = InMemoryReminderStore();
      final reminder = Reminder(
        id: '1',
        title: 'Rent',
        dueAt: DateTime(2026, 6, 28),
      );

      expect(store.count, 0);
      await store.save(reminder);
      expect(store.count, 1);

      final found = store.findById('1');
      expect(found?.title, 'Rent');
      expect(store.count, 1);
    });

    test('SoC — controller logic testable without widgets', () async {
      final controller = ReminderController();
      final saved = await controller.saveReminder(
        Reminder(id: '1', title: '', dueAt: DateTime(2026, 6, 28)),
      );

      expect(saved, isFalse);
      expect(controller.lastError, isNotNull);
    });
  });

  group('GRASP', () {
    test('Information Expert — Reminder decides overdue', () {
      final reminder = Reminder(
        id: '1',
        title: 'License',
        dueAt: DateTime(2026, 6, 27),
      );

      expect(reminder.isOverdue(DateTime(2026, 6, 28)), isTrue);
    });

    test('Creator — factory builds valid reminder', () {
      final factory = ReminderFactory();
      final reminder = factory.create(
        title: 'Stretch',
        dueAt: DateTime(2026, 6, 28, 12),
      );

      expect(reminder.title, 'Stretch');
      expect(reminder.id, isNotEmpty);
    });
  });
}

/// Test-only sender proving Open/Closed — no edits to [ReminderNotificationService].
class _SmsSender implements NotificationSender {
  @override
  String get channelName => 'sms';

  @override
  Future<DeliveryResult> send(Reminder reminder) async {
    return DeliveryResult(
      success: true,
      message: 'SMS sent for "${reminder.title}".',
    );
  }
}
