import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';

class AppState {
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;
  final List<int> cartItems;

  AppState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
    this.cartItems = const [],
  });

  AppState copyWith({
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
    List<int>? cartItems,
  }) {
    return AppState(
      currentUser: currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      cartItems: cartItems ?? this.cartItems,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState());

  void setCurrentUser(User user) {
    state = state.copyWith(currentUser: user);
  }

  void clearCurrentUser() {
    state = state.copyWith(currentUser: null);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(errorMessage: error);
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void addToCart(int productId) {
    final updatedCart = [...state.cartItems, productId];
    state = state.copyWith(cartItems: updatedCart);
  }

  void removeFromCart(int productId) {
    final updatedCart = state.cartItems.where((id) => id != productId).toList();
    state = state.copyWith(cartItems: updatedCart);
  }

  void clearCart() {
    state = state.copyWith(cartItems: []);
  }

  int get cartCount => state.cartItems.length;
}

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(appStateProvider).currentUser;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(appStateProvider).isLoading;
});

final errorMessageProvider = Provider<String?>((ref) {
  return ref.watch(appStateProvider).errorMessage;
});

final cartItemsProvider = Provider<List<int>>((ref) {
  return ref.watch(appStateProvider).cartItems;
});

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(appStateProvider).cartItems.length;
});
