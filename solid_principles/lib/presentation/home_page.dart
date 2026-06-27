import 'package:flutter/material.dart';
import 'package:solid_principles/catalog/principle_info.dart';
import 'package:solid_principles/presentation/live_demo_page.dart';
import 'package:solid_principles/presentation/principle_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Software Principles'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('Try it together'),
              subtitle: const Text(
                'Create a reminder — validate, save, and notify',
              ),
              trailing: const Icon(Icons.chevron_right),
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
            principles: principlesForSection(PrincipleSection.solid),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Fundamentals',
            principles: principlesForSection(PrincipleSection.fundamentals),
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'GRASP',
            principles: principlesForSection(PrincipleSection.grasp),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.principles,
  });

  final String title;
  final List<PrincipleInfo> principles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...principles.map(
          (principle) => Card(
            child: ListTile(
              title: Text(principle.title),
              subtitle: Text(principle.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PrincipleDetailPage(principle: principle),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
