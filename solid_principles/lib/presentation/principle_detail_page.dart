import 'package:flutter/material.dart';
import 'package:solid_principles/catalog/principle_info.dart';
import 'package:solid_principles/presentation/widgets/source_file_panel.dart';

class PrincipleDetailPage extends StatefulWidget {
  const PrincipleDetailPage({required this.principle, super.key});

  final PrincipleInfo principle;

  @override
  State<PrincipleDetailPage> createState() => _PrincipleDetailPageState();
}

class _PrincipleDetailPageState extends State<PrincipleDetailPage> {
  String? _demoResult;
  bool _isRunning = false;

  Future<void> _runDemo() async {
    setState(() {
      _isRunning = true;
      _demoResult = null;
    });

    try {
      final result = await widget.principle.runDemo();
      if (!mounted) {
        return;
      }
      setState(() => _demoResult = result);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demo finished — see result below')),
      );
    } finally {
      if (mounted) {
        setState(() => _isRunning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final principle = widget.principle;

    return Scaffold(
      appBar: AppBar(title: Text(principle.title)),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              principle.summary,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'What to say in an interview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...principle.interviewTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(tip)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Code examples',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Expand a file to read the full source.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            ...principle.sourcePaths.map(
              (path) => SourceFilePanel(assetPath: path),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isRunning ? null : _runDemo,
              icon: _isRunning
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isRunning ? 'Running…' : 'Run demo'),
            ),
            if (_demoResult != null) ...[
              const SizedBox(height: 16),
              Text(
                'Demo result',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  _demoResult!,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
