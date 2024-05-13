import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_play/src/presentation/pages/lesson_main.dart';

enum AppRoute {
  lessonScreen,
}

GoRouter router = GoRouter(
  initialLocation: '/',
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.lessonScreen.name,
      builder: (context, state) {
        return const MainLessonView();
      },
    )
  ],
);
