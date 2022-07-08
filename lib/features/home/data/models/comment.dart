import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';

// Comment model is immutable
@freezed
class Comment with _$Comment {
  const factory Comment({
    required final int id,
    required final String title,
    required final String body,
    required final int userId,
  }) = _Comment;
}  
