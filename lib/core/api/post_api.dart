import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tech_task/core/api/connectivity_interceptor.dart';
import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';

part 'post_api.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class PostsApiService extends ChopperService {
  static PostsApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      services: [
        _$PostsApiService(),
      ],
      interceptors: [
        HttpLoggingInterceptor(),
        ConnectivityInterceptor(),
      ],
    );
    return _$PostsApiService(client);
  }

  static FutureOr<Response> convertPostsResponse(Response response) {
    final decodedResponse = jsonDecode(response.bodyString);
    if (decodedResponse is List) {
      final _posts = decodedResponse
          .map((post) => PostModel.fromJson(post as Map<String, Object?>))
          .toList();
      return response.copyWith(body: _posts);
    } else if (decodedResponse is Map) {
      return response.copyWith(
        body: PostModel.fromJson(decodedResponse as Map<String, Object?>),
      );
    }
    return response.copyWith(body: decodedResponse);
  }

  static FutureOr<Response> convertCommentsResponse(Response response) {
    final decodedResponse = jsonDecode(response.bodyString);
    debugPrint("Converting Comments!!!");
    debugPrint(decodedResponse.toString());
    if (decodedResponse is List) {
      final _comments = decodedResponse
          .map(
            (comment) => CommentModel.fromJson(comment as Map<String, Object?>),
          )
          .toList();
      return response.copyWith(body: _comments);
    } else {
      return response.copyWith(body: decodedResponse);
    }
  }

  @Get()
  @FactoryConverter(response: convertPostsResponse)
  Future<Response<List<PostModel>>> getPosts();

  @Get(path: '/{id}')
  @FactoryConverter(response: convertPostsResponse)
  Future<Response<PostModel>> getPost(@Path('id') int id);

  @Get(path: '/{id}/comments')
  @FactoryConverter(response: convertCommentsResponse)
  Future<Response<List<CommentModel>>> getComments(@Path('id') int id);
}
