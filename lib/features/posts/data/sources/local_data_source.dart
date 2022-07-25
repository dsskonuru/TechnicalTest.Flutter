import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final _remoteDataSource = ref.read(remoteDataSourceProvider);
  return LocalDataSourceImpl(_remoteDataSource);
});

abstract class LocalDataSource {
  Future<void> savePostIds(List<int> postIds);
  Future<List<int>> getPostIds();

  Future<AsyncValue<void>> savePostAndComments(int postId);
  Future<void> removePost(int postId);

  Future<PostModel> getPost(int postId);
  Future<List<CommentModel>> getComments(int postId);

  Future<List<PostModel>> getPosts();
}

class LocalDataSourceImpl implements LocalDataSource {
  LocalDataSourceImpl(this._remoteDataSource);
  final RemoteDataSource _remoteDataSource;

  @override
  Future<void> savePostIds(List<int> savedPostIds) async {
    final prefs = await SharedPreferences.getInstance();
    final _isSaved = await prefs.setStringList(
      "saved_post_ids",
      savedPostIds.map((postId) => postId.toString()).toList(),
    );
    if (!_isSaved) {
      throw Exception("Failed to save post ids");
    }
  }

  @override
  Future<List<int>> getPostIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPostIds = prefs.getStringList("saved_post_ids");
    if (savedPostIds != null) {
      return savedPostIds.map((postId) => int.parse(postId)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<AsyncValue<void>> savePostAndComments(int postId) async {
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

  @override
  Future<void> removePost(int postId) async {
    final prefs = await SharedPreferences.getInstance();
    final _postRemoval = await prefs.remove("post_$postId");
    final _commentsRemoval = await prefs.remove("comments_$postId");
    if (_postRemoval && _commentsRemoval) {
      return;
    } else {
      throw Exception("Failed to remove post");
    }
  }

  @override
  Future<PostModel> getPost(int postId) async {
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

  @override
  Future<List<CommentModel>> getComments(int postId) async {
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

  @override
  Future<List<PostModel>> getPosts() async {
    final List<int> _savedPostIds = await getPostIds();
    final List<PostModel> _posts = [];
    for (final postId in _savedPostIds) {
      final _savedPost = await getPost(postId);
      _posts.add(_savedPost);
    }
    return _posts;
  }
}
