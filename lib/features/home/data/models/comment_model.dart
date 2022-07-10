import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_model.freezed.dart';
part 'comment_model.g.dart';

// CommentModel model is immutable
@freezed
class CommentModel with _$CommentModel {
  const factory CommentModel({
    required final int postId,
    required final int id,
    required final String name,
    required final String email,
    required final String body,
  }) = _CommentModel;

  factory CommentModel.fromJson(Map<String, Object?> json) =>
      _$CommentModelFromJson(json);
}  
