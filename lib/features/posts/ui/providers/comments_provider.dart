import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/local_data_source.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';

final commentsProvider = StateNotifierProvider.autoDispose
    .family<CommentsNotifier, AsyncValue<List<CommentModel>>, int>(
  (ref, postId) {
    final localDataSource = ref.read(localDataSourceProvider);
    final remoteDataSource = ref.read(remoteDataSourceProvider);
    return CommentsNotifier(localDataSource, remoteDataSource, postId);
  },
);

class CommentsNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  CommentsNotifier(
    this._localDataSource,
    this._remoteDataSource,
    this._postId,
  ) : super(const AsyncLoading()) {
    _fetchComments(_postId);
  }
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final int _postId;

  Future<void> _fetchComments(int postId) async {
    final _comments = await _remoteDataSource.fetchComments(postId);
    if (_comments.error == NoConnectionFailure) {
      final _postIds = await _localDataSource.getPostIds();
      if (_postIds.contains(postId)) {
        final _savedComments = await _localDataSource.getComments(postId);
        final _filteredComments = filterComments(_savedComments);
        final _sortedComments = sortComments(_filteredComments);
        state = AsyncData(_sortedComments);
      }
    } else {
      final _filteredComments = filterComments(_comments.value!);
      final _sortedComments = sortComments(_filteredComments);
      state = AsyncData(_sortedComments);
    }
  }
}

List<CommentModel> sortComments(List<CommentModel> comments) {
  final List<CommentModel> _sortedComments = [];
  for (int i = 0; i < comments.length; i++) {
    for (int j = 0; j < _sortedComments.length; j++) {
      if (comments[i].body.length < _sortedComments[j].body.length) {
        _sortedComments.insert(j, comments[i]);
        break;
      }
    }
    if (!_sortedComments.contains(comments[i])) {
      _sortedComments.add(comments[i]);
    }
  }
  return _sortedComments;
}

List<CommentModel> filterComments(List<CommentModel> comments) {
  final List<CommentModel> _filteredComments = [];
  if (comments.length > 20) {
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].body.length < 140) {
        _filteredComments.add(comments[i]);
      }
    }
  }
  return _filteredComments;
}
