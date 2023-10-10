import 'package:dio/dio.dart';
import 'package:inflearn/restraunt/model/restraurant_detail_model.dart';
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

// retrofit을 사용하기 위한 annotation
@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) = _RestaurantRepository;

  // http://$ip/restaurant
  // @GET('/')
  // paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
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
