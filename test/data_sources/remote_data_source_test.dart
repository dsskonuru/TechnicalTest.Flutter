import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/api/post_api.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockPostApiService extends Mock implements PostsApiService {}

void main() {
  late MockPostApiService mockPostApiService;
  late RemoteDataSource sut;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockPostApiService = MockPostApiService();
    sut = RemoteDataSourceImpl(mockPostApiService);
  });

  group(
    "fetchPostsList",
    () => test("should return posts list as Async Data", () async {
      // arrange
      final String postsJson = await rootBundle
          .loadString('packages/flutter_tech_task/assets/json/posts.json');
      final List<PostModel> postsList = (jsonDecode(postsJson) as List)
          .map(
            (post) => PostModel.fromJson(post as Map<String, dynamic>),
          )
          .toList();
      final http.Response httpResponse = http.Response(postsJson, 200);
      when(() => mockPostApiService.fetchPosts()).thenAnswer(
        (_) async => Response<List<PostModel>>(httpResponse, postsList),
      );
      // act
      final result = await sut.fetchPosts();
      // assert
      expect(result, AsyncData(postsList));
    }),
  );

  group(
    "fetchPost",
    () => test(
      "should return post as Async Data",
      () async {
        // arrange
        final String postJson = await rootBundle.loadString(
          'packages/flutter_tech_task/assets/json/post_by_id.json',
        );
        final PostModel post =
            PostModel.fromJson(jsonDecode(postJson) as Map<String, dynamic>);
        final http.Response httpResponse = http.Response(postJson, 200);
        when(() => mockPostApiService.fetchPost(1)).thenAnswer(
          (_) async => Response<PostModel>(httpResponse, post),
        );
        // act
        final result = await sut.fetchPost(1);
        // assert
        expect(result, AsyncData(post));
      },
    ),
  );

  group(
    "getComments",
    () => test("should return comments list as Async Data", () async {
      // arrange
      final String commentsJson = await rootBundle.loadString(
        'packages/flutter_tech_task/assets/json/post_comments.json',
      );
      final List<CommentModel> commentsList = (jsonDecode(commentsJson) as List)
          .map(
            (comment) => CommentModel.fromJson(comment as Map<String, dynamic>),
          )
          .toList();
      final http.Response httpResponse = http.Response(commentsJson, 200);
      when(() => mockPostApiService.fetchComments(1)).thenAnswer(
        (_) async => Response<List<CommentModel>>(httpResponse, commentsList),
      );
      // act
      final result = await sut.fetchComments(1);
      // assert
      expect(result, AsyncData(commentsList));
    }),
  );
}
