import 'package:flutter/material.dart';

/// Read-only code view with a DartPad-style line-number gutter.
class LineNumberedCodeView extends StatelessWidget {
  const LineNumberedCodeView({required this.code, super.key});

  final String code;

  static const double _fontSize = 13;
  static const double _lineHeight = 1.4;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lines = code.split('\n');
    final lineCount = lines.length;

    final codeStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: _fontSize,
      height: _lineHeight,
      color: colorScheme.onSurface,
    );

    final gutterStyle = TextStyle(
      fontFamily: 'monospace',
      fontSize: _fontSize,
      height: _lineHeight,
      color: colorScheme.onSurface.withValues(alpha: 0.5),
    );

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colorScheme.surfaceContainerHigh,
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            constraints: BoxConstraints(minWidth: _gutterMinWidth(lineCount)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < lineCount; i++)
                  Text('${i + 1}', style: gutterStyle),
              ],
            ),
          ),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          Expanded(
            child: SelectionArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  code,
                  style: codeStyle,
                  softWrap: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static double _gutterMinWidth(int lineCount) {
    final digits = lineCount.toString().length;
    return 16 + digits * 8.0;
  }
}
