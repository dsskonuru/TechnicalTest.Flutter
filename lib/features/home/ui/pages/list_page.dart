import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/router/router.gr.dart';
import 'package:flutter_tech_task/features/home/data/models/post_model.dart';
import 'package:flutter_tech_task/features/home/data/sources/posts_repo.dart';

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _posts = ref.watch(postsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: _posts.when(
        data: (postsOrFailure) => _buildPostsList(context, postsOrFailure),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      ),
    );
  }
}

Widget _buildPostsList(
  BuildContext context,
  Either<Exception, List<PostModel>> postsOrFailure,
) =>
    postsOrFailure.fold(
      (err) => Center(child: Text('Error: $err')),
      (_posts) => ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              _posts[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_posts[index].body),
            onTap: () => AutoRouter.of(context)
                .push(DetailsRoute(postId: _posts[index].id)),
          ),
        ),
      ),
    );



// import 'package:http/http.dart' as http;
// import 'dart:convert';


// class ListPage extends StatefulWidget {
//   const ListPage({Key? key}) : super(key: key);

//   @override
//   State<ListPage> createState() => _ListPageState();
// }

// class _ListPageState extends State<ListPage> {
//   List<dynamic> posts = [];

//   @override
//   void initState() {
//     super.initState();
//     http
//         .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/'))
//         .then((response) {

//       setState(() {
//         posts = json.decode(response.body);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: const Text("List of posts"),
//       ),
//       body: ListView(
//         children: posts.map((post) {
//           return InkWell(
//             onTap: () {
//               Navigator.of(context)
//                   .pushNamed('details/', arguments: {'id': post['id']});
//             },
//             child: Container(
//               padding: const EdgeInsets.only(left: 10, right: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     post['title'],
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(post['body']),
//                   Container(height: 10),
//                   const Divider(
//                     thickness: 1,
//                     color: Colors.grey,
//                   )
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
