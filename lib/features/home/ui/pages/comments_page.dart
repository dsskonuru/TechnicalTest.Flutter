import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repository.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: FutureBuilder(
        future: ref.read(postsRepositoryProvider).getComments(postId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Either<Failure, List<CommentModel>>? _commentsOrFailure =
                ref.watch(postsRepositoryProvider.select((p) => p.comments));
            return _commentsOrFailure!.fold(
              (err) => Center(child: Text('Error: $err')),
              (_comments) => ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) => Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      _comments[index].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_comments[index].body),
                    trailing: Text(_comments[index].email),
                  ),
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
