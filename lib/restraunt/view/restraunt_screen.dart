import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/model/cursor_pagination_model.dart';
import 'package:inflearn/restraunt/component/restaurant_card.dart';
import 'package:inflearn/restraunt/provider/restaurant_provider.dart';
import 'package:inflearn/restraunt/view/restaurant_detail_screen.dart';

class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key});

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면
    // 새로운 데이터를 추가 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) {
      ref.read(restaurantProvider.notifier).paginate(fetchMore: true);
    }
  }

  // Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(restaurantProvider);

    // 처음 로딩
    if (data is CursorPaginationLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // cursorpagination
    // cursorPaginationFechingMore
    // cursorPaginationRefetching

    final cp = data as CursorPagination;

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
            // itemCount: data.length,
            controller: controller,
            itemCount: cp.data.length + 1,
            itemBuilder: (_, index) {
              if (index == cp.data.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Center(
                      child: data is CursorPaginationFetchingMore
                          ? const CircularProgressIndicator()
                          : const Text('마지막 데이터입니다.')),
                );
              }
              // Pagination을 사용하기 위해 필요없어진 코드
              // final item = snapshot.data![index];
              // class를 생성해서 맵핑
              // final pItem = RestaurantModel.fromJson(
              //   item,
              // );

              // final pItem = snapshot.data!.data[index];
              final pItem = cp.data[index];

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
