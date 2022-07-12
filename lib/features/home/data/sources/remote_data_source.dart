
// import 'package:chopper/chopper.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_tech_task/core/api/post_api.dart';

// import 'package:flutter_tech_task/features/home/data/models/comment_model.dart';
// import 'package:flutter_tech_task/features/home/data/models/post_model.dart';

// // TODO: refresh on connectivity change

// final postsApiProvider =
//     Provider<PostsApiService>((ref) => PostsApiService.create());

// final remotePostsListProvider =
//     FutureProvider<Either<Exception, List<PostModel>>>((ref) async {
//   final postsApiService = ref.watch(postsApiProvider);
//   try {
//     final Response<List<PostModel>> _response =
//         await postsApiService.getPosts();
//     if (_response.isSuccessful) {
//       final List<PostModel>? _posts = _response.body;
//       if (_posts != null) {
//         return Right(_posts);
//       } else {
//         return Left(Exception('Posts are null'));
//       }
//     } else {
//       return Left(Exception(_response.error.toString()));
//     }
//   } on Exception {
//     return Left(Exception('Unable to fetch posts'));
//   }
// });

// final remotePostProvider =
//     FutureProvider.family<Either<Exception, PostModel>, int>((ref, id) async {
//   final postsApiService = ref.watch(postsApiProvider);
//   try {
//     final Response<PostModel> _response = await postsApiService.getPost(id);
//     if (_response.isSuccessful) {
//       final PostModel? _post = _response.body;
//       if (_post != null) {
//         return Right(_post);
//       } else {
//         return Left(Exception('PostModel is null'));
//       }
//     } else {
//       return Left(Exception(_response.error.toString()));
//     }
//   } on Exception {
//     return Left(Exception('Unable to fetch post'));
//   }
// });

// final remoteCommentsProvider =
//     FutureProvider.family<Either<Exception, List<CommentModel>>, int>(
//         (ref, id) async {
//   final postsApiService = ref.watch(postsApiProvider);
//   try {
//     final Response<List<CommentModel>> _response =
//         await postsApiService.getComments(id);
//     if (_response.isSuccessful) {
//       final List<CommentModel>? _comments = _response.body;
//       if (_comments != null) {
//         return Right(_comments);
//       } else {
//         return Left(Exception('Comments are null'));
//       }
//     } else {
//       return Left(Exception(_response.error.toString()));
//     }
//   } on Exception {
//     return Left(Exception('Unable to fetch comments'));
//   }
// });




// // class PostsRepository implements PostsDataSource {
// //   final PostsApiService _postsApiService;
// //   PostsRepository(this._postsApiService);
// //   @override
// //   Future<Either<Exception, List<PostModel>>> getPosts() async {
// //     final response = await _postsApiService.getPosts();
// //     return response.body;
// //   }

// //   @override
// //   Future<Either<Exception, PostModel>> getPost(int id) async {
// //     final response = await _postsApiService.getPost(id);
// //     return response.body;
// //   }

// //   @override
// //   Future<Either<Exception, List<PostModel>>> getComments(int id) async {
// //     final response = await _postsApiService.getComments(id);
// //     return response.body;
// //   }
// // }






// // abstract class PostsDataSource {
// //   Future<Either<ServerFailure, List<PostModel>>> getPostsList(String category);
// //   Future<Either<ServerFailure, PostModel>> getPost(int postId);
// // }

// // final postsRepositoryProvider =
// //     Provider<PostsRepository>((ref) => PostsRepository());

// // class PostsRepository implements PostsDataSource {
// //   final _postsRef =
// //       container.read(firestoreProvider).collection('posts').withConverter<PostModel>(
// //             fromFirestore: (snapshot, _) => PostModel.fromJson(snapshot.data()!),
// //             toFirestore: (movie, _) => movie.toJson(),
// //           );

// //   @override
// //   Future<Either<ServerFailure, List<PostModel>>> getPostsList(String category) async {
// //     try {
// //       final List<PostModel> _posts = [];
// //       await _postsRef.where('category', isEqualTo: category).get().then((QuerySnapshot<PostModel> postQuerySnapshot) {
// //         for (final postQueryDocumentSnapshot in postQuerySnapshot.docs) {
// //           _posts.add(postQueryDocumentSnapshot.data());
// //         }
// //       });
// //       return Right(_posts);
// //     } on Exception {
// //       return Left(ServerFailure());
// //     }
// //   }

// //   @override
// //   Future<Either<ServerFailure, PostModel>> getPost(int postId) async {
// //     try {
// //       late PostModel _post;
// //       await _postsRef.doc(postId.toString()).get().then(
// //           (DocumentSnapshot<PostModel> postDocumentSnapshot) =>
// //               _post = postDocumentSnapshot.data()!,);
// //       return Right(_post);
// //     } on Exception {
// //       return Left(ServerFailure());
// //     }
// //   }
// // }
