import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inflearn/common/const/data.dart';
import 'package:inflearn/common/layout/default_layout.dart';
import 'package:inflearn/product/component/product_component.dart';
import 'package:inflearn/restraunt/component/restaurant_card.dart';
import 'package:inflearn/restraunt/model/restraurant_detail_model.dart';
import 'package:inflearn/restraunt/repository/restaurant_repository.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: getRestaurantDetail(),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

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
