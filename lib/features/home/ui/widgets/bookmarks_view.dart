import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/local_source.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _localDataSource = LocalSource();

    return FutureBuilder<List<PostModel?>>(
      future: _localDataSource.fetchSavedPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // debugPrint(snapshot.data.toString());
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => Card(
              elevation: 4,
              child: ListTile(
                title: Text(
                  snapshot.data![index]!.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(snapshot.data![index]!.body),
                onTap: () => AutoRouter.of(context)
                    .push(DetailsRoute(postId: snapshot.data![index]!.id)),
              ),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == null) {
          return const Center(
            child: Text('No bookmarks yet'),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
