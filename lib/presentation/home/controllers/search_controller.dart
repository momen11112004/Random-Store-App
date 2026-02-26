import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchState {
  final String query;
  final String selectedCategory;

  SearchState({this.query = '', this.selectedCategory = 'الكل'});

  SearchState copyWith({String? query, String? selectedCategory}) {
    return SearchState(
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class SearchController extends StateNotifier<SearchState> {
  SearchController() : super(SearchState());

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final searchProvider = StateNotifierProvider<SearchController, SearchState>((ref) {
  return SearchController();
});