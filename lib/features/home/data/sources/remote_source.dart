import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/api/post_api.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';

final remoteDataSourceProvider =
    Provider<RemoteDataSource>((ref) => RemoteDataSource());

class RemoteDataSource {
  final PostsApiService _postApiService = PostsApiService.create();

  Future<List<PostModel>> getPostsList() async {
    try {
      final Response<List<PostModel>> response =
          await _postApiService.getPosts();
      return response.body!;
    } on SocketException {
      throw NoConnectionFailure();
    } on HttpException {
      throw ServerFailure();
    } on FormatException {
      throw DataParsingFailure();
    }
  }

  Future<PostModel> getPost(int postId) async {
    try {
      final Response<PostModel> response =
          await _postApiService.getPost(postId);
      return response.body!;
    } on SocketException {
      throw NoConnectionFailure();
    } on HttpException {
      throw ServerFailure();
    } on FormatException {
      throw DataParsingFailure();
    }
  }

  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final Response<List<CommentModel>> response =
          await _postApiService.getComments(postId);
      return response.body!;
    } on SocketException {
      throw NoConnectionFailure();
    } on HttpException {
      throw ServerFailure();
    } on FormatException {
      throw DataParsingFailure();
    }
  }
}
