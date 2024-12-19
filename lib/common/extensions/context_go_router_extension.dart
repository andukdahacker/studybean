import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension ContextGoRouterExtension on BuildContext {
  GoRouter get router => GoRouter.of(this);

  Map<String, String> get queryParams => GoRouterState.of(this).uri.queryParameters;

  Map<String, String> get pathParams => GoRouterState.of(this).pathParameters;

  Uri get location => GoRouterState.of(this).uri;

}