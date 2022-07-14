import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';
import 'package:flutter_tech_task/features/posts/data/sources/remote_data_source.dart';
import 'package:flutter_tech_task/features/posts/ui/pages/home_page.dart';
import 'package:flutter_tech_task/features/posts/ui/widgets/feed_view.dart.dart';
import 'package:flutter_tech_task/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  late MockRemoteDataSource mockRemoteDataSource;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
  });

  const List<PostModel> postsList = [
    PostModel(id: 1, title: 'title 1', body: 'body 1', userId: 101),
    PostModel(id: 2, title: 'title 2', body: 'body 2', userId: 102),
    PostModel(id: 3, title: 'title 3', body: 'body 3', userId: 103),
    PostModel(id: 4, title: 'title 4', body: 'body 4', userId: 104),
  ];

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
      when(() => mockRemoteDataSource.fetchPostsList())
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
  });
}
