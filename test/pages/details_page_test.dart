import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/errors/failures.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
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

  group("DetailsPage", () {
    testWidgets(
      "displays selected post",
      (WidgetTester tester) async {
        // arrange
        when(() => mockRemoteDataSource.fetchPosts()).thenAnswer(
          (invocation) => Future.value(const AsyncData(postsList)),
        );
        when(() => mockRemoteDataSource.fetchPost(1))
            .thenAnswer((invocation) => Future.value(AsyncData(postsList[0])));

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

        // * DetailsPage is build and selected post is displayed
        expect(find.byType(DetailsPage), findsOneWidget);
        expect(find.text("title 1"), findsOneWidget);
        expect(find.text("body 1"), findsOneWidget);
      },
    );

    testWidgets(
      "displays selected post from Bookmark Page",
      (WidgetTester tester) async {
        // arrange

        when(() => mockRemoteDataSource.fetchPosts()).thenAnswer(
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

        // * Select the first saved post
        await tester.tap(find.text("title 1"));
        await tester.pump();

        // * DetailsPage is build and selected post is displayed
        expect(find.text("title 1"), findsOneWidget);
        expect(find.text("body 1"), findsOneWidget);
      },
    );
  });
}
