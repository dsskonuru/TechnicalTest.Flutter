import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/local_data_source.dart';

final bookmarksProvider = StateNotifierProvider.autoDispose<BookmarksNotifier,
    AsyncValue<List<PostModel>>>(
  (ref) {
    final _localDataSource = ref.read(localDataSourceProvider);
    return BookmarksNotifier(_localDataSource);
  },
);

class BookmarksNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  BookmarksNotifier(this._localDataSource) : super(const AsyncLoading()) {
    fetchSavedPosts();
  }
  final LocalDataSource _localDataSource;

  Future<void> fetchSavedPosts() async {
    state = await _localDataSource.fetchSavedPosts();
  }
}
