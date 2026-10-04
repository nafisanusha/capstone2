import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:museum_gateway/data/admission.dart';

void main() {
  test('declined paid admission issues no ticket', () async {
    final session = AdmissionSession();
    final ticket = await session.issue(category: AdmissionCategory.general, guests: 2, outcome: PaymentOutcome.declined);
    expect(ticket, isNull);
    expect(session.ticket, isNull);
  });
  test('free admission bypasses payment and issues a unique demo QR payload', () async {
    final session = AdmissionSession();
    final first = await session.issue(category: AdmissionCategory.floridaResident, guests: 3, outcome: PaymentOutcome.declined);
    final second = await session.issue(category: AdmissionCategory.floridaResident, guests: 3, outcome: PaymentOutcome.approved);
    expect(first!.totalCents, 0);
    expect(first.id, isNot(second!.id));
    expect(jsonDecode(first.payload), {'version': 1, 'mode': 'demo', 'ticketId': first.id});
  });
  test('paid ticket total reflects the party size', () async {
    final ticket = await AdmissionSession().issue(category: AdmissionCategory.general, guests: 4, outcome: PaymentOutcome.approved);
    expect(ticket!.totalCents, 4800);
    expect(DemoTicket.fromJson(ticket.toJson()).id, ticket.id);
  });
  test('invalid party size is rejected before ticket creation', () async {
    final session = AdmissionSession();
    for (final count in [0, 9]) {
      await expectLater(session.issue(category: AdmissionCategory.general, guests: count, outcome: PaymentOutcome.approved), throwsArgumentError);
    }
    expect(session.ticket, isNull);
  });
  test('ticket survives reload and reset removes it', () async {
    SharedPreferences.setMockInitialValues({});
    final session = await AdmissionSession.load();
    final ticket = await session.issue(category: AdmissionCategory.general, guests: 2, outcome: PaymentOutcome.approved);
    final restored = await AdmissionSession.load();
    expect(restored.ticket!.id, ticket!.id);
    await restored.reset();
    expect((await AdmissionSession.load()).ticket, isNull);
  });
  test('corrupt saved ticket is removed with a visitor-visible warning', () async {
    SharedPreferences.setMockInitialValues({AdmissionSession.storageKey: '{not json'});
    final session = await AdmissionSession.load();
    expect(session.ticket, isNull);
    expect(session.storageWarning, isNotNull);
    expect((await SharedPreferences.getInstance()).getString(AdmissionSession.storageKey), isNull);
  });
  test('a tampered total cannot be restored', () {
    final json = DemoTicket(id: 'example', guests: 2, category: AdmissionCategory.general,
      totalCents: 2400, issuedAt: DateTime.utc(2026)).toJson();
    json['totalCents'] = 0;
    expect(() => DemoTicket.fromJson(json), throwsFormatException);
  });
}
