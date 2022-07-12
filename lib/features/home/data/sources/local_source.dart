import 'dart:convert';

import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/remote_source.dart';
import 'package:flutter_tech_task/main.dart';

class LocalSource {
  final RemoteDataSource _remoteDataSource =
      container.read(remoteDataSourceProvider);

  Future<void> updateSavedPostIds(List<int> savedPostIds) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final _isSaved = await prefs.setStringList(
      "savedPostsIds",
      savedPostIds.map((postId) => postId.toString()).toList(),
    );
    if (_isSaved) {
      return;
    } else {
      throw Exception("Failed to save post ids");
    }
  }

  Future<void> savePostToPrefs(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    bool _isPostSaved = false;
    await _remoteDataSource.getPost(postId).then((_post) async {
      final String _commentJson = jsonEncode(_post);
      _isPostSaved = await prefs.setString("${postId}_comments", _commentJson);
    });
    bool _areCommentsSaved = false;
    await _remoteDataSource.getComments(postId).then((_comments) async {
      final String _commentJson = jsonEncode(_comments);
      _areCommentsSaved =
          await prefs.setString("${postId}_comments", _commentJson);
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

  Future<PostModel> fetchSavedPost(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final String? _postJson = prefs.getString(postId.toString());
    if (_postJson != null) {
      final PostModel _post =
          PostModel.fromJson(jsonDecode(_postJson) as Map<String, dynamic>);
      return _post;
    } else {
      throw Exception("Failed to fetch post $postId");
    }
  }

  Future<List<CommentModel>> fetchSavedComments(int postId) async {
    final prefs = await container.read(sharedPreferencesProvider);
    final String? _commentsJson = prefs.getString("${postId}_comments");
    if (_commentsJson != null) {
      final List<CommentModel> _comments =
          (jsonDecode(_commentsJson) as List<Map<String, dynamic>>)
              .map((comment) => CommentModel.fromJson(comment))
              .toList();
      return _comments;
    } else {
      throw Exception("Failed to fetch comments for post $postId");
    }
  }

  Future<List<PostModel>> fetchSavedPosts() async {
    final prefs = await container.read(sharedPreferencesProvider);
    final List<String> _postIds = prefs.getStringList("savedPostsIds") ?? [];
    if (_postIds.isNotEmpty) {
      final List<PostModel> _posts = [];
      for (final postId in _postIds) {
        final PostModel _post = await fetchSavedPost(int.parse(postId));
        _posts.add(_post);
      }
      return _posts;
    } else {
      throw NoBookmarkedPostsFailure();
    }
  }
}
