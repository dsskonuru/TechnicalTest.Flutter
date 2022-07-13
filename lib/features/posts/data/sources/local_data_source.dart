import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final _remoteDataSource = ref.read(remoteDataSourceProvider);
  return LocalDataSource(_remoteDataSource);
});

class LocalDataSource {
  LocalDataSource(this._remoteDataSource);
  final RemoteDataSource _remoteDataSource;

  Future<void> updateSavedPostIds(List<int> savedPostIds) async {
    final prefs = await SharedPreferences.getInstance();
    final _isSaved = await prefs.setStringList(
      "saved_post_ids",
      savedPostIds.map((postId) => postId.toString()).toList(),
    );
    if (!_isSaved) {
      throw Exception("Failed to save post ids");
    }
  }

  Future<List<int>> fetchSavedPostIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPostIds = prefs.getStringList("saved_post_ids");
    if (savedPostIds != null) {
      return savedPostIds.map((postId) => int.parse(postId)).toList();
    } else {
      return [];
    }
  }

  Future<AsyncValue<void>> savePost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final AsyncValue<PostModel> _asyncPost =
          await _remoteDataSource.fetchPost(postId);
      final PostModel post = _asyncPost.value!;
      final String _postJson = jsonEncode(post.toJson());
      final _isSaved = await prefs.setString("post_$postId", _postJson);

      final AsyncValue<List<CommentModel>> _asyncComments =
          await _remoteDataSource.fetchComments(postId);
      final List<CommentModel> comments = _asyncComments.value!;
      final String _commentsJson = jsonEncode(comments);
      final _isSavedComments =
          await prefs.setString("comments_$postId", _commentsJson);

      if (!_isSaved || !_isSavedComments) {
        throw Exception("Failed to save post");
      }
      return const AsyncData(null);
    } on Failure catch (e) {
      return AsyncError(e);
    }
  }

  Future<void> removeSavedPost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final _postRemoval = await prefs.remove("post_$postId");
    final _commentsRemoval = await prefs.remove("comments_$postId");
    if (_postRemoval && _commentsRemoval) {
      return;
    } else {
      throw Exception("Failed to remove post");
    }
  }

  Future<PostModel> fetchSavedPost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? _postJson = prefs.getString("post_$postId");
    if (_postJson != null) {
      final PostModel _post =
          PostModel.fromJson(jsonDecode(_postJson) as Map<String, dynamic>);
      return _post;
    } else {
      throw Exception("Failed to fetch post");
    }
  }

  Future<List<CommentModel>> fetchSavedComments(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? _commentsJson = prefs.getString("comments_$postId");
    if (_commentsJson != null) {
      final List<CommentModel> _comments = (jsonDecode(_commentsJson) as List)
          .map(
            (comment) => CommentModel.fromJson(comment as Map<String, dynamic>),
          )
          .toList();
      return _comments;
    } else {
      throw Exception("Failed to fetch comments for post $postId");
    }
  }

  Future<List<PostModel>> fetchSavedPosts() async {
    final List<int> _savedPostIds = await fetchSavedPostIds();
    final List<PostModel> _posts = [];
    for (final postId in _savedPostIds) {
      final _savedPost = await fetchSavedPost(postId);
      _posts.add(_savedPost);
    }
    return _posts;
  }
}
