import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/saved_post_ids_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedPostWidget extends ConsumerWidget {
  const FeedPostWidget(
    this.post, {
    Key? key,
  }) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Set<int>> _savedPostIds = ref.watch(savedPostIdsProvider);
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          post.title,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
        ),
        subtitle: Text(post.body),
        trailing: IconButton(
          icon: _savedPostIds.when(
            data: (savedPostIds) => savedPostIds.contains(post.id)
                ? const Icon(Icons.bookmark)
                : const Icon(Icons.bookmark_border_rounded),
            error: (err, s) => const Icon(Icons.bookmark_border_rounded),
            loading: () => const Icon(Icons.bookmark_border_rounded),
          ),
          color: _savedPostIds.when(
            data: (savedPostIds) =>
                savedPostIds.contains(post.id) ? Colors.red : Colors.grey,
            error: (err, s) => Colors.grey,
            loading: () => Colors.grey,
          ),
          onPressed: () {
            final savedPostIds = _savedPostIds.value ?? {};
            if (savedPostIds.contains(post.id)) {
              ref.watch(savedPostIdsProvider.notifier).remove(post.id);
            } else {
              ref.watch(savedPostIdsProvider.notifier).add(post.id);
            }
          },
        ),
        onTap: () => AutoRouter.of(context).push(DetailsRoute(postId: post.id)),
      ),
    );
  }
}
