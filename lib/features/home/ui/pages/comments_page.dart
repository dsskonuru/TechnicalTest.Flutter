import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repo.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _comments = ref.watch(commentsProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _comments.when(
        data: (postsOrFailure) => _buildComments(context, postsOrFailure),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}

Widget _buildComments(
  BuildContext context,
  Either<Exception, List<CommentModel>> commentsOrFailure,
) =>
    commentsOrFailure.fold(
      (err) => Center(child: Text('Error: $err')),
      (_comments) => ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_comments[index].name),
          subtitle: Text(_comments[index].body),
          trailing: Text(_comments[index].email),
        ),
      ),
    );
