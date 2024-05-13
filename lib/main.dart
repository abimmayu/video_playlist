import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/routing/router.dart';
import 'package:video_play/core/utils/injection.dart' as di;
import 'package:video_play/src/presentation/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    di.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LessonBloc>(
          create: (context) {
            return di.locator<LessonBloc>();
          },
        ),
        BlocProvider<VideoPlayerBloc>(
          create: (context) {
            return di.locator<VideoPlayerBloc>();
          },
        )
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            routerDelegate: router.routerDelegate,
            title: 'Arkademi Test',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                background: Colors.white,
              ),
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}
