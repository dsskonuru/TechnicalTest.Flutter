import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _comments[index].name,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  
                  const SizedBox(height: 8),
                  Text(
                    _comments[index].email,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _comments[index].body,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, st) => handleErrorUI(err, st),
      ),
    );
  }
}
