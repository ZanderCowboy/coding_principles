import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';

/// SOLID-L: Reliable subtype — always returns a [DeliveryResult], never surprises callers.
class ReliableSender implements NotificationSender {
  @override
  String get channelName => 'reliable';

  @override
  Future<DeliveryResult> send(Reminder reminder) async {
    return DeliveryResult(
      success: true,
      message: 'Reliably delivered "${reminder.title}".',
    );
  }
}

/// SOLID-L: Flaky but still substitutable — fails gracefully, same contract.
class FlakySender implements NotificationSender {
  @override
  String get channelName => 'flaky';

  @override
  Future<DeliveryResult> send(Reminder reminder) async {
    return const DeliveryResult(
      success: false,
      message: 'Network timeout — will retry later.',
    );
  }
}

/// Caller works with any [NotificationSender] — Liskov Substitution.
Future<String> runLiskovSubstitutionDemo() async {
  final reminder = Reminder(
    id: '1',
    title: 'Doctor appointment',
    dueAt: DateTime.now(),
  );

  Future<DeliveryResult> deliver(NotificationSender sender) =>
      sender.send(reminder);

  final reliable = await deliver(ReliableSender());
  final flaky = await deliver(FlakySender());

  return 'Reliable: success=${reliable.success}, ${reliable.message}\n'
      'Flaky: success=${flaky.success}, ${flaky.message}';
}
