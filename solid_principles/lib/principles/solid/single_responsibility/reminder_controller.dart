import 'package:flutter/foundation.dart';
import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_validator.dart';

/// SOLID-S: Coordinates validation and persistence. Does not implement either.
///
/// GRASP — Controller: handles the use-case flow instead of the UI or entity.
class ReminderController extends ChangeNotifier {
  ReminderController({
    ReminderValidator? validator,
    InMemoryReminderStore? store,
  })  : _validator = validator ?? const ReminderValidator(),
        _store = store ?? InMemoryReminderStore();

  final ReminderValidator _validator;
  final InMemoryReminderStore _store;

  String? lastError;
  Reminder? lastSaved;

  /// Orchestrates validate → save. Each collaborator has a single job.
  Future<bool> saveReminder(Reminder reminder) async {
    lastError = _validator.validateReminder(reminder);
    if (lastError != null) {
      notifyListeners();
      return false;
    }

    // CQS command: mutates storage, returns nothing.
    await _store.save(reminder);
    lastSaved = reminder;
    notifyListeners();
    return true;
  }

  /// SoC: business logic lives here, not in the widget tree.
  int get savedCount => _store.count;
}

/// Runs the Single Responsibility demo including the controller.
String runControllerDemo() {
  final controller = ReminderController();
  final reminder = Reminder(
    id: '1',
    title: 'Call dentist',
    dueAt: DateTime.now().add(const Duration(hours: 2)),
  );

  // Synchronous-style demo for SnackBar text.
  controller.saveReminder(reminder);
  return 'Controller saved "${reminder.title}". '
      'Store count: ${controller.savedCount}';
}
