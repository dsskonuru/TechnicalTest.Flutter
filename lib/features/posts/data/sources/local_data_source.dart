import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_tech_task/main.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final _remoteDataSource = ref.read(remoteDataSourceProvider);
  return LocalDataSource(_remoteDataSource);
});

class LocalDataSource {
  LocalDataSource(this._remoteDataSource);
  final RemoteDataSource _remoteDataSource;

  Future<void> updateSavedPostIds(List<int> savedPostIds) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final _isSaved = await prefs.setStringList(
      "savedPostsIds",
      savedPostIds.map((postId) => postId.toString()).toList(),
    );
    if (_isSaved) {
      debugPrint(savedPostIds.toString());
      return;
    } else {
      throw Exception("Failed to save post ids");
    }
  }

  Future<AsyncValue<List<int>>> fetchSavedPostIds() async {
    try {
      final prefs = await container.read(sharedPreferencesProvider);
      final savedPostIds = prefs.getStringList("savedPostsIds");
      if (savedPostIds == null) {
        return const AsyncData([]);
      } else {
        return AsyncData(
          savedPostIds.map((postId) => int.parse(postId)).toList(),
        );
      }
    } on Exception catch (e) {
      return AsyncError(e);
    }
  }

  Future<void> savePost(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    bool _isPostSaved = false;
    await _remoteDataSource.getPost(postId).then((_asyncPost) async {
      final String _postJson = jsonEncode(_asyncPost.value!.toJson());
      _isPostSaved = await prefs.setString(postId.toString(), _postJson);
    });
    bool _areCommentsSaved = false;
    await _remoteDataSource.getComments(postId).then((_asyncComments) async {
      final String _commentJson = jsonEncode(_asyncComments.value);
      _areCommentsSaved = await prefs.setString(
        "${postId}_comments",
        _commentJson,
      );
    });
    if (_isPostSaved && _areCommentsSaved) {
      return;
    } else {
      throw Exception("Failed to save post");
    }
  }

  Future<void> removeSavedPost(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final _postRemoval = await prefs.remove(postId.toString());
    final _commentsRemoval = await prefs.remove("${postId}_comments");
    if (_postRemoval && _commentsRemoval) {
      return;
    } else {
      throw Exception("Failed to remove post");
    }
  }

  Future<AsyncValue<PostModel>> fetchSavedPost(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final String? _postJson = prefs.getString(postId.toString());
    if (_postJson != null) {
      final PostModel _post =
          PostModel.fromJson(jsonDecode(_postJson) as Map<String, dynamic>);
      return AsyncData(_post);
    } else {
      return AsyncError(Exception("Failed to fetch post $postId"));
    }
  }

  Future<AsyncValue<List<CommentModel>>> fetchSavedComments(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final String? _commentsJson = prefs.getString("${postId}_comments");
    if (_commentsJson != null) {
      final List<CommentModel> _comments = (jsonDecode(_commentsJson) as List)
          .map(
            (comment) => CommentModel.fromJson(comment as Map<String, dynamic>),
          )
          .toList();
      return AsyncData(_comments);
    } else {
      return AsyncError(Exception("Failed to fetch comments for post $postId"));
    }
  }

  Future<AsyncValue<List<PostModel>>> fetchSavedPosts() async {
    final _asyncSavedPostIds = await fetchSavedPostIds();
    return _asyncSavedPostIds.when(
      data: (_savedPostIds) async {
        if (_savedPostIds.isNotEmpty) {
          final List<PostModel> _posts = [];
          for (final postId in _savedPostIds) {
            final _asyncSavedPost = await fetchSavedPost(postId);
            _asyncSavedPost.whenData((_savedPost) {
              _posts.add(_savedPost);
            });
          }
          return AsyncData(_posts);
        } else {
          return AsyncError(NoBookmarkedPostsFailure());
        }
      },
      error: (_error, stackTrace) {
        return AsyncError(_error);
      },
      loading: () => const AsyncLoading(),
    );
  }
}
