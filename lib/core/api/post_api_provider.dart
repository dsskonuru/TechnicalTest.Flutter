import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tech_task/core/api/post_api.dart';

final postsApiProvider =
    Provider<PostsApiService>((ref) => PostsApiService.create());
