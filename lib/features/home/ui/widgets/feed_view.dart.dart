import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repository.dart';

class FeedView extends ConsumerWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _fetchPosts = ref.read(postsRepositoryProvider).getPosts();

    final _savedPostIds = ref.read(postsRepositoryProvider).savedPostIds;
    final _postsOrFailure =
        ref.watch(postsRepositoryProvider.select((p) => p.posts));

    if (_postsOrFailure == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return _postsOrFailure.fold(
        (err) => Center(child: Text('Error: $err')),
        (_posts) => ListView.builder(
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
                icon: _savedPostIds.contains(_posts[index].id)
                    ? const Icon(Icons.bookmark_added_rounded)
                    : const Icon(Icons.bookmark_border_outlined),
                color: _savedPostIds.contains(_posts[index].id)
                    ? Colors.red
                    : Colors.grey,
                onPressed: () {
                  _savedPostIds.contains(_posts[index].id)
                      ? ref
                          .read(postsRepositoryProvider)
                          .removeBookmark(_posts[index].id)
                      : ref
                          .read(postsRepositoryProvider)
                          .bookmark(_posts[index].id);
                },
              ),
              onTap: () => AutoRouter.of(context)
                  .push(DetailsRoute(postId: _posts[index].id)),
            ),
          ),
        ),
      );
    }
  }
}
