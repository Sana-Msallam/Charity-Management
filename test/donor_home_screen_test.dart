import 'package:charity_management/features/Donor/Screen/donor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DonorHomeScreen builds without layout or asset exceptions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(430, 932));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(home: DonorHomeScreen()));
    await tester.pump();

    expect(find.byType(DonorHomeScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
