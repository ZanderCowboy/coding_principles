/// Immutable reminder value type used across all principle demos.
///
/// GRASP — Information Expert: [Reminder] owns [isOverdue] because it holds
/// the due date. Tell, don't ask: use [markSent] instead of mutating fields
/// from outside.
class Reminder {
  const Reminder({
    required this.id,
    required this.title,
    required this.dueAt,
    this.sent = false,
  });

  final String id;
  final String title;
  final DateTime dueAt;
  final bool sent;

  // GRASP-Expert: the class with the data performs the calculation.
  bool isOverdue(DateTime now) => !sent && now.isAfter(dueAt);

  // Tell, don't ask: change state through behaviour, not external mutation.
  Reminder markSent() => Reminder(
        id: id,
        title: title,
        dueAt: dueAt,
        sent: true,
      );

  Reminder copyWith({
    String? id,
    String? title,
    DateTime? dueAt,
    bool? sent,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      sent: sent ?? this.sent,
    );
  }
}
