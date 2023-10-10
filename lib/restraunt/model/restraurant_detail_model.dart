import 'package:inflearn/common/utils/data_utils.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restraurant_detail_model.g.dart';

@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurauntProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required super.priceRange,
    required super.ratings,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) => _$RestaurantDetailModelFromJson(json);
  // factory RestaurantDetailModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurantDetailModel(
  //     id: json['id'],
  //     name: json['name'],
  //     thumbUrl: 'http://$ip${json['thumbUrl']}',
  //     tags: List<String>.from(json['tags']),
  //     priceRange: RestaurantPriceRange.values.firstWhere((e) => e.name == json['priceRange']),
  //     ratings: json['ratings'],
  //     ratingsCount: json['ratingsCount'],
  //     deliveryTime: json['deliveryTime'],
  //     deliveryFee: json['deliveryFee'],
  //     detail: json['detail'],
  //     products:
  //         json['products'].map<RestaurauntProductModel>((x) => RestaurauntProductModel.fromJson(json: x)).toList(),
  //   );
  // }
}

@JsonSerializable()
class RestaurauntProductModel {
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurauntProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurauntProductModel.fromJson(Map<String, dynamic> json) => _$RestaurauntProductModelFromJson(json);
  // factory RestaurauntProductModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return RestaurauntProductModel(
  //     id: json['id'],
  //     name: json['name'],
  //     imgUrl: 'http://$ip${json['imgUrl']}',
  //     detail: json['detail'],
  //     price: json['price'],
  //   );
  // }
}
