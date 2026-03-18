import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restory_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Integration: aplikasi berhasil diluncurkan dan menampilkan halaman utama',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // NavigationBar dengan 3 tab harus ada
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('Restoran'), findsOneWidget);
    expect(find.text('Favorit'), findsOneWidget);
    expect(find.text('Pengaturan'), findsOneWidget);
  });

  testWidgets(
      'Integration: navigasi ke tab Favorit menampilkan halaman favorit',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.text('Favorit'));
    await tester.pumpAndSettle();

    expect(find.text('Favorit'), findsWidgets);
  });

  testWidgets(
      'Integration: navigasi ke tab Pengaturan menampilkan switch toggle',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();

    expect(find.byType(SwitchListTile), findsWidgets);
  });
}
