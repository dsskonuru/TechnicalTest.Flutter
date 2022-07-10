import 'package:auto_route/auto_route.dart';
import 'package:flutter_tech_task/features/home/ui/pages/comments_page.dart';
import 'package:flutter_tech_task/features/home/ui/pages/details_page.dart';
import 'package:flutter_tech_task/features/home/ui/pages/list_page.dart';

@MaterialAutoRouter(
    replaceInRouteName: 'Page,Route',
    routes: <AutoRoute>[
      AutoRoute(page: ListPage, path: '/'), 
      AutoRoute(page: DetailsPage, path: '/post/:postId'),
      AutoRoute(page: CommentsPage, path: '/post/:postId/comments'),
    ],
)
class $AppRouter {}
