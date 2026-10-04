import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

enum AdmissionCategory {
  floridaResident('Florida resident', 0),
  general('General admission', 1200);
  const AdmissionCategory(this.label, this.demoPriceCents);
  final String label;
  final int demoPriceCents;
}

enum PaymentOutcome { approved, declined }

class DemoTicket {
  const DemoTicket({required this.id, required this.guests, required this.category,
    required this.totalCents, required this.issuedAt});
  final String id;
  final int guests, totalCents;
  final AdmissionCategory category;
  final DateTime issuedAt;
  String get payload => jsonEncode({'version': 1, 'mode': 'demo', 'ticketId': id});
  Map<String, dynamic> toJson() => {'id': id, 'guests': guests, 'category': category.name,
    'totalCents': totalCents, 'issuedAt': issuedAt.toIso8601String()};
  factory DemoTicket.fromJson(Map<String, dynamic> json) {
    final ticket = DemoTicket(id: json['id'] as String, guests: json['guests'] as int,
      category: AdmissionCategory.values.byName(json['category'] as String),
      totalCents: json['totalCents'] as int, issuedAt: DateTime.parse(json['issuedAt'] as String));
    if (ticket.id.isEmpty || ticket.guests < 1 || ticket.guests > 8 ||
        ticket.totalCents != ticket.category.demoPriceCents * ticket.guests) {
      throw const FormatException('Invalid demo ticket');
    }
    return ticket;
  }
}

/// Local simulation only. No merchant connection, card fields, or entry validity.
class AdmissionSession extends ChangeNotifier {
  static const storageKey = 'museum_gateway_demo_ticket_v1';
  AdmissionSession({SharedPreferences? preferences}) : _preferences = preferences;
  final SharedPreferences? _preferences;
  DemoTicket? ticket;
  String? storageWarning;

  static Future<AdmissionSession> load() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final session = AdmissionSession(preferences: preferences);
      final saved = preferences.getString(storageKey);
      if (saved != null) {
        try { session.ticket = DemoTicket.fromJson(jsonDecode(saved) as Map<String, dynamic>); }
        catch (_) {
          await preferences.remove(storageKey);
          session.storageWarning = 'The saved demo ticket could not be restored. Start a new demo visit.';
        }
      }
      return session;
    } catch (_) {
      return AdmissionSession()..storageWarning = 'Ticket storage is unavailable. Tickets will last only while the app is open.';
    }
  }

  Future<DemoTicket?> issue({required AdmissionCategory category, required int guests,
      required PaymentOutcome outcome}) async {
    if (guests < 1 || guests > 8) { throw ArgumentError.value(guests, 'guests', 'Must be 1–8'); }
    if (outcome == PaymentOutcome.declined && category.demoPriceCents > 0) { return null; }
    final issued = DemoTicket(id: const Uuid().v4(), guests: guests, category: category,
      totalCents: category.demoPriceCents * guests, issuedAt: DateTime.now().toUtc());
    ticket = issued;
    if (_preferences == null) { storageWarning = 'This demo ticket lasts only while the app is open. Device storage is unavailable.'; }
    if (_preferences != null) {
      try {
        final saved = await _preferences.setString(storageKey, jsonEncode(issued.toJson()));
        if (!saved) { throw StateError('Storage write failed'); }
      } catch (_) { storageWarning = 'This ticket could not be saved. Keep the app open to view it.'; }
    }
    notifyListeners();
    return issued;
  }

  Future<void> reset() async {
    ticket = null;
    storageWarning = _preferences == null ? 'Device storage is unavailable. Demo tickets last only while the app is open.' : null;
    if (_preferences != null) {
      try {
        final removed = await _preferences.remove(storageKey);
        if (!removed) { throw StateError('Storage removal failed'); }
      } catch (_) { storageWarning = 'The previous demo ticket could not be removed from storage. Restart may restore it.'; }
    }
    notifyListeners();
  }
}

String money(int cents) => '\$${(cents / 100).toStringAsFixed(2)}';
