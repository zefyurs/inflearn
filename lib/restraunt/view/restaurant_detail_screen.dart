import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/dio/dio.dart';
import 'package:inflearn/common/layout/default_layout.dart';
import 'package:inflearn/product/component/product_component.dart';
import 'package:inflearn/restraunt/component/restaurant_card.dart';
import 'package:inflearn/restraunt/model/restraurant_detail_model.dart';
import 'package:inflearn/restraunt/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  // river pod로 한줄짜리 코드가 됫기 때문에 그냥 코드를 지워버리고 본문에서 콜
  // Future<RestaurantDetailModel> getRestaurantDetail(WidgetRef ref) async {
  // * repository에서 dio를 선언해줬기 떄문에 삭제
  // final dio = ref.watch(dioProvider);
  // * river pod으로 dio.dart에서 dio를 provider로 연결해줬기 떄문에 삭제
  // final dio = Dio();

  // dio.interceptors.add(
  //   CustomInterceptor(storage: storage),
  // );

  // final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
  // final resp = await dio.get(
  //   'http://$ip/restaurant/$id',
  //   options: Options(
  //     headers: {'authorization': 'Bearer $accessToken'},
  //   ),
  // );
  // return resp.data;

  // retrofit 사용
  // final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');
  // return repository.getRestaurantDetail(id: id);
  // return ref.watch(RestaurantRepositoryProvider).getRestaurantDetail(id: id);
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: ref.watch(RestaurantRepositoryProvider).getRestaurantDetail(id: id),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            // final item = RestaurantDetailModel.fromJson(
            //   snapshot.data!.toJson(),
            // );
            // Retrofit 을 함으로써 mapping을 한 data가 return 되기 때문에 위의 코드는 필요없다.

            return CustomScrollView(
              slivers: [
                renderTop(model: snapshot.data!),
                renderLabel(),
                renderProduct(products: snapshot.data!.products),
              ],
              // Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: ProductCard(),
              //   )
              // ],
            );
          }),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
  }) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
        detail: "불타는 떡볶이",
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverToBoxAdapter(
          child: Text(
            '메뉴',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ));
  }

  SliverPadding renderProduct({
    required List<RestaurauntProductModel> products,
  }) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        final model = products[index];

        return Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ProductCard.fromModel(
            model: model,
          ),
        );
      }, childCount: products.length)),
    );
  }
}
