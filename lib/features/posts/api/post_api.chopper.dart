// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_api.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$PostsApiService extends PostsApiService {
  _$PostsApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = PostsApiService;

  @override
  Future<Response<List<PostModel>>> getPosts() {
    final $url = '/posts';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<PostModel>, PostModel>($request,
        responseConverter: PostsApiService.convertPostsResponse);
  }

  @override
  Future<Response<PostModel>> getPost(int id) {
    final $url = '/posts/${id}';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<PostModel, PostModel>($request,
        responseConverter: PostsApiService.convertPostsResponse);
  }

  @override
  Future<Response<List<CommentModel>>> getComments(int id) {
    final $url = '/posts/${id}/comments';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<List<CommentModel>, CommentModel>($request,
        responseConverter: PostsApiService.convertCommentsResponse);
  }
}
