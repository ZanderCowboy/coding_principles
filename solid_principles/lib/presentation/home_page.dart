import 'package:flutter/material.dart';
import 'package:solid_principles/catalog/principle_info.dart';
import 'package:solid_principles/presentation/live_demo_page.dart';
import 'package:solid_principles/presentation/principle_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Software Principles'),
      ),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.play_circle_outline,
                  color: colorScheme.onPrimaryContainer,
                  size: 32,
                ),
                title: Text(
                  'Try it together',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Create a reminder — validate, save, and notify',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onPrimaryContainer,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const LiveDemoPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'SOLID',
              accentColor: Colors.indigo,
              principles: principlesForSection(PrincipleSection.solid),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'Fundamentals',
              accentColor: Colors.teal,
              principles: principlesForSection(PrincipleSection.fundamentals),
            ),
            const SizedBox(height: 16),
            _Section(
              title: 'GRASP',
              accentColor: Colors.amber,
              principles: principlesForSection(PrincipleSection.grasp),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.accentColor,
    required this.principles,
  });

  final String title;
  final Color accentColor;
  final List<PrincipleInfo> principles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...principles.map(
          (principle) => Card(
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ColoredBox(
                    color: accentColor.withValues(alpha: 0.7),
                    child: const SizedBox(width: 4),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(principle.title),
                      subtitle: Text(principle.subtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                PrincipleDetailPage(principle: principle),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
