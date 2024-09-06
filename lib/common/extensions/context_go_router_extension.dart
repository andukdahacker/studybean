import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextGoRouterExtension on BuildContext {
  GoRouter get router => GoRouter.of(this);

  Uri get currentPath => router.routerDelegate.currentConfiguration.uri;
}