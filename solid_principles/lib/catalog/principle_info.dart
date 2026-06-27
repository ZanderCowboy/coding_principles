import 'package:solid_principles/principles/fundamentals/command_query_separation.dart';
import 'package:solid_principles/principles/fundamentals/dry.dart';
import 'package:solid_principles/principles/fundamentals/kiss.dart';
import 'package:solid_principles/principles/fundamentals/separation_of_concerns.dart';
import 'package:solid_principles/principles/fundamentals/yagni.dart';
import 'package:solid_principles/principles/grasp/assignment_patterns.dart';
import 'package:solid_principles/principles/grasp/change_patterns.dart';
import 'package:solid_principles/principles/grasp/coupling_cohesion.dart';
import 'package:solid_principles/principles/solid/dependency_inversion/reminder_notifier.dart';
import 'package:solid_principles/principles/solid/interface_segregation/in_memory_reminder_repository.dart';
import 'package:solid_principles/principles/solid/liskov_substitution/reliable_sender.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_controller.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_validator.dart';

/// Catalog of all principles shown in the app.
enum PrincipleSection { solid, fundamentals, grasp }

class PrincipleInfo {
  const PrincipleInfo({
    required this.id,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.interviewTips,
    required this.sourcePaths,
    required this.runDemo,
  });

  final String id;
  final PrincipleSection section;
  final String title;
  final String subtitle;
  final String summary;
  final List<String> interviewTips;
  final List<String> sourcePaths;
  final Future<String> Function() runDemo;
}

/// All principles, ordered for the home screen.
List<PrincipleInfo> buildPrincipleCatalog() {
  return [
    ..._solidPrinciples,
    ..._fundamentalPrinciples,
    ..._graspPrinciples,
  ];
}

PrincipleInfo? findPrincipleById(String id) {
  for (final principle in buildPrincipleCatalog()) {
    if (principle.id == id) {
      return principle;
    }
  }
  return null;
}

List<PrincipleInfo> principlesForSection(PrincipleSection section) {
  return buildPrincipleCatalog()
      .where((principle) => principle.section == section)
      .toList();
}

final List<PrincipleInfo> _solidPrinciples = [
  PrincipleInfo(
    id: 'solid-s',
    section: PrincipleSection.solid,
    title: 'S — Single Responsibility',
    subtitle: 'One reason to change per class',
    summary:
        'Each class should do one job. Validation, persistence, and coordination '
        'live in separate classes so a change to validation rules does not touch storage code.',
    interviewTips: [
      'A class should have only one reason to change (one actor/stakeholder).',
      'In Flutter: widgets render, controllers/blocs coordinate, repositories persist.',
      'Smaller classes are easier to test in isolation.',
    ],
    sourcePaths: [
      'lib/principles/solid/single_responsibility/reminder_validator.dart',
      'lib/principles/solid/single_responsibility/reminder_controller.dart',
    ],
    runDemo: () async =>
        '${runSingleResponsibilityDemo()}\n${runControllerDemo()}',
  ),
  PrincipleInfo(
    id: 'solid-o',
    section: PrincipleSection.solid,
    title: 'O — Open/Closed',
    subtitle: 'Open for extension, closed for modification',
    summary:
        'Add new notification channels by implementing NotificationSender without '
        'editing existing service code.',
    interviewTips: [
      'Extend behaviour with new types, not by editing stable classes.',
      'Strategy pattern is a common way to achieve this.',
      'New sender types plug in through the interface.',
    ],
    sourcePaths: [
      'lib/principles/solid/open_closed/notification_sender.dart',
    ],
    runDemo: runOpenClosedDemo,
  ),
  PrincipleInfo(
    id: 'solid-l',
    section: PrincipleSection.solid,
    title: 'L — Liskov Substitution',
    subtitle: 'Subtypes must honour the contract',
    summary:
        'Any NotificationSender can replace another. Reliable and flaky senders '
        'both return DeliveryResult — callers never need special cases.',
    interviewTips: [
      'Subclasses must be usable wherever the base type is expected.',
      'Do not surprise callers with stricter preconditions or unexpected throws.',
      'Return types and failure modes should stay predictable.',
    ],
    sourcePaths: [
      'lib/principles/solid/liskov_substitution/reliable_sender.dart',
    ],
    runDemo: runLiskovSubstitutionDemo,
  ),
  PrincipleInfo(
    id: 'solid-i',
    section: PrincipleSection.solid,
    title: 'I — Interface Segregation',
    subtitle: 'Many small interfaces beat one fat interface',
    summary:
        'Read-only clients depend on ReminderReader only. They never see write '
        'methods they do not need.',
    interviewTips: [
      'Clients should not depend on methods they do not use.',
      'Split large interfaces into focused ones (read vs write).',
      'Makes mocking in tests simpler.',
    ],
    sourcePaths: [
      'lib/principles/solid/interface_segregation/reminder_reader.dart',
      'lib/principles/solid/interface_segregation/in_memory_reminder_repository.dart',
    ],
    runDemo: runInterfaceSegregationDemo,
  ),
  PrincipleInfo(
    id: 'solid-d',
    section: PrincipleSection.solid,
    title: 'D — Dependency Inversion',
    subtitle: 'Depend on abstractions, not concretions',
    summary:
        'ReminderNotifier receives a ReminderWriter and NotificationSender '
        'through its constructor — easy to swap in tests.',
    interviewTips: [
      'High-level modules should not depend on low-level details.',
      'Both should depend on abstractions (interfaces).',
      'Constructor injection is the simplest DI to explain in interviews.',
    ],
    sourcePaths: [
      'lib/principles/solid/dependency_inversion/reminder_notifier.dart',
    ],
    runDemo: runDependencyInversionDemo,
  ),
];

final List<PrincipleInfo> _fundamentalPrinciples = [
  PrincipleInfo(
    id: 'fund-dry',
    section: PrincipleSection.fundamentals,
    title: 'DRY',
    subtitle: "Don't Repeat Yourself",
    summary:
        'Shared validation messages live in one place so wording stays consistent '
        'between the validator and the UI.',
    interviewTips: [
      'Every piece of knowledge should have a single authoritative representation.',
      'Extract duplicated logic, not just duplicated text.',
      'Balance DRY with readability — do not over-abstract.',
    ],
    sourcePaths: ['lib/principles/fundamentals/dry.dart'],
    runDemo: () async => runDryDemo(),
  ),
  PrincipleInfo(
    id: 'fund-kiss',
    section: PrincipleSection.fundamentals,
    title: 'KISS',
    subtitle: 'Keep It Simple',
    summary:
        'A one-method formatter is easier to read and maintain than a pipeline of '
        'strategies you do not need yet.',
    interviewTips: [
      'Prefer the simplest solution that solves the problem.',
      'Avoid clever abstractions until complexity demands them.',
      'Simple code is easier to review and debug.',
    ],
    sourcePaths: ['lib/principles/fundamentals/kiss.dart'],
    runDemo: () async => runKissDemo(),
  ),
  PrincipleInfo(
    id: 'fund-yagni',
    section: PrincipleSection.fundamentals,
    title: 'YAGNI',
    subtitle: "You Aren't Gonna Need It",
    summary:
        'The service only supports title and due date today. Recurrence and SMS '
        'wait for a real requirement.',
    interviewTips: [
      'Do not build features speculatively.',
      'Ship the smallest useful slice, then iterate.',
      'Unused code still costs maintenance and cognitive load.',
    ],
    sourcePaths: ['lib/principles/fundamentals/yagni.dart'],
    runDemo: () async => runYagniDemo(),
  ),
  PrincipleInfo(
    id: 'fund-soc',
    section: PrincipleSection.fundamentals,
    title: 'SoC',
    subtitle: 'Separation of Concerns',
    summary:
        'Widgets build UI. Controllers hold logic. Stores persist data. Each layer '
        'can change independently.',
    interviewTips: [
      'Split the system by concern: UI, business logic, data.',
      'Mirrors Clean Architecture presentation / domain / data layers.',
      'Enables unit testing logic without Flutter bindings.',
    ],
    sourcePaths: [
      'lib/principles/fundamentals/separation_of_concerns.dart',
      'lib/principles/solid/single_responsibility/reminder_controller.dart',
    ],
    runDemo: () async => runSeparationOfConcernsDemo(),
  ),
  PrincipleInfo(
    id: 'fund-cqs',
    section: PrincipleSection.fundamentals,
    title: 'CQS',
    subtitle: 'Command Query Separation',
    summary:
        'InMemoryReminderStore.save mutates state. findById reads state. '
        'Never combine both in one method.',
    interviewTips: [
      'Commands change state and return void (or status only).',
      'Queries return data and have no side effects.',
      'Makes reasoning about state changes much clearer.',
    ],
    sourcePaths: ['lib/principles/fundamentals/command_query_separation.dart'],
    runDemo: () async => runCommandQuerySeparationDemo(),
  ),
];

final List<PrincipleInfo> _graspPrinciples = [
  PrincipleInfo(
    id: 'grasp-assignment',
    section: PrincipleSection.grasp,
    title: 'GRASP — Who does the work?',
    subtitle: 'Information Expert, Creator, Controller',
    summary:
        'Put calculations on the data holder (Reminder.isOverdue), creation in a '
        'factory, and flow coordination in a controller.',
    interviewTips: assignmentPatternsInterviewTips,
    sourcePaths: [
      'lib/principles/grasp/assignment_patterns.dart',
      'lib/domain/reminder.dart',
    ],
    runDemo: () async => runAssignmentPatternsDemo(),
  ),
  PrincipleInfo(
    id: 'grasp-structure',
    section: PrincipleSection.grasp,
    title: 'GRASP — Healthy structure',
    subtitle: 'Low Coupling, High Cohesion',
    summary:
        'ReminderWorkflow depends on two narrow interfaces and does one cohesive job: '
        'notify all reminders.',
    interviewTips: couplingCohesionInterviewTips,
    sourcePaths: ['lib/principles/grasp/coupling_cohesion.dart'],
    runDemo: runCouplingCohesionDemo,
  ),
  PrincipleInfo(
    id: 'grasp-change',
    section: PrincipleSection.grasp,
    title: 'GRASP — Managing change',
    subtitle:
        'Pure Fabrication, Protected Variations, Polymorphism, Indirection',
    summary:
        'Fabricated stores and sender interfaces protect callers from change. '
        'Polymorphism and Indirection overlap with SOLID Open/Closed and Dependency Inversion.',
    interviewTips: changePatternsInterviewTips,
    sourcePaths: ['lib/principles/grasp/change_patterns.dart'],
    runDemo: runChangePatternsDemo,
  ),
];
