import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_play/src/presentation/widgets/list_unit.dart';

void main() {
  setUpAll(
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      const ScreenUtilInit();
    },
  );
  group(
    "ListUnitWidget",
    () {
      testWidgets(
        'renders title correctly',
        (widgetTester) async {
          const String title = 'Testing Title';
          const int duration = 60;
          bool isDownloaded = false;

          await widgetTester.pumpWidget(
            MaterialApp(
              home: ScreenUtilInit(
                child: Scaffold(
                  body: ListUnitWidget(
                    title: title,
                    duration: duration,
                    onTap: () {},
                    onTapDownload: () {},
                    isDownloaded: isDownloaded,
                    isSelected: false,
                  ),
                ),
              ),
            ),
          );
          await widgetTester.pump();

          final titleFinder = find.widgetWithText(Html, title);
          final durationFinder =
              find.text('${(duration / 60).round()} minutes');

          expect(titleFinder, findsOneWidget);
          expect(durationFinder, findsOneWidget);
        },
      );

      testWidgets(
        'shows download button when offlineDownloadLink is provided',
        (widgetTester) async {
          const String title = 'Testing Title';
          const int duration = 60;
          const String downloadLink = 'https://example.com/download';

          await widgetTester.pumpWidget(
            MaterialApp(
              home: ScreenUtilInit(
                child: Scaffold(
                  body: ListUnitWidget(
                    title: title,
                    duration: duration,
                    onTap: () {},
                    onTapDownload: () {},
                    isDownloaded: false,
                    offlineDownloadLink: downloadLink,
                    isSelected: false,
                  ),
                ),
              ),
            ),
          );

          await widgetTester.pump();

          final downlodButtonFinder = find.text(
            downloadLink.contains('https') ? 'Download' : 'Watch Download',
          );

          expect(downlodButtonFinder, findsOneWidget);
        },
      );

      testWidgets(
        'calls onTapDownload when download button is tapped',
        (widgetTester) async {
          const title = 'Sample Title';
          const duration = 120; // In seconds
          const downloadLink = 'https://example.com/download';

          var onTapDownloadCalled = false;

          await widgetTester.pumpWidget(
            MaterialApp(
              home: ScreenUtilInit(
                child: Scaffold(
                  body: ListUnitWidget(
                    title: title,
                    duration: duration,
                    onTap: () {},
                    onTapDownload: () => onTapDownloadCalled = true,
                    isDownloaded: false,
                    offlineDownloadLink: downloadLink,
                    isSelected: false,
                  ),
                ),
              ),
            ),
          );

          await widgetTester.pump();

          final downloadButton = find.text(
              downloadLink.contains('http') ? 'Download' : 'Watch Downloaded');
          await widgetTester.tap(downloadButton);

          expect(onTapDownloadCalled, true);
        },
      );
    },
  );
}
