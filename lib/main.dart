import 'package:flutter/material.dart';
import 'data/admission.dart';
import 'data/catalog.dart';
import 'screens/admission.dart';
import 'screens/explore.dart';
import 'screens/wayfinding.dart';
import 'theme.dart';
import 'widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final session = await AdmissionSession.load();
  runApp(MuseumGatewayApp(session: session));
}

class MuseumGatewayApp extends StatelessWidget {
  const MuseumGatewayApp({super.key, required this.session});
  final AdmissionSession session;
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Museum Gateway', debugShowCheckedModeBanner: false,
    theme: gatewayTheme(), home: GatewayShell(session: session));
}

class GatewayShell extends StatefulWidget {
  const GatewayShell({super.key, required this.session});
  final AdmissionSession session;
  @override State<GatewayShell> createState() => _GatewayShellState();
}
class _GatewayShellState extends State<GatewayShell> {
  int selected = 0;
  int visit = 0;
  static const labels = ['Welcome', 'Admission', 'Explore', 'Map', 'Visit info'];
  static const icons = [Icons.home_outlined, Icons.confirmation_number_outlined,
    Icons.auto_awesome_outlined, Icons.map_outlined, Icons.info_outline];
  Future<void> reset() async {
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: const Text('Start a new visit?'), content: const Text('This removes the demo ticket from this device and returns to the welcome screen.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Keep this visit')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Start new visit'))]));
    if (confirmed != true) { return; }
    await widget.session.reset();
    if (!mounted) { return; }
    setState(() { selected = 0; visit++; });
    if (widget.session.storageWarning != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.session.storageWarning!)));
    }
  }
  @override Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final pages = [WelcomePage(onNavigate: (index) => setState(() => selected = index)),
      AdmissionPage(session: widget.session), const ExplorePage(), const WayfindingPage(), const VisitInfoPage()];
    return Scaffold(
      appBar: AppBar(title: const Text('Museum Gateway', style: TextStyle(fontWeight: FontWeight.w600)), actions: [
        PopupMenuButton<String>(tooltip: 'Visit options', onSelected: (_) => reset(), itemBuilder: (_) => [
          const PopupMenuItem(value: 'reset', child: Text('Start a new visit')),
        ]), const SizedBox(width: 8),
      ]),
      body: Column(children: [
        Container(width: double.infinity, color: sand, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: const Text('STUDENT PROTOTYPE · SAMPLE CONTENT · NO REAL PAYMENTS', style: TextStyle(fontSize: 11, letterSpacing: .7, fontWeight: FontWeight.w600))),
        Expanded(child: Row(children: [
          if (wide) ...[
            NavigationRail(selectedIndex: selected, onDestinationSelected: (index) => setState(() => selected = index),
              labelType: NavigationRailLabelType.all, backgroundColor: cream,
              destinations: List.generate(labels.length, (i) => NavigationRailDestination(icon: Icon(icons[i]), label: Text(labels[i])))),
            const VerticalDivider(width: 1),
          ],
          Expanded(child: IndexedStack(key: ValueKey(visit), index: selected, children: pages)),
        ])),
      ]),
      bottomNavigationBar: wide ? null : NavigationBar(
        selectedIndex: selected, onDestinationSelected: (index) => setState(() => selected = index),
        destinations: List.generate(labels.length, (i) => NavigationDestination(icon: Icon(icons[i]), label: labels[i]))),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;
  @override Widget build(BuildContext context) => PageBody(children: [
    const Text('THE WOLFSONIAN–FIU', style: TextStyle(letterSpacing: 2.5, fontWeight: FontWeight.w700, fontSize: 13, color: muted)),
    const SizedBox(height: 28),
    LayoutBuilder(builder: (context, constraints) {
      final intro = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('A little curiosity.\nA world of discovery.', style: TextStyle(fontFamily: 'Georgia', fontSize: 42, height: 1.12, color: ink)),
        const SizedBox(height: 22), const Text('Your visit begins here. Find a story that speaks to you, explore a new idea, and make your own path.', style: TextStyle(fontSize: 18, height: 1.5)),
        const SizedBox(height: 26), FilledButton.icon(onPressed: () => onNavigate(1), icon: const Icon(Icons.arrow_forward), label: const Text('Begin your visit')),
      ]);
      final art = ClipRRect(borderRadius: BorderRadius.circular(24), child: const GalleryArt(2, height: 310));
      return constraints.maxWidth >= 800 ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [Expanded(child: intro), const SizedBox(width: 44), Expanded(child: art)]) : Column(children: [intro, const SizedBox(height: 28), art]);
    }),
    const SizedBox(height: 32),
    LayoutBuilder(builder: (context, constraints) {
      final cards = [
        ('Explore the galleries', 'Objects, images, and ideas worth a closer look.', Icons.auto_awesome_outlined, 2),
        ('Find your way', 'A sample map and a pathway through design.', Icons.map_outlined, 3),
        ('Feel at home', 'Visitor assistance, amenities, and accessibility.', Icons.volunteer_activism_outlined, 4),
      ];
      final columns = constraints.maxWidth >= 800 ? 3 : 1;
      final width = (constraints.maxWidth - 18 * (columns - 1)) / columns;
      return Wrap(spacing: 18, runSpacing: 18, children: cards.map((card) => SizedBox(width: width, child: Material(
        color: Colors.white, borderRadius: BorderRadius.circular(18), child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => onNavigate(card.$4),
          child: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(card.$3, color: coral, size: 30), const SizedBox(height: 18), Text(card.$1, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10), Text(card.$2), const SizedBox(height: 18), const Icon(Icons.arrow_forward, color: ink),
          ])))))).toList());
    }), const SizedBox(height: 28),
    const Note('Welcome to our capstone proof of concept. Museum content, prices, and floor plans are examples awaiting Product Owner confirmation.'),
  ]);
}

class VisitInfoPage extends StatelessWidget {
  const VisitInfoPage({super.key});
  @override Widget build(BuildContext context) => PageBody(children: [
    const PageHeading('A welcoming visit', 'Here to help', 'Find assistance and discover more during your visit.'),
    Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.accessibility_new, color: coral, size: 32), const SizedBox(height: 14),
      Text('Accessibility & assistance', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 12),
      const Text('Ask visitor services to confirm accessible gallery routes, elevator locations, and available accommodations. This demo does not contain a verified accessible building map.'),
      const SizedBox(height: 12), const Text('This app supports device text-size settings and screen-reader labels. Accessibility checks with real visitors and kiosk hardware are still required.'),
    ])), const SizedBox(height: 20),
    Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.local_cafe_outlined, color: coral, size: 32), const SizedBox(height: 14),
      Text('Design Store + Coffee Bar', style: Theme.of(context).textTheme.headlineMedium), const SizedBox(height: 12),
      const Text('Extend your visit with a browse or a break. Location, hours, and offerings will be added after confirmation with museum staff.'),
    ])), const SizedBox(height: 20),
    Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('About Museum Gateway', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 12),
      const Text('A student capstone visitor experience prototype developed for the Museum Gateway project at The Wolfsonian-FIU. This is not an official museum admission system.'),
      const SizedBox(height: 12), const Text('No accounts, real payments, card details, or personal visitor records. A demo ticket is saved locally on this device. Use “Start a new visit” to remove it.'),
    ])), const SizedBox(height: 24),
    Text('${exhibitions.length} sample exhibitions · One sample thematic pathway', style: const TextStyle(color: muted)),
  ]);
}
