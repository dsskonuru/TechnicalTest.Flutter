import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/comments_provider.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/comment_widget.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/no_comments_widget.dart';

class CommentsPage extends ConsumerStatefulWidget {
  const CommentsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);
  final int postId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    final _asyncComments = ref.watch(commentsProvider(widget.postId));
    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.postId}'),
      ),
      body: _asyncComments.when(
        data: (_comments) {
          if (_comments.isEmpty) {
            return const NoCommentsWidget();
          }
          return ListView.builder(
            itemCount: _comments.length,
            itemBuilder: (context, index) => CommentWidget(_comments[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => handleErrorUI(err, st),
      ),
    );
  }
}
