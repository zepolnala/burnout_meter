import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:burnout_meter_app/main.dart';

void main() {
  testWidgets('BurnoutMeterApp bootstrap smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BurnoutMeterApp(),
      ),
    );
    expect(find.byType(BurnoutMeterApp), findsOneWidget);
  });
}
