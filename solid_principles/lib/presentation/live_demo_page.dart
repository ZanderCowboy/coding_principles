import 'package:flutter/material.dart';
import 'package:solid_principles/principles/grasp/assignment_patterns.dart';
import 'package:solid_principles/principles/solid/dependency_inversion/reminder_notifier.dart';
import 'package:solid_principles/principles/solid/interface_segregation/in_memory_reminder_repository.dart';
import 'package:solid_principles/principles/solid/open_closed/notification_sender.dart';
import 'package:solid_principles/principles/solid/single_responsibility/reminder_controller.dart';

enum _NotifyChannel { email, push }

/// Live demo wiring SOLID pieces together: validate → save → notify.
class LiveDemoPage extends StatefulWidget {
  const LiveDemoPage({super.key});

  @override
  State<LiveDemoPage> createState() => _LiveDemoPageState();
}

class _LiveDemoPageState extends State<LiveDemoPage> {
  final _titleController = TextEditingController();
  final _controller = ReminderController();
  final _factory = ReminderFactory();
  final _repository = InMemoryReminderRepository();

  _NotifyChannel _channel = _NotifyChannel.email;
  String? _status;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  NotificationSender get _sender => switch (_channel) {
        _NotifyChannel.email => EmailSender(),
        _NotifyChannel.push => PushSender(),
      };

  Future<void> _submit() async {
    final reminder = _factory.create(
      title: _titleController.text,
      dueAt: DateTime.now().add(const Duration(hours: 1)),
    );

    final saved = await _controller.saveReminder(reminder);
    if (!saved) {
      setState(() => _status = _controller.lastError);
      return;
    }

    await _repository.save(reminder);

    final notifier = ReminderNotifier(
      writer: _repository,
      sender: _sender,
    );
    final message = await notifier.createAndNotify(reminder);

    setState(() {
      _status = 'Saved and notified via ${_sender.channelName}.\n$message';
      _titleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Try it together')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Reminder title',
                errorText: _controller.lastError,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<_NotifyChannel>(
              segments: const [
                ButtonSegment(
                  value: _NotifyChannel.email,
                  label: Text('Email'),
                  icon: Icon(Icons.email_outlined),
                ),
                ButtonSegment(
                  value: _NotifyChannel.push,
                  label: Text('Push'),
                  icon: Icon(Icons.notifications_outlined),
                ),
              ],
              selected: {_channel},
              onSelectionChanged: (selection) {
                setState(() => _channel = selection.first);
              },
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _submit,
              child: const Text('Save & notify'),
            ),
            const SizedBox(height: 24),
            if (_status != null)
              Expanded(
                child: SelectionArea(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _status!,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
