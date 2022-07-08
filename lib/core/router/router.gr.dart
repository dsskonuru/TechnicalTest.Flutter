// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../../features/home/ui/pages/details_page.dart' as _i2;
import '../../features/home/ui/pages/list_page.dart' as _i1;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    ListRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.ListPage());
    },
    DetailsRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.DetailsPage());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(ListRoute.name, path: '/'),
        _i3.RouteConfig(DetailsRoute.name, path: '/details-page')
      ];
}

/// generated route for
/// [_i1.ListPage]
class ListRoute extends _i3.PageRouteInfo<void> {
  const ListRoute() : super(ListRoute.name, path: '/');

  static const String name = 'ListRoute';
}

/// generated route for
/// [_i2.DetailsPage]
class DetailsRoute extends _i3.PageRouteInfo<void> {
  const DetailsRoute() : super(DetailsRoute.name, path: '/details-page');

  static const String name = 'DetailsRoute';
}
