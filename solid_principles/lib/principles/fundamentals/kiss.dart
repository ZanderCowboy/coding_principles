import 'package:solid_principles/domain/reminder.dart';

/// FUND-KISS: Keep It Simple — one straightforward formatter beats clever code.
class SimpleReminderFormatter {
  const SimpleReminderFormatter();

  String format(Reminder reminder) =>
      '${reminder.title} (due ${reminder.dueAt.toLocal()})';
}

// KISS anti-pattern (intentionally not used — shown for contrast):
//
// class OverEngineeredFormatter {
//   String format(Reminder r) => [
//         _StrategyRegistry.forType(r.runtimeType),
//         _Pipeline.of(_TitleStep(), _DateStep(), _SentStep()),
//       ].fold(r, (acc, step) => step.apply(acc));
// }

/// Runs the KISS demo.
String runKissDemo() {
  const formatter = SimpleReminderFormatter();
  final reminder = Reminder(
    id: '1',
    title: 'Water plants',
    dueAt: DateTime(2026, 6, 28, 9),
  );

  return 'Simple output:\n${formatter.format(reminder)}';
}
