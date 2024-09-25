import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String produceListingId;
  final int quantity;

  CartItem({
    required this.id,
    required this.produceListingId,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        id: json['id'],
        produceListingId: json['produce_listing_id'],
        quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produce_listing_id': produceListingId,
      'quantity': quantity
    };
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['user_id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((item) => item.toJson()).toList()
    };
  }
}
