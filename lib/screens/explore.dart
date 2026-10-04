import 'package:flutter/material.dart';
import '../data/catalog.dart';
import '../theme.dart';
import '../widgets.dart';
import 'wayfinding.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  @override State<ExplorePage> createState() => _ExplorePageState();
}
class _ExplorePageState extends State<ExplorePage> {
  String filter = 'All';
  bool programsSelected = false;
  @override Widget build(BuildContext context) {
    final visible = exhibitions.where((e) => filter == 'All' || e.category == filter).toList();
    return PageBody(children: [
      const PageHeading('Follow your curiosity', 'Something to discover', 'Explore ideas, objects, and stories at your own pace.'),
      const Note('Demo catalog: exhibitions, programs, and gallery locations below are fictional examples.'),
      const SizedBox(height: 24),
      Wrap(spacing: 12, runSpacing: 12, children: [
        ChoiceChip(label: const Text('Exhibitions'), selected: !programsSelected, onSelected: (_) => setState(() => programsSelected = false)),
        ChoiceChip(label: const Text('Programs'), selected: programsSelected, onSelected: (_) => setState(() => programsSelected = true)),
      ]), const SizedBox(height: 20),
      if (!programsSelected) ...[
        Wrap(spacing: 10, runSpacing: 10, children: ['All', 'Design', 'Graphic art', 'Architecture'].map((name) => FilterChip(
          label: Text(name), selected: filter == name, onSelected: (_) => setState(() => filter = name))).toList()),
        const SizedBox(height: 24),
        LayoutBuilder(builder: (context, constraints) {
          final columns = constraints.maxWidth >= 850 ? 3 : constraints.maxWidth >= 560 ? 2 : 1;
          final width = (constraints.maxWidth - 20 * (columns - 1)) / columns;
          return Wrap(spacing: 20, runSpacing: 20, children: visible.map((e) => SizedBox(width: width,
            child: ExhibitionCard(exhibition: e))).toList());
        }),
      ] else ...programs.map((program) => Padding(padding: const EdgeInsets.only(bottom: 16), child: Surface(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.event_outlined, color: coral), const SizedBox(height: 12),
          Text(program.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8), Text(program.detail), const SizedBox(height: 8), Text(program.location),
          const SizedBox(height: 12), const Text('Ask visitor services about actual programs. Booking is not available in this demo.'),
        ])))),
      const SizedBox(height: 24),
    ]);
  }
}
class ExhibitionCard extends StatelessWidget {
  const ExhibitionCard({super.key, required this.exhibition});
  final Exhibition exhibition;
  @override Widget build(BuildContext context) => Material(color: Colors.white, borderRadius: BorderRadius.circular(20), clipBehavior: Clip.antiAlias,
    child: InkWell(onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ExhibitionDetail(exhibition: exhibition))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GalleryArt(exhibition.art), Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(exhibition.category.toUpperCase(), style: const TextStyle(color: coral, letterSpacing: 1.4, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10), Text(exhibition.title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12), Text(exhibition.summary), const SizedBox(height: 18),
          Text('${exhibition.duration} min · ${exhibition.location}'), const SizedBox(height: 12),
          const Row(children: [Expanded(child: Text('Discover exhibition')), SizedBox(width: 8), Icon(Icons.arrow_forward, size: 20)]),
        ])),
      ])));
}
class ExhibitionDetail extends StatelessWidget {
  const ExhibitionDetail({super.key, required this.exhibition});
  final Exhibition exhibition;
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Exhibition')), body: PageBody(children: [
    ClipRRect(borderRadius: BorderRadius.circular(20), child: GalleryArt(exhibition.art, height: 280)), const SizedBox(height: 28),
    PageHeading(exhibition.category, exhibition.title, exhibition.location),
    Text(exhibition.story, style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 24),
    Note('Sample content · Allow about ${exhibition.duration} minutes. Confirm the actual gallery and accessible route with staff.'),
    const SizedBox(height: 24), FilledButton.icon(onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Sample wayfinding')), body: const WayfindingPage()))), icon: const Icon(Icons.map_outlined), label: const Text('See sample map & route')),
  ]));
}
