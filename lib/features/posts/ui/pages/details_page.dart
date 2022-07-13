import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/post_provider.dart';

class DetailsPage extends ConsumerWidget {
  const DetailsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<PostModel> _asyncPost = ref.watch(postProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: _asyncPost.when(
        data: (_post) => Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              _post.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_post.body),
            onTap: () =>
                AutoRouter.of(context).push(CommentsRoute(postId: _post.id)),
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
