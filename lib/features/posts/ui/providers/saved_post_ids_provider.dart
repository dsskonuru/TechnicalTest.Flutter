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
  SavedPostIdsNotifier(this._localDataSource) : super(const AsyncLoading()) {
    getSavedPostIds();
  }

  final LocalDataSource _localDataSource;

  Future<void> getSavedPostIds() async {
    final _savedPostIds = await _localDataSource.fetchSavedPostIds();
    debugPrint(_savedPostIds.toString());
    state = AsyncData(_savedPostIds.toSet());
  }

  Future<void> add(int postId) async {
    // state = const AsyncLoading();
    await _localDataSource.savePost(postId);
    final _updatedState = {...state.value!, postId};
    await _localDataSource.updateSavedPostIds(_updatedState.toList());
    debugPrint(_updatedState.toString());
    state = AsyncData(_updatedState);
  }

  Future<void> remove(int postId) async {
    // state = const AsyncLoading();
    await _localDataSource.removeSavedPost(postId);
    final _state = state.value!;
    _state.remove(postId);
    await _localDataSource.updateSavedPostIds(state.value!.toList());
    state = AsyncData(_state);
  }
}
