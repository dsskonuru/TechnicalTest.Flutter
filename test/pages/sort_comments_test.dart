import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/ui/providers/comments_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_resources.dart';

void main() {
  group("pair programming tasks", () {
    test("comments are sorted by length", () {
      final List<CommentModel> _sortedComments = sortComments(comments);
      for (int i = 0; i < _sortedComments.length - 1; i++) {
        assert(
          _sortedComments[i].body.length <= _sortedComments[i + 1].body.length,
        );
      }
    });

    test(
        "comments are displayed only if they are more than 20 and less than 140 charactets in length",
        () {
      final List<CommentModel> _filteredComments = filterComments(comments);
      if (_filteredComments.isNotEmpty) {
        assert(_filteredComments.length > 20);
      }
      for (int i = 0; i < _filteredComments.length; i++) {
        assert(_filteredComments[i].body.length < 140);
      }
    });
  });
}
