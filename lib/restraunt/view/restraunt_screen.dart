import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/dio/dio.dart';
import 'package:inflearn/common/model/cursor_pagination_model.dart';
import 'package:inflearn/restraunt/component/restaurant_card.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:inflearn/restraunt/provider/restaurant_provider.dart';
import 'package:inflearn/restraunt/repository/restaurant_repository.dart';
import 'package:inflearn/restraunt/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({super.key});

  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  //   final dio = ref.watch(dioProvider);

  //   final resp = await RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant').paginate();

  // repository 를 통해 생략
  // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  // final resp = await dio.get(
  //   'http://$ip/restaurant',
  //   options: Options(headers: {'authorization': 'Bearer $accessToken'}),
  // );

  // return resp.data['data'];
  //   return resp.data;
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.length == 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        // child: FutureBuilder<CursorPagination<RestaurantModel>>(
        //   // future: paginateRestaurant(ref),
        //   future: ref.watch(RestaurantRepositoryProvider).paginate(),
        //   builder: (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
        //     if (!snapshot.hasData) {
        //       return Container();
        //     }

        child: ListView.separated(
            itemCount: data.length,
            itemBuilder: (_, index) {
              // Pagination을 사용하기 위해 필요없어진 코드
              // final item = snapshot.data![index];
              // class를 생성해서 맵핑
              // final pItem = RestaurantModel.fromJson(
              //   item,
              // );

              // final pItem = snapshot.data!.data[index];
              final pItem = data[index];

              return GestureDetector(
                onTap: () {
                  // print(pItem.id);

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                            id: pItem.id,
                          )));
                },
                child: RestaurantCard.fromModel(
                  model: pItem,
                  isDetail: false,
                ),
              );
            },
            separatorBuilder: (_, index) {
              return const SizedBox(height: 16);
            }));
  }
}
