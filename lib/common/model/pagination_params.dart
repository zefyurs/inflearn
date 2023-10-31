import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

// * JsonSerializable 을 붙여서 fromJson, toJson을 자동으로 생성
@JsonSerializable()
class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  // after를 유지한체 count를 바꾸거나 하기위해
  PaginationParams copyWith({
    String? after,
    int? count,
  }) {
    return PaginationParams(after: after ?? this.after, count: count ?? this.count);
  }

  factory PaginationParams.fromJson(Map<String, dynamic> json) => _$PaginationParamsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}
