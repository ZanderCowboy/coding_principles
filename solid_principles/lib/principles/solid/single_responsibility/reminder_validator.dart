import 'package:solid_principles/domain/reminder.dart';
import 'package:solid_principles/principles/fundamentals/dry.dart';

/// SOLID-S: Validates reminder input only. One reason to change: validation rules.
class ReminderValidator {
  const ReminderValidator();
  String? validateTitle(String title) {
    if (title.trim().isEmpty) {
      // FUND-DRY: shared message used by UI and validator.
      return ValidationMessages.formatEmptyTitle();
    }
    if (title.length > 80) {
      return 'Title must be 80 characters or fewer.';
    }
    return null;
  }

  String? validateReminder(Reminder reminder) => validateTitle(reminder.title);
}

/// Runs the Single Responsibility demo.
String runSingleResponsibilityDemo() {
  const validator = ReminderValidator();

  final emptyResult = validator.validateTitle('');
  final validResult = validator.validateTitle('Buy milk');

  return 'Empty title: ${emptyResult ?? "ok"}\n'
      'Valid title: ${validResult ?? "ok"}';
}
