import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/sources/local_data_source.dart';

final savedPostIdsProvider = StateNotifierProvider.autoDispose<
    SavedPostIdsNotifier, AsyncValue<Set<int>>>(
  (ref) {
    final _localDataSource = ref.read(localDataSourceProvider);
    return SavedPostIdsNotifier(_localDataSource);
  },
);

class SavedPostIdsNotifier extends StateNotifier<AsyncValue<Set<int>>> {
  SavedPostIdsNotifier(this._localDataSource) : super(const AsyncData(<int>{})) {
    _getSavedPostIds();
  }

  final LocalDataSource _localDataSource;

  Future<void> _getSavedPostIds() async {
    final _savedPostIds = await _localDataSource.getPostIds();
    debugPrint(_savedPostIds.toString());
    state = AsyncData(_savedPostIds.toSet());
  }

  Future<void> add(int postId) async {
    await _localDataSource.savePostAndComments(postId);
    final _updatedState = {...state.value!, postId};
    await _localDataSource.savePostIds(_updatedState.toList());
    debugPrint(_updatedState.toString());
    state = AsyncData(_updatedState);
  }

  Future<void> remove(int postId) async {
    await _localDataSource.removePost(postId);
    final _state = state.value!;
    _state.remove(postId);
    await _localDataSource.savePostIds(state.value!.toList());
    state = AsyncData(_state);
  }
}
