import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:museum_gateway/main.dart';
import 'package:museum_gateway/data/admission.dart';

void main() {
  testWidgets('visitor can begin admission and see a demo QR ticket', (tester) async {
    final session = AdmissionSession();
    await tester.pumpWidget(MuseumGatewayApp(session: session));
    await tester.tap(find.text('Begin your visit'));
    await tester.pumpAndSettle();
    final button = find.byKey(const Key('issue-ticket'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(session.ticket, isNotNull);
    expect(find.text('Your demo ticket'), findsOneWidget);
    expect(find.textContaining('NOT VALID FOR MUSEUM ENTRY'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('exhibition walking skeleton reaches a detail page', (tester) async {
    await tester.pumpWidget(MuseumGatewayApp(session: AdmissionSession()));
    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    final exhibition = find.text('Everyday, extraordinary');
    await tester.ensureVisible(exhibition);
    await tester.tap(exhibition);
    await tester.pumpAndSettle();
    expect(find.text('Exhibition'), findsOneWidget);
    expect(find.text('See sample map & route'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('new visit clears ticket and returns to welcome', (tester) async {
    final session = AdmissionSession();
    await session.issue(category: AdmissionCategory.general, guests: 1, outcome: PaymentOutcome.approved);
    await tester.pumpWidget(MuseumGatewayApp(session: session));
    await tester.tap(find.byTooltip('Visit options'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start a new visit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start new visit'));
    await tester.pumpAndSettle();
    expect(session.ticket, isNull);
    expect(find.text('Begin your visit'), findsOneWidget);
  });
  for (final size in [const Size(390, 844), const Size(1024, 768)]) {
    testWidgets('navigation renders at ${size.width} with large text', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.6;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(MuseumGatewayApp(session: AdmissionSession()));
      for (final label in ['Admission', 'Explore', 'Map', 'Visit info', 'Welcome']) {
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$label should fit $size');
      }
    });
  }
}
