import 'package:solid_principles/domain/reminder.dart';

/// SOLID-I: Read-only contract — clients that only read don't need write methods.
abstract class ReminderReader {
  Reminder? findById(String id);

  List<Reminder> findAll();
}

/// SOLID-I: Write-only contract — separate from reading.
abstract class ReminderWriter {
  Future<void> save(Reminder reminder);

  Future<void> delete(String id);
}
