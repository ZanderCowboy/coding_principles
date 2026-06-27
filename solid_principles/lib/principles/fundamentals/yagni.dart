import 'package:solid_principles/domain/reminder.dart';

/// FUND-YAGNI: You Aren't Gonna Need It — ship only what is needed today.
///
/// Supports title + due date only. No recurrence, SMS, or attachments until
/// a real requirement appears.
class MinimalReminderService {
  Reminder create({required String title, required DateTime dueAt}) {
    return Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      dueAt: dueAt,
    );
  }

  // YAGNI — not built yet:
  // Reminder createRecurring({required RecurrenceRule rule}) { ... }
  // void sendSms(Reminder reminder) { ... }
}

/// Runs the YAGNI demo.
String runYagniDemo() {
  final service = MinimalReminderService();
  final reminder = service.create(
    title: 'Pick up parcel',
    dueAt: DateTime(2026, 6, 28, 17),
  );

  return 'Built today: title + due date only\n'
      'Created: "${reminder.title}" due ${reminder.dueAt.toLocal()}\n'
      'Not built: recurrence, SMS, attachments (YAGNI)';
}
