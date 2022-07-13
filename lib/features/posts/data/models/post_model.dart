import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

// PostModel model is immutable
@freezed
class PostModel with _$PostModel {
  @JsonSerializable(explicitToJson: true)
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, Object?> json) => _$PostModelFromJson(json);
}
