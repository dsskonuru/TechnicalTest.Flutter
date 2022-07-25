import 'package:flutter/material.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(
    this.comment, {
    Key? key,
  }) : super(key: key);

  final CommentModel comment;
  @override
  Widget build(
    BuildContext context,
  ) => Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.name,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(fontSize: 20.sp),
            ),
            const SizedBox(height: 8),
            Text(
              comment.email,
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  ?.copyWith(fontSize: 17.sp),
            ),
            const SizedBox(height: 8),
            Text(
              comment.body,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
}
