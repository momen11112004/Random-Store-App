import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesController extends StateNotifier<Set<String>> {
  FavoritesController() : super({});

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider = StateNotifierProvider<FavoritesController, Set<String>>((ref) {
  return FavoritesController();
});