import 'package:solid_principles/domain/reminder.dart';

/// SOLID-O: Open for extension (new senders), closed for modification.
abstract class NotificationSender {
  String get channelName;

  Future<DeliveryResult> send(Reminder reminder);
}

class DeliveryResult {
  const DeliveryResult({required this.success, required this.message});

  final bool success;
  final String message;
}

class EmailSender implements NotificationSender {
  @override
  String get channelName => 'email';

  @override
  Future<DeliveryResult> send(Reminder reminder) async {
    return DeliveryResult(
      success: true,
      message: 'Email sent for "${reminder.title}".',
    );
  }
}

class PushSender implements NotificationSender {
  @override
  String get channelName => 'push';

  @override
  Future<DeliveryResult> send(Reminder reminder) async {
    return DeliveryResult(
      success: true,
      message: 'Push notification sent for "${reminder.title}".',
    );
  }
}

/// Extend behaviour by adding new [NotificationSender] types — no edits here.
class ReminderNotificationService {
  ReminderNotificationService(this._sender);

  final NotificationSender _sender;

  Future<DeliveryResult> notify(Reminder reminder) => _sender.send(reminder);
}

/// Runs the Open/Closed demo with email, then push.
Future<String> runOpenClosedDemo() async {
  final reminder = Reminder(
    id: '1',
    title: 'Team standup',
    dueAt: DateTime.now(),
  );

  final emailResult =
      await ReminderNotificationService(EmailSender()).notify(reminder);
  final pushResult =
      await ReminderNotificationService(PushSender()).notify(reminder);

  return 'Email: ${emailResult.message}\nPush: ${pushResult.message}';
}
