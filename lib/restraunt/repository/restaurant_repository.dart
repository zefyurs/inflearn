import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/dio/dio.dart';
import 'package:inflearn/common/model/cursor_pagination_model.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:inflearn/restraunt/model/restraurant_detail_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'restaurant_repository.g.dart';

final RestaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
});

// retrofit을 사용하기 위한 annotation
@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;
  @Headers({
    'accessToken': 'true',
  })
  @GET('/')
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}') // 요청타입
  @Headers({
    'accessToken': 'true',
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id, // @Path() 를 붙여서 id를 path parameter로 사용한다.
  });
}


// Future<Map<String, dynamic>> getRestaurantDetail() async {
//   final dio = Dio();

//   final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
//   final resp =
//       await dio.get('http://$ip/restaurant/$id', options: Options(headers: {'authorization': 'Bearer $accessToken'}));

//   return resp.data;
// }
