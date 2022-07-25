import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/api/post_api.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final _postApiService = PostsApiService.create();
  return RemoteDataSourceImpl(_postApiService);
});

abstract class RemoteDataSource {
  Future<AsyncValue<PostModel>> fetchPost(int postId);
  Future<AsyncValue<List<CommentModel>>> fetchComments(int postId);
  Future<AsyncValue<List<PostModel>>> fetchPosts();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  RemoteDataSourceImpl(this._postApiService);
  final PostsApiService _postApiService;

  @override
  Future<AsyncValue<List<PostModel>>> fetchPosts() async {
    try {
      final Response<List<PostModel>> response =
          await _postApiService.fetchPosts();
      return AsyncData(response.body!);
    } on SocketException {
      return AsyncError(NoConnectionFailure());
    } on HttpException {
      return AsyncError(ServerFailure());
    } on FormatException {
      return AsyncError(DataParsingFailure());
    }
  }

  @override
  Future<AsyncValue<PostModel>> fetchPost(int postId) async {
    try {
      final Response<PostModel> response =
          await _postApiService.fetchPost(postId);
      return AsyncData(response.body!);
    } on SocketException {
      return AsyncError(NoConnectionFailure());
    } on HttpException {
      return AsyncError(ServerFailure());
    } on FormatException {
      return AsyncError(DataParsingFailure());
    }
  }

  @override
  Future<AsyncValue<List<CommentModel>>> fetchComments(int postId) async {
    try {
      final Response<List<CommentModel>> response =
          await _postApiService.fetchComments(postId);
      return AsyncData(response.body!);
    } on SocketException {
      return AsyncError(NoConnectionFailure());
    } on HttpException {
      return AsyncError(ServerFailure());
    } on FormatException {
      return AsyncError(DataParsingFailure());
    }
  }
}
