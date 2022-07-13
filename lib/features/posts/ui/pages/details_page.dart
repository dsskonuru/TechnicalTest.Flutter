import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/core/theme/theme_data.dart';
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
        data: (_post) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(   
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_post.title, style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 8),
              Text(_post.body, style: Theme.of(context).textTheme.bodyText1),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => AutoRouter.of(context)
                    .push(CommentsRoute(postId: _post.id)),
                style: buttonStyle,
                child: Text(
                  "Comments",
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
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
