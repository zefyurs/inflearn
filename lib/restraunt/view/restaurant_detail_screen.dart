import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/layout/default_layout.dart';
import 'package:inflearn/product/component/product_component.dart';
import 'package:inflearn/restraunt/component/restaurant_card.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:inflearn/restraunt/model/restraurant_detail_model.dart';
import 'package:inflearn/restraunt/provider/restaurant_provider.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }

  // river pod로 한줄짜리 코드가 됫기 때문에 그냥 코드를 지워버리고 본문에서 콜
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    // null 일떄는 로딩
    if (state == null) {
      return const DefaultLayout(child: Center(child: CircularProgressIndicator()));
    }

    return DefaultLayout(
        title: '불타는 떡볶이',
        child: CustomScrollView(
          slivers: [
            renderTop(model: state),
            // renderProduct(products: snapshot.data!.products),
            if (state is! RestaurantDetailModel) renderLoading(),
            if (state is RestaurantDetailModel) renderLabel(),
            if (state is RestaurantDetailModel) renderProduct(products: state.products),

            // const SliverToBoxAdapter(
            //   child: Center(
            //     child: CircularProgressIndicator(),
            //   ),
            // )
            // Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: ProductCard(),
            //   )
            // ],
          ],
        ));
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      sliver: SliverList(
          delegate: SliverChildListDelegate(List.generate(
              3,
              (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SkeletonParagraph(
                        style: const SkeletonParagraphStyle(
                      lines: 10,
                      padding: EdgeInsets.zero,
                    )),
                  )))),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantModel model,
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
