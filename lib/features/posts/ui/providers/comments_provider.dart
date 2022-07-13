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
    getComments(_postId);
  }
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final int _postId;

  Future<void> getComments(int postId) async {
    final _comments = await _remoteDataSource.getComments(postId);
    if (_comments.hasError && _comments.error is NoConnectionFailure) {
      final _savedPostIds = await _localDataSource.fetchSavedPostIds();
      if (_savedPostIds.value!.contains(postId)) {
        final _savedComments =
            await _localDataSource.fetchSavedComments(postId);
        state = _savedComments;
      }
    } else {
      state = _comments;
    }
  }
}
