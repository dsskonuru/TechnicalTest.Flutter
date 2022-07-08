import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

// Post model is immutable
@freezed
class Post with _$Post {
  const factory Post({
    required final int id,
    required final String title,
    required final String body,
    required final int userId,
  }) = _Post;
}  
