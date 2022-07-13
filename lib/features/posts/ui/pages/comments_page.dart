import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/comments_provider.dart';

class CommentsPage extends ConsumerWidget {
  const CommentsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _asyncComments = ref.watch(commentsProvider(postId));
    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: _asyncComments.when(
        data: (_comments) => ListView.builder(
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
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
