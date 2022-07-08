import 'package:auto_route/auto_route.dart';
import 'package:flutter_tech_task/features/home/ui/pages/details_page.dart';
import 'package:flutter_tech_task/features/home/ui/pages/list_page.dart';

@MaterialAutoRouter(
    replaceInRouteName: 'Page,Route',
    routes: <AutoRoute>[
      AutoRoute(page: ListPage, initial: true),
      AutoRoute(page: DetailsPage),
    ],
)
class $AppRouter {}
