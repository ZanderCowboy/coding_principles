/// FUND-DRY: Don't Repeat Yourself — one source of truth for shared text.
class ValidationMessages {
  static String formatEmptyTitle() => 'Title cannot be empty.';

  static String formatValidationSummary(String field, String message) =>
      '$field: $message';
}

/// Runs the DRY demo.
String runDryDemo() {
  final validatorMessage = ValidationMessages.formatEmptyTitle();
  final uiMessage = ValidationMessages.formatEmptyTitle();

  return 'Validator uses: "$validatorMessage"\n'
      'UI uses: "$uiMessage"\n'
      'Same string, one place to change.';
}
