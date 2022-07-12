import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/local_source.dart';
import 'package:flutter_tech_task/features/home/data/sources/remote_source.dart';

final postsRepositoryProvider = ChangeNotifierProvider(
  (ref) => PostRepositoryChangeNotifier(),
);

// enum NotifierState { initial, loading, loaded }

class PostRepositoryChangeNotifier extends ChangeNotifier {
  // NotifierState _state = NotifierState.initial;
  // NotifierState get state => _state;
  // set state(NotifierState value) {
  //   _state = value;
  //   notifyListeners();
  // }

  final RemoteDataSource _remoteSource = RemoteDataSource();
  final LocalSource _localSource = LocalSource();

  final _savedPostIds = <int>{};
  List<int> get savedPostIds => _savedPostIds.toList();

  Future<void> bookmark(int postId) async {
    await _localSource.savePostToPrefs(postId);
    _savedPostIds.add(postId);
    await _localSource.updateSavedPostIds(savedPostIds);
    debugPrint(_savedPostIds.toString());
    notifyListeners();
  }

  Future<void> removeBookmark(int postId) async {
    await _localSource.removeSavedPost(postId);
    debugPrint(_savedPostIds.toString());
    notifyListeners();
  }

  Either<Failure, List<PostModel>>? _posts;
  Either<Failure, List<PostModel>>? get posts => _posts;
  void _setPosts(Either<Failure, List<PostModel>> posts) {
    _posts = posts;
    debugPrint("Posts are Set!");
    notifyListeners();
  }

  late Either<Failure, PostModel> _post;
  Either<Failure, PostModel> get post => _post;
  void _setPost(Either<Failure, PostModel> post) {
    _post = post;
    notifyListeners();
  }

  late Either<Failure, List<CommentModel>> _comments;
  Either<Failure, List<CommentModel>> get comments => _comments;
  void _setComments(Either<Failure, List<CommentModel>> comments) {
    _comments = comments;
    notifyListeners();
  }

  Future<void> getPost(int postId) async {
    try {
      final PostModel post = await _remoteSource.getPost(postId);
      _setPost(Right(post));
    } on Failure catch (remoteFailure) {
      if (_savedPostIds.contains(postId)) {
        final PostModel post = await _localSource.fetchSavedPost(postId);
        _setPost(Right(post));
      } else {
        _setPost(Left(remoteFailure));
      }
    }
  }

  Future<void> getPosts() async {
    try {
      final List<PostModel> posts = await _remoteSource.getPostsList();
      _setPosts(Right(posts));
    } on Failure catch (remoteFailure) {
      _setPosts(Left(remoteFailure));
    }
  }

  Future<void> getComments(int postId) async {
    try {
      final List<CommentModel> comments =
          await _remoteSource.getComments(postId);
      _setComments(Right(comments));
    } on Failure catch (remoteFailure) {
      if (_savedPostIds.contains(postId)) {
        final List<CommentModel> comments =
            await _localSource.fetchSavedComments(postId);
        _setComments(Right(comments));
      } else {
        _setComments(Left(remoteFailure));
      }
    }
  }
}
