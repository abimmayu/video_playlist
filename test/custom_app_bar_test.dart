import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_play/src/presentation/widgets/app_bar.dart';

void main() {
  group('CustomAppBarWidget', () {
    testWidgets(
      'renders title correctly',
      (tester) async {
        const String title = 'Test Title';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: CustomAppBarWidget(
                  title: title,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text(title), findsOneWidget);
      },
    );

    testWidgets('triggers onPressed callback when leading icon is tapped',
        (WidgetTester tester) async {
      bool onPressedCalled = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: CustomAppBarWidget(
                title: 'Test Title',
                onPressed: () {
                  onPressedCalled = false;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.byIcon(Icons.arrow_back));

      expect(onPressedCalled, false);
    });
  });
}
