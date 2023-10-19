import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inflearn/restraunt/model/restaurant_model.dart';
import 'package:inflearn/restraunt/repository/restaurant_repository.dart';

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>((ref) {
  final repository = ref.watch(RestaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);

  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;
  RestaurantStateNotifier({required this.repository}) : super([]) {
    paginate();
  }

  paginate() async {
    final resp = await repository.paginate();

    state = resp.data;
  }
}