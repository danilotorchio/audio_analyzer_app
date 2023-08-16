import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:audio_sentiment_app/pages/pages.dart';

class Routes {
  late final GoRouter router;

  static final Routes _instance = Routes._internal();
  factory Routes() => _instance;

  Routes._internal() {
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/positive',
          name: 'positive',
          pageBuilder: (context, state) {
            final message = state.uri.queryParameters['m'] ?? '';
            return _withCustomTransition(PositivePage(message: message));
          },
        ),
        GoRoute(
          path: '/negative',
          name: 'negative',
          pageBuilder: (context, state) {
            final message = state.uri.queryParameters['m'] ?? '';
            return _withCustomTransition(NegativePage(message: message));
          },
        ),
        GoRoute(
          path: '/neutral',
          name: 'neutral',
          pageBuilder: (context, state) {
            final message = state.uri.queryParameters['m'] ?? '';
            return _withCustomTransition(NeutralPage(message: message));
          },
        ),
      ],
    );
  }

  CustomTransitionPage<dynamic> _withCustomTransition(Widget page) {
    return CustomTransitionPage(
      child: page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }
}
