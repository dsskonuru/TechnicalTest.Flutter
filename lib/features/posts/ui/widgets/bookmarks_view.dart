import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/bookmarks_provider.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> _bookmarks = ref.watch(bookmarksProvider);

    return _bookmarks.when(
      data: (_bookmarks) {
        return ListView.builder(
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) => Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  _bookmarks[index].title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_bookmarks[index].body),
                onTap: () => AutoRouter.of(context)
                    .push(DetailsRoute(postId: _bookmarks[index].id)),
              ),
            ),
          );
      },
      error: (err, st) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),

    );
  }
}
