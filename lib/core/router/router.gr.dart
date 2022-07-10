// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../../features/home/ui/pages/comments_page.dart' as _i3;
import '../../features/home/ui/pages/details_page.dart' as _i2;
import '../../features/home/ui/pages/list_page.dart' as _i1;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    ListRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.ListPage());
    },
    DetailsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<DetailsRouteArgs>(
          orElse: () => DetailsRouteArgs(postId: pathParams.getInt('postId')));
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i2.DetailsPage(postId: args.postId, key: args.key));
    },
    CommentsRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CommentsRouteArgs>(
          orElse: () => CommentsRouteArgs(postId: pathParams.getInt('postId')));
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.CommentsPage(postId: args.postId, key: args.key));
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(ListRoute.name, path: '/'),
        _i4.RouteConfig(DetailsRoute.name, path: '/post/:postId'),
        _i4.RouteConfig(CommentsRoute.name, path: '/post/:postId/comments')
      ];
}

/// generated route for
/// [_i1.ListPage]
class ListRoute extends _i4.PageRouteInfo<void> {
  const ListRoute() : super(ListRoute.name, path: '/');

  static const String name = 'ListRoute';
}

/// generated route for
/// [_i2.DetailsPage]
class DetailsRoute extends _i4.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({required int postId, _i5.Key? key})
      : super(DetailsRoute.name,
            path: '/post/:postId',
            args: DetailsRouteArgs(postId: postId, key: key),
            rawPathParams: {'postId': postId});

  static const String name = 'DetailsRoute';
}

class DetailsRouteArgs {
  const DetailsRouteArgs({required this.postId, this.key});

  final int postId;

  final _i5.Key? key;

  @override
  String toString() {
    return 'DetailsRouteArgs{postId: $postId, key: $key}';
  }
}

/// generated route for
/// [_i3.CommentsPage]
class CommentsRoute extends _i4.PageRouteInfo<CommentsRouteArgs> {
  CommentsRoute({required int postId, _i5.Key? key})
      : super(CommentsRoute.name,
            path: '/post/:postId/comments',
            args: CommentsRouteArgs(postId: postId, key: key),
            rawPathParams: {'postId': postId});

  static const String name = 'CommentsRoute';
}

class CommentsRouteArgs {
  const CommentsRouteArgs({required this.postId, this.key});

  final int postId;

  final _i5.Key? key;

  @override
  String toString() {
    return 'CommentsRouteArgs{postId: $postId, key: $key}';
  }
}
