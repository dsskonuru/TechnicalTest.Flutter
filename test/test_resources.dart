import 'package:flutter_tech_task/features/posts/data/models/comment_model.dart';
import 'package:flutter_tech_task/features/posts/data/models/post_model.dart';

const List<PostModel> postsList = [
  PostModel(id: 1, title: 'title 1', body: 'body 1', userId: 101),
  PostModel(id: 2, title: 'title 2', body: 'body 2', userId: 102),
  PostModel(id: 3, title: 'title 3', body: 'body 3', userId: 103),
  PostModel(id: 4, title: 'title 4', body: 'body 4', userId: 104),
];

const List<CommentModel> comments = [
  CommentModel(
    id: 1,
    postId: 1,
    name: 'name 1',
    email: 'email 1',
    body: 'body 1',
  ),
  CommentModel(
    id: 2,
    postId: 1,
    name: 'name 2',
    email: 'email 2',
    body: 'body 2',
  ),
  CommentModel(
    id: 3,
    postId: 1,
    name: 'name 3',
    email: 'email 3',
    body: 'body 3',
  ),
  CommentModel(
    id: 4,
    postId: 1,
    name: 'name 4',
    email: 'email 4',
    body: 'body 4',
  ),
];
