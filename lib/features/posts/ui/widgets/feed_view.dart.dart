import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/posts_provider.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/feed_post_widget.dart';

class FeedView extends ConsumerWidget {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> _posts = ref.watch(postsProvider);
    return _posts.when(
      data: (_posts) {
        return ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) => FeedPostWidget(_posts[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => handleErrorUI(err, st),
    );
  }
}
