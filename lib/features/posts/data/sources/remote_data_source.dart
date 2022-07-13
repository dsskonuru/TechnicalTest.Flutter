import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/api/post_api.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  final _postApiService = PostsApiService.create();
  return RemoteDataSource(_postApiService);
});

class RemoteDataSource {
  RemoteDataSource(this._postApiService);
  final PostsApiService _postApiService;

  Future<AsyncValue<List<PostModel>>> getPostsList() async {
    try {
      final Response<List<PostModel>> response =
          await _postApiService.getPosts();
      return AsyncData(response.body!);
    } on SocketException {
      return AsyncError(NoConnectionFailure());
    } on HttpException {
      return AsyncError(ServerFailure());
    } on FormatException {
      return AsyncError(DataParsingFailure());
    }
  }

  Future<AsyncValue<PostModel>> getPost(int postId) async {
    try {
      final Response<PostModel> response =
          await _postApiService.getPost(postId);
      return AsyncData(response.body!);
    } on SocketException {
      return AsyncError(NoConnectionFailure());
    } on HttpException {
      return AsyncError(ServerFailure());
    } on FormatException {
      return AsyncError(DataParsingFailure());
    }
  }

  Future<AsyncValue<List<CommentModel>>> getComments(int postId) async {
    try {
      final Response<List<CommentModel>> response =
          await _postApiService.getComments(postId);
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
