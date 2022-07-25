import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/error_ui.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/bookmarks_provider.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/bookmark_widget.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/no_bookmarks_widget.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostModel>> _bookmarks = ref.watch(bookmarksProvider);
    return _bookmarks.when(
      data: (_bookmarks) {
        if (_bookmarks.isEmpty) {
          return const NoBookmarksWidget();
        }
        return ListView.builder(
          itemCount: _bookmarks.length,
          itemBuilder: (context, index) => BookmarkWidget(_bookmarks[index]),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, st) => handleErrorUI(err, st),
    );
  }
}
