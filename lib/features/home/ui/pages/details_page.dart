import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repo.dart';

class DetailsPage extends ConsumerWidget {
  const DetailsPage({@PathParam('postId') required this.postId, Key? key})
      : super(key: key);

  final int postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _post = ref.watch(postProvider(postId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _post.when(
        data: (postsOrFailure) => _buildPost(context, postsOrFailure),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}

Widget _buildPost(
  BuildContext context,
  Either<Exception, PostModel> postOrFailure,
) =>
    postOrFailure.fold(
      (err) => Center(child: Text('Error: $err')),
      (post) => Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            post.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(post.body),
          onTap: () =>
              AutoRouter.of(context).push(CommentsRoute(postId: post.id)),
        ),
      ),
    );

// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class DetailsPage extends StatefulWidget {
//   const DetailsPage({Key? key}) : super(key: key);

//   @override
//   State<DetailsPage> createState() => _DetailsPageState();
// }

// class _DetailsPageState extends State<DetailsPage> {
//   dynamic post;

//   @override
//   Widget build(BuildContext context) {
//     final args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

//     return FutureBuilder<dynamic>(
//         future: http.get(Uri.parse(
//             'https://jsonplaceholder.typicode.com/posts/${args?['id']}',),),
//         builder: (post, response) {
//           if (response.hasData) {
//             final dynamic data = json.decode(response.data!.body);
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('Post details'),
//               ),
//               body: Container(
//                   padding: const EdgeInsets.all(15),
//                   child: Column(children: [
//                     Text(
//                       data['title'],
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     Container(height: 10),
//                     Text(data['body'], style:  const TextStyle(fontSize: 16))
//                   ],),),
//             );
//           } else {
//             return Container();
//           }
//         },);
//   }
// }
