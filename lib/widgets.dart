import 'package:flutter/material.dart';
import 'theme.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.children});
  final List<Widget> children;
  @override Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 600 ? 20 : 36),
    child: Align(alignment: Alignment.topCenter, child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1120),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children))));
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.eyebrow, this.title, this.subtitle, {super.key});
  final String eyebrow, title, subtitle;
  @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(eyebrow.toUpperCase(), style: const TextStyle(color: coral, fontWeight: FontWeight.w700, letterSpacing: 2)),
    const SizedBox(height: 14),
    Semantics(header: true, child: Text(title, style: Theme.of(context).textTheme.headlineLarge)),
    const SizedBox(height: 14), Text(subtitle, style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 28),
  ]);
}

class Note extends StatelessWidget {
  const Note(this.text, {super.key, this.icon = Icons.info_outline});
  final String text;
  final IconData icon;
  @override Widget build(BuildContext context) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: sand.withValues(alpha: .5), borderRadius: BorderRadius.circular(12)),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: ink, size: 22), const SizedBox(width: 12), Expanded(child: Text(text))]));
}

class Surface extends StatelessWidget {
  const Surface({super.key, required this.child, this.color = Colors.white});
  final Widget child;
  final Color color;
  @override Widget build(BuildContext context) => Container(width: double.infinity,
    padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)), child: child);
}

/// Original geometric artwork drawn in code; no museum collection images used.
class GalleryArt extends StatelessWidget {
  const GalleryArt(this.variant, {super.key, this.height = 220});
  final int variant;
  final double height;
  @override Widget build(BuildContext context) => ExcludeSemantics(child: SizedBox(
    height: height, width: double.infinity, child: CustomPaint(painter: _ArtPainter(variant))));
}
class _ArtPainter extends CustomPainter {
  _ArtPainter(this.variant);
  final int variant;
  @override void paint(Canvas canvas, Size size) {
    final palette = [const Color(0xFFEBCDA3), const Color(0xFFC9D8CF), const Color(0xFFD9C8B7)];
    canvas.drawRect(Offset.zero & size, Paint()..color = palette[variant % 3]);
    canvas.save(); canvas.translate(size.width / 2, size.height / 2);
    final scale = size.height / 220; canvas.scale(scale);
    final p = Paint()..color = ink;
    if (variant == 0) {
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-60, -15, 120, 24), const Radius.circular(4)), p);
      canvas.drawRect(const Rect.fromLTWH(-51, 5, 11, 70), p);
      canvas.drawRect(const Rect.fromLTWH(40, 5, 11, 70), p);
      canvas.drawRect(const Rect.fromLTWH(-48, -78, 10, 67), p);
      canvas.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-48, -78, 95, 43), const Radius.circular(8)), Paint()..color = coral);
      canvas.drawCircle(const Offset(82, -60), 26, Paint()..color = Colors.white.withValues(alpha: .65));
    } else if (variant == 1) {
      canvas.rotate(-.13);
      canvas.drawRect(const Rect.fromLTWH(-72, -90, 144, 180), Paint()..color = cream);
      canvas.drawCircle(const Offset(-15, -27), 48, Paint()..color = coral);
      canvas.drawRect(const Rect.fromLTWH(-48, 30, 98, 12), p);
      canvas.drawRect(const Rect.fromLTWH(-48, 51, 70, 7), p);
      canvas.drawRect(const Rect.fromLTWH(16, -68, 28, 120), p..color = ink.withValues(alpha: .85));
    } else {
      canvas.drawRect(const Rect.fromLTWH(-76, -28, 50, 112), p);
      canvas.drawRect(const Rect.fromLTWH(-16, -88, 55, 172), Paint()..color = coral);
      canvas.drawRect(const Rect.fromLTWH(48, -54, 40, 138), Paint()..color = cream);
      for (var y = -68.0; y < 70; y += 24) { canvas.drawRect(Rect.fromLTWH(-4, y, 30, 7), Paint()..color = cream); }
    }
    canvas.restore();
  }
  @override bool shouldRepaint(_ArtPainter oldDelegate) => oldDelegate.variant != variant;
}
