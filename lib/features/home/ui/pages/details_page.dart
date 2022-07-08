


import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

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
