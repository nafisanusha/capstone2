import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../data/admission.dart';
import '../theme.dart';
import '../widgets.dart';

class AdmissionPage extends StatefulWidget {
  const AdmissionPage({super.key, required this.session});
  final AdmissionSession session;
  @override State<AdmissionPage> createState() => _AdmissionPageState();
}
class _AdmissionPageState extends State<AdmissionPage> {
  AdmissionCategory category = AdmissionCategory.floridaResident;
  PaymentOutcome outcome = PaymentOutcome.approved;
  int guests = 1;
  bool busy = false;
  String? error;
  Future<void> issue() async {
    setState(() { busy = true; error = null; });
    try {
      final ticket = await widget.session.issue(category: category, guests: guests, outcome: outcome);
      if (!mounted) { return; }
      if (ticket == null) { setState(() => error = 'Demo payment declined. No ticket was issued. Choose Approved to retry.'); }
    } catch (_) {
      if (mounted) { setState(() => error = 'The demo ticket could not be created. Please try again.'); }
    } finally { if (mounted) { setState(() => busy = false); } }
  }
  @override Widget build(BuildContext context) => ListenableBuilder(listenable: widget.session, builder: (context, _) {
    final ticket = widget.session.ticket;
    if (ticket != null) { return TicketPage(ticket: ticket, warning: widget.session.storageWarning); }
    return PageBody(children: [
      const PageHeading('Begin your visit', 'Admission, made simple', 'Choose a demo admission option for your party.'),
      const Note('Demo only. Prices and eligibility below are examples, not confirmed admission policies. No money is charged or card information requested.'),
      const SizedBox(height: 24), Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('1. Choose admission', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16),
        ...AdmissionCategory.values.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Semantics(selected: category == c,
          child: OutlinedButton(onPressed: busy ? null : () => setState(() => category = c), style: OutlinedButton.styleFrom(
            backgroundColor: category == c ? sand : Colors.white, alignment: Alignment.centerLeft, side: BorderSide(color: category == c ? ink : sand, width: category == c ? 2 : 1)),
            child: Row(children: [Icon(category == c ? Icons.radio_button_checked : Icons.radio_button_off), const SizedBox(width: 14), Expanded(child: Text('${c.label}\n${money(c.demoPriceCents)} per guest · demo rate'))]))))),
        const SizedBox(height: 16), Text('2. Number of guests', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12), Row(children: [
          IconButton.filledTonal(key: const Key('decrease-guests'), tooltip: 'Remove one guest', onPressed: guests > 1 && !busy ? () => setState(() => guests--) : null, icon: const Icon(Icons.remove)),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Semantics(liveRegion: true, child: Text('$guests', style: Theme.of(context).textTheme.headlineMedium))),
          IconButton.filledTonal(key: const Key('increase-guests'), tooltip: 'Add one guest', onPressed: guests < 8 && !busy ? () => setState(() => guests++) : null, icon: const Icon(Icons.add)),
        ]), const SizedBox(height: 8), const Text('Up to 8 guests per demo ticket.'),
      ])), const SizedBox(height: 24), Surface(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('3. Review your visit', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16),
        Text('${category.label} · $guests guest${guests == 1 ? '' : 's'}'), const SizedBox(height: 12),
        Text('Demo total: ${money(category.demoPriceCents * guests)}', style: Theme.of(context).textTheme.headlineMedium),
        if (category.demoPriceCents > 0) ...[
          const SizedBox(height: 20), const Text('Payment simulation'), const SizedBox(height: 8),
          Wrap(spacing: 12, runSpacing: 12, children: PaymentOutcome.values.map((value) => ChoiceChip(label: Text(value == PaymentOutcome.approved ? 'Approved' : 'Declined'),
            selected: outcome == value, onSelected: busy ? null : (_) => setState(() => outcome = value))).toList()),
          const SizedBox(height: 12), const Text('Local test simulation. Payment-provider sandbox integration is planned for a later sprint.'),
        ], const SizedBox(height: 24),
        if (error != null) ...[Semantics(liveRegion: true, child: Note(error!, icon: Icons.error_outline)), const SizedBox(height: 16)],
        FilledButton.icon(key: const Key('issue-ticket'), onPressed: busy ? null : issue,
          icon: const Icon(Icons.qr_code_2), label: Text(busy ? 'Creating ticket…' : 'Confirm & create demo ticket')),
        if (widget.session.storageWarning != null) ...[const SizedBox(height: 16), Note(widget.session.storageWarning!)],
      ])),
    ]);
  });
}

class TicketPage extends StatelessWidget {
  const TicketPage({super.key, required this.ticket, this.warning});
  final DemoTicket ticket;
  final String? warning;
  @override Widget build(BuildContext context) => PageBody(children: [
    const PageHeading('You’re ready to explore', 'Your demo ticket', 'A unique QR code for this sample visit.'),
    const Note('DEMO ONLY — NOT VALID FOR MUSEUM ENTRY. No real payment was processed.'), const SizedBox(height: 24),
    Align(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Surface(child: Column(children: [
      const Icon(Icons.check_circle_outline, color: ink, size: 42), const SizedBox(height: 12),
      Text('${ticket.guests} guest${ticket.guests == 1 ? '' : 's'}', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 8), Text(ticket.category.label), const SizedBox(height: 24),
      Semantics(label: 'Demo QR ticket, identifier ${ticket.id}', image: true, child: ExcludeSemantics(child: Container(
        color: Colors.white, padding: const EdgeInsets.all(12), child: QrImageView(data: ticket.payload, size: 240, backgroundColor: Colors.white)))),
      const SizedBox(height: 16), const Text('DEMO • NOT AN ENTRY PASS', style: TextStyle(fontWeight: FontWeight.bold, color: coral)),
      const SizedBox(height: 16), SelectableText(ticket.id, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
      const SizedBox(height: 12), Text('Demo total ${money(ticket.totalCents)}'),
      const SizedBox(height: 8), Text('Issued ${ticket.issuedAt.toLocal().toString().split('.').first}'),
    ])))),
    const SizedBox(height: 24),
    if (warning != null) ...[Note(warning!), const SizedBox(height: 16)],
    const Text('Continue with Explore or Map below. Start a new visit from the top menu to clear this ticket from this device.'),
  ]);
}
