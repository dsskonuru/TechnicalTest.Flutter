import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/local_data_source.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';

final postProvider = StateNotifierProvider.autoDispose
    .family<PostNotifier, AsyncValue<PostModel>, int>(
  (ref, postId) {
    final localDataSource = ref.read(localDataSourceProvider);
    final remoteDataSource = ref.read(remoteDataSourceProvider);
    return PostNotifier(localDataSource, remoteDataSource, postId);
  },
);

class PostNotifier extends StateNotifier<AsyncValue<PostModel>> {
  PostNotifier(this._localDataSource, this._remoteDataSource, this._postId)
      : super(const AsyncLoading()) {
    fetchPost(_postId);
  }
  final LocalDataSource _localDataSource;
  final RemoteDataSource _remoteDataSource;
  final int _postId;

  Future<void> fetchPost(int postId) async {
    state = const AsyncLoading();
    final _asyncPost = await _remoteDataSource.fetchPost(postId);
    if (_asyncPost.hasError && _asyncPost.error is NoConnectionFailure) {
      final _savedPostIds = await _localDataSource.fetchSavedPostIds();
      if (_savedPostIds.contains(postId)) {
        final _savedPost = await _localDataSource.fetchSavedPost(postId);
        state = AsyncData(_savedPost);
      }
    } else {
      state = _asyncPost;
    }
  }
}
