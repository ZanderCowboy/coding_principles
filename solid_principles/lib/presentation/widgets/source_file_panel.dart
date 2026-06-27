import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solid_principles/presentation/widgets/line_numbered_code_view.dart';

/// Expandable panel that loads and displays a bundled Dart source file.
class SourceFilePanel extends StatefulWidget {
  const SourceFilePanel({required this.assetPath, super.key});

  final String assetPath;

  @override
  State<SourceFilePanel> createState() => _SourceFilePanelState();
}

class _SourceFilePanelState extends State<SourceFilePanel> {
  Future<String>? _sourceFuture;

  String get _fileName {
    final segments = widget.assetPath.split('/');
    return segments.isEmpty ? widget.assetPath : segments.last;
  }

  Future<String> _loadSource() {
    return rootBundle.loadString(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        leading: Icon(Icons.code, color: colorScheme.primary),
        title: Text(
          _fileName,
          style: const TextStyle(fontFamily: 'monospace'),
        ),
        subtitle: Text(
          widget.assetPath,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
              ),
        ),
        onExpansionChanged: (expanded) {
          if (expanded && _sourceFuture == null) {
            final future = _loadSource();
            setState(() {
              _sourceFuture = future;
            });
          }
        },
        children: [
          FutureBuilder<String>(
            future: _sourceFuture,
            builder: (context, snapshot) {
              if (_sourceFuture == null) {
                return const SizedBox.shrink();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Could not load file.',
                    style: TextStyle(color: colorScheme.error),
                  ),
                );
              }

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: LineNumberedCodeView(code: snapshot.data!),
              );
            },
          ),
        ],
      ),
    );
  }
}
