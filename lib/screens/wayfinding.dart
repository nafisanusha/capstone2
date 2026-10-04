import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../theme.dart';
import '../widgets.dart';

class WayfindingPage extends StatefulWidget {
  const WayfindingPage({super.key});
  @override State<WayfindingPage> createState() => _WayfindingPageState();
}
class _WayfindingPageState extends State<WayfindingPage> {
  int floor = 1;
  bool route = false;
  @override Widget build(BuildContext context) => PageBody(children: [
    const PageHeading('Make your own path', 'Find your way', 'Explore a sample layout and a route through design and ideas.'),
    const Note('Illustrative map only — not the actual museum floor plan. Do not use this demo for real directions. Confirm routes with staff.'),
    const SizedBox(height: 24), Wrap(spacing: 12, runSpacing: 12, children: [1, 2, 3].map((n) => ChoiceChip(
      label: Text('Level $n'), selected: floor == n, onSelected: (_) => setState(() => floor = n))).toList()),
    const SizedBox(height: 20), Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('SAMPLE LEVEL $floor', style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
      const SizedBox(height: 20),
      LayoutBuilder(builder: (context, constraints) {
        final rooms = floor == 1 ? ['Entrance / kiosk', 'Visitor services', 'Store + Coffee Bar'] : floor == 2 ? ['Gallery A · Design', 'Gallery B · Graphic art'] : ['Gallery C · Architecture'];
        return Wrap(spacing: 12, runSpacing: 12, children: rooms.map((room) => Container(
          width: constraints.maxWidth < 440 ? constraints.maxWidth : (constraints.maxWidth - 12) / 2,
          constraints: const BoxConstraints(minHeight: 120), padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: route && floor == 2 ? sand : cream, border: Border.all(color: ink.withValues(alpha: .2)), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.location_on_outlined), const SizedBox(height: 12), Text(room, style: const TextStyle(fontWeight: FontWeight.w600))]))).toList());
      }), const SizedBox(height: 20), const Divider(),
      const ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.elevator_outlined), title: Text('Elevator / stairs'), subtitle: Text('Location and accessible route require museum confirmation.')),
    ])), const SizedBox(height: 24),
    Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Design & ideas', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 8),
      const Text('A sample thematic pathway · Two galleries · About 35 minutes'), const SizedBox(height: 16),
      SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: const Text('Show sample pathway'), value: route, onChanged: (value) => setState(() => route = value)),
      if (route) ...designRoute.indexed.map((entry) => Padding(padding: const EdgeInsets.only(top: 16), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CircleAvatar(backgroundColor: ink, foregroundColor: Colors.white, child: Text('${entry.$1 + 1}')),
        const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entry.$2.title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 6), Text(entry.$2.instruction), const SizedBox(height: 6),
          Text('Sample level ${entry.$2.floor}', style: const TextStyle(color: muted)),
        ])),
      ]))),
    ])),
  ]);
}
