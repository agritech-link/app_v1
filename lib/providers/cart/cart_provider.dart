import 'package:AgriTech_Link/services/cart/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


final cartProvider = StateNotifierProvider<CartNotifier, Cart?>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Cart?> {
  CartNotifier() : super(null) {
    _loadCartFromCache();
  }

  final supabase = Supabase.instance.client;

  Future<void> _loadCartFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson != null) {
      state = Cart.fromJson(jsonDecode(cartJson));
    }
  }

  Future<void> _saveCartToCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (state != null) {
      await prefs.setString('cart', jsonEncode(state!.toJson()));
    } else {
      await prefs.remove('cart');
    }
  }

  Future<void> addToCart(String produceListingId, int quantity) async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    if (state == null) {
      // Create a new cart if it doesn't exist
      final response = await supabase.from('carts').insert({
        'user_id': user.id,
      }).select().single();

      state = Cart(
        id: response['id'],
        userId: user.id,
        items: [],
      );
    }

    // Check if the item already exists in the cart
    final existingItemIndex = state!.items.indexWhere((item) => item.produceListingId == produceListingId);

    if (existingItemIndex != -1) {
      final updatedItems = List<CartItem>.from(state!.items);
      updatedItems[existingItemIndex] = CartItem(
        id: updatedItems[existingItemIndex].id,
        produceListingId: produceListingId,
        quantity: updatedItems[existingItemIndex].quantity + quantity,
      );

      state = Cart(
        id: state!.id,
        userId: state!.userId,
        items: updatedItems,
      );

      await supabase.from('cart_items').update({
        'quantity': updatedItems[existingItemIndex].quantity,
      }).match({'id': updatedItems[existingItemIndex].id});
    } else {
      // Add new item
      final response = await supabase.from('cart_items').insert({
        'cart_id': state!.id,
        'produce_listing_id': produceListingId,
        'quantity': quantity,
      }).select().single();

      state = Cart(
        id: state!.id,
        userId: state!.userId,
        items: [
          ...state!.items,
          CartItem(
            id: response['id'],
            produceListingId: produceListingId,
            quantity: quantity,
          ),
        ],
      );
    }

    _saveCartToCache();
  }

  Future<void> removeFromCart(String cartItemId) async {
    if (state == null) return;

    await supabase.from('cart_items').delete().match({'id': cartItemId});

    state = Cart(
      id: state!.id,
      userId: state!.userId,
      items: state!.items.where((item) => item.id != cartItemId).toList(),
    );

    _saveCartToCache();
  }

  Future<void> clearCart() async {
    if (state == null) return;

    await supabase.from('cart_items').delete().match({'cart_id': state!.id});

    state = Cart(
      id: state!.id,
      userId: state!.userId,
      items: [],
    );

    _saveCartToCache();
  }

  Future<void> fetchCart() async {
    final user = supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final response = await supabase
        .from('carts')
        .select('*, cart_items(*)')
        .eq('user_id', user.id)
        .single();

    if (response != null) {
      state = Cart(
        id: response['id'],
        userId: user.id,
        items: (response['cart_items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList(),
      );
    }

    _saveCartToCache();
  }
}