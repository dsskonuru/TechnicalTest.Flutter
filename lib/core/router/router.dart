import 'package:auto_route/auto_route.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/comments_page.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/details_page.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/home_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, path: '/'),
    AutoRoute(page: DetailsPage, path: '/post/:postId'),
    AutoRoute(page: CommentsPage, path: '/post/:postId/comments'),
  ],
)
class $AppRouter {}
