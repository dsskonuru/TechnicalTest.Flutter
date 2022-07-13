import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/posts_provider.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/saved_post_ids_provider.dart';

class FeedView extends ConsumerWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> _posts = ref.watch(postsProvider);
    final AsyncValue<Set<int>> _savedPostIds = ref.watch(savedPostIdsProvider);

    return _posts.when(
      data: (_posts) {
        return ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) => Card(
            elevation: 4,
            child: ListTile(
              title: Text(
                _posts[index].title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_posts[index].body),
              trailing: IconButton(
                icon: _savedPostIds.when(
                  data: (savedPostIds) {
                    return savedPostIds.contains(_posts[index].id)
                        ? const Icon(Icons.bookmark)
                        : const Icon(Icons.bookmark_border_rounded);
                  },
                  error: (err, s) => const Icon(Icons.bookmark_border_rounded),
                  loading: () => const Icon(Icons.bookmark_border_rounded),
                ),
                color: _savedPostIds.when(
                  data: (savedPostIds) {
                    return savedPostIds.contains(_posts[index].id)
                        ? Colors.red
                        : Colors.grey;
                  },
                  error: (err, s) => Colors.grey,
                  loading: () => Colors.grey,
                ),
                onPressed: () {
                  _savedPostIds.whenData(
                    (savedPostIds) {
                      if (savedPostIds.contains(_posts[index].id)) {
                        ref
                            .watch(savedPostIdsProvider.notifier)
                            .remove(_posts[index].id);
                      } else {
                        ref
                            .watch(savedPostIdsProvider.notifier)
                            .add(_posts[index].id);
                      }
                    },
                  );
                },
              ),
              onTap: () => AutoRouter.of(context)
                  .push(DetailsRoute(postId: _posts[index].id)),
            ),
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (err, st) => handleErrorUI(err, st),
    );
  }
}
