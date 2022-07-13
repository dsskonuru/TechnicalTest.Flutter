import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/local_data_source.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late LocalDataSource sut;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    sut = LocalDataSource(mockRemoteDataSource);
  });

  group("updateSavedPostIds", () {
    test("should save post ids", () async {
      // arrange
      // SharedPreferences.setMockInitialValues({});
      final List<int> postIds = [1, 2, 3];
      final prefs = await SharedPreferences.getInstance();
      // act
      await sut.updateSavedPostIds(postIds);
      final List<String> result = prefs.getStringList("saved_post_ids")!;
      // assert
      expect(
        postIds.map((e) => e.toString()).toList(),
        result,
      );
    });
  });

  group("fetchSavedPostIds", () {
    test("should fetch saved post ids from prefs", () async {
      // arrange
      final List<int> postIds = [1, 2, 3];
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList(
        "saved_post_ids",
        postIds.map((e) => e.toString()).toList(),
      );
      // act
      final result = await sut.fetchSavedPostIds();
      // assert
      expect(postIds, result);
    });
  });

  group("savePost", () {
    test("should save post", () async {
      // arrange
      final String postJson =
          await rootBundle.loadString('assets/json/post_by_id.json');
      final PostModel post = PostModel.fromJson(
        jsonDecode(postJson) as Map<String, dynamic>,
      );

      final String commentsJson =
          await rootBundle.loadString('assets/json/post_comments.json');
      final List<CommentModel> comments = (jsonDecode(commentsJson) as List)
          .map(
            (comment) => CommentModel.fromJson(comment as Map<String, dynamic>),
          )
          .toList();

      when(() => mockRemoteDataSource.fetchPost(1))
          .thenAnswer((invocation) => Future.value(AsyncData(post)));
      when(() => mockRemoteDataSource.fetchComments(1))
          .thenAnswer((invocation) => Future.value(AsyncData(comments)));

      // act
      await sut.savePost(1);

      // assert
      final prefs = await SharedPreferences.getInstance();

      final String savedPostJson = prefs.getString("post_1")!;
      expect(savedPostJson, jsonEncode(post.toJson()));

      final String savedCommentsJson = prefs.getString("comments_1")!;
      expect(savedCommentsJson,
          jsonEncode(comments.map((e) => e.toJson()).toList()));
    });
  });
}
