import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repository.dart';

class DetailsPage extends ConsumerWidget {
  const DetailsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: FutureBuilder(
        future: ref.read(postsRepositoryProvider).getPost(postId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Either<Failure, PostModel>? _postOrFailure =
                ref.watch(postsRepositoryProvider.select((p) => p.post));
            return _postOrFailure!.fold(
              (err) => Center(child: Text('Error: $err')),
              (_post) => Card(
                elevation: 4,
                child: ListTile(
                  title: Text(
                    _post.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_post.body),
                  onTap: () => AutoRouter.of(context)
                      .push(CommentsRoute(postId: _post.id)),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
