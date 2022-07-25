import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BookmarkWidget extends StatelessWidget {
  const BookmarkWidget(
    this.bookmark, {
    Key? key,
  }) : super(key: key);

  final PostModel bookmark;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          bookmark.title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
        ),
        subtitle: Text(bookmark.body),
        onTap: () =>
            AutoRouter.of(context).push(DetailsRoute(postId: bookmark.id)),
      ),
    );
  }
}
