import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';

final postsProvider = StateNotifierProvider.autoDispose<PostsNotifier,
    AsyncValue<List<PostModel>>>(
  (ref) {
    final _remoteDataSource = ref.read(remoteDataSourceProvider);
    return PostsNotifier(_remoteDataSource);
  },
);

class PostsNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  PostsNotifier(this._remoteDataSource) : super(const AsyncLoading()) {
    _fetchPostsList();
  }
  final RemoteDataSource _remoteDataSource;

  Future<void> _fetchPostsList() async {
    state = await _remoteDataSource.fetchPosts();
  }
}
