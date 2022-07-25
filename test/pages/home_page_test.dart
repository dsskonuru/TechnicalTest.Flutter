import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/home_page.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/bookmarks_view.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/feed_view.dart.dart';
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

  group("HomePage", () {
    testWidgets("FeedView is built and the posts are displayed",
        (WidgetTester tester) async {
      // arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            remoteDataSourceProvider.overrideWithValue(mockRemoteDataSource),
          ],
          child: const MyApp(),
        ),
      );
      when(() => mockRemoteDataSource.fetchPosts())
          .thenAnswer((invocation) => Future.value(const AsyncData(postsList)));

      // act
      await tester.pump();

      // assert
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(FeedView), findsOneWidget);

      await tester.pumpAndSettle();

      for (int i = 0; i < postsList.length; i++) {
        expect(find.text(postsList[i].title), findsOneWidget);
        expect(find.text(postsList[i].body), findsOneWidget);
      }
    });

    testWidgets(
      "Able to save posts and view it in the BookmarksView",
      (WidgetTester tester) async {
        // arrange
        when(() => mockRemoteDataSource.fetchPosts()).thenAnswer(
          (invocation) => Future.value(const AsyncData(postsList)),
        );
        SharedPreferences.setMockInitialValues({"saved_post_ids": []});
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

        // * Save the first post
        expect(find.byIcon(Icons.bookmark_border_rounded), findsNWidgets(4));
        await tester.tap(find.byIcon(Icons.bookmark_border_rounded).first);
        await tester.pumpAndSettle();

        // * Make sure the first post is saved
        final prefs = await SharedPreferences.getInstance();
        final result = prefs.getStringList("saved_post_ids");
        expect(result, [1.toString()]);

        // * Switch to Bookmark View
        await tester.tap(find.byIcon(Icons.collections_bookmark_rounded));
        await tester.pumpAndSettle();

        // * Make sure the bookmarked post is displayed
        expect(find.byType(BookmarksView), findsOneWidget);
        expect(find.text('title 1'), findsOneWidget);
      },
    );
  });
}
