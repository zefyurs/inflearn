import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/common/model/cursor_pagination_model.dart';
import 'package:inflearn/common/model/pagination_params.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:inflearn/restraunt/repository/restaurant_repository.dart';

final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((element) => element.id == id);
});

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(RestaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({required this.repository}) : super(CursorPaginationLoading()) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침( 현재 상태를 덮어씌움)
    bool fetchMore = false,
    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading()
    bool forceRefresh = false,
  }) async {
    try {
      // final resp = await repository.paginate();

      // state = resp;

      // 5가지 가능성
      // state의 상태
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading - 데이터가 로딩중인 상태 (현재 캐시 없음)
      // 3) CursorPaginationError - 데이터 로딩중 에러가 발생한 상태
      // 4) CursorPainationRefetching - 첫번째 페이지부터 다시 데이터를 가져올때
      // 5) CursorPaginationFetchingMore - 추가로 데이터를 가져올때

      // 바로 반환하는 상황
      // 1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
      // 2) 로딩중 ; FetchMore: true
      // fetchMore가 아닐떄 - 새로고침의 의도가 있을 수 있다
      if (state is CursorPagination && !forceRefresh) {
        final pState = state as CursorPagination; // state를 CursorPagination으로 casting 명시

        if (!pState.meta.hasMore) {
          return;
        }
      }

      // 2번 반환 상황
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination;

        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // 데이터를 처음부터 가져오는 상황
      else {
        // 데이터가 있는 상황이라면 기존데이터를 보존한체로 Fetch를 요청
        if (state is CursorPagination && !forceRefresh) {
          final pState = state as CursorPagination;
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황

        else {
          state = CursorPaginationLoading();
        }
      }
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못하였습니다.');
    }
  }

  void getDetail({
    required String id,
  }) async {
    // 데이터가 없는 상황이라면 cursorpagination이 아니라면
    // 데이터를 가져오는 시도를 한다
    if (state is! CursorPagination) {
      await paginate();
    }

    // state가 CursorPagination이 아니라면 그냥 Null 반환
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(
      id: id,
    );

    state = pState.copyWith(
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),
    );
  }
}
