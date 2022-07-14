import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/comments_page.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/details_page.dart';
import 'package:flutter_tech_task/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../test_resources.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
  });

  group("CommentsPage", () {
    testWidgets(
      "displays comments from the selected post",
      (WidgetTester tester) async {
        // arrange
        when(() => mockRemoteDataSource.fetchPostsList()).thenAnswer(
          (invocation) => Future.value(const AsyncData(postsList)),
        );
        when(() => mockRemoteDataSource.fetchPost(1))
            .thenAnswer((invocation) => Future.value(AsyncData(postsList[0])));
        when(() => mockRemoteDataSource.fetchComments(1)).thenAnswer(
          (invocation) => Future.value(const AsyncData(comments)),
        );

        // act and assert
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              remoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // * Select first post
        await tester.tap(find.text("title 1"));
        await tester.pumpAndSettle();

        // * DetailsPage is built and selected post is displayed
        expect(find.byType(DetailsPage), findsOneWidget);
        expect(find.text("body 1"), findsOneWidget);

        // * Click on comments button
        await tester.tap(find.text("Comments"));
        await tester.pumpAndSettle();

        // * Comments page is built and comments are displayed
        expect(find.byType(CommentsPage), findsOneWidget);
        for (final comment in comments) {
          expect(find.text(comment.name), findsOneWidget);
          expect(find.text(comment.email), findsOneWidget);
          expect(find.text(comment.body), findsOneWidget);
        }
      },
    );

    testWidgets(
      "displays comments from selected post in Bookmark View",
      (WidgetTester tester) async {
        // arrange

        when(() => mockRemoteDataSource.fetchPostsList()).thenAnswer(
          (invocation) => Future.value(const AsyncData(postsList)),
        );
        SharedPreferences.setMockInitialValues({
          "saved_post_ids": [1.toString()],
          "post_1": jsonEncode(postsList[0].toJson()),
          "comments_1": jsonEncode(comments.map((e) => e.toJson()).toList())
        });
        when(() => mockRemoteDataSource.fetchPost(1)).thenAnswer(
          (invocation) => Future.value(const AsyncError(NoConnectionFailure)),
        );
        when(() => mockRemoteDataSource.fetchComments(1)).thenAnswer(
          (invocation) => Future.value(const AsyncError(NoConnectionFailure)),
        );

        // act and assert
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              remoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
            ],
            child: const MyApp(),
          ),
        );

        await tester.pumpAndSettle();

        // * Switch to Bookmark View
        await tester.tap(find.byIcon(Icons.collections_bookmark_rounded));
        await tester.pumpAndSettle();

        // * Select first post
        await tester.tap(find.text("title 1"));
        await tester.pumpAndSettle();

        // * DetailsPage is built and selected post is displayed
        expect(find.byType(DetailsPage), findsOneWidget);
        expect(find.text("body 1"), findsOneWidget);

        // * Click on comments button
        await tester.tap(find.text("Comments"));
        await tester.pumpAndSettle();

        // * Comments Page is built and selected post is displayed
        expect(find.byType(CommentsPage), findsOneWidget);
        for (final comment in comments) {
          expect(find.text(comment.name), findsOneWidget);
          expect(find.text(comment.email), findsOneWidget);
          expect(find.text(comment.body), findsOneWidget);
        }
      },
    );
  });
}
