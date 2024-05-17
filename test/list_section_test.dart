import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_play/src/presentation/widgets/list_section.dart';

void main() {
  group(
    'ListSectionWidget',
    () {
      testWidgets(
        'renders data corectly',
        (widgetTester) async {
          const String title = 'Test Title';
          const int duration = 60;

          await widgetTester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: ListSectionWidget(
                  title: title,
                  duration: duration,
                ),
              ),
            ),
          );

          expect(find.text(title), findsOneWidget);
        },
      );
    },
  );
}
