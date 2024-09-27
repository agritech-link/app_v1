import 'package:AgriTech_Link/providers/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: cart == null || cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return ListTile(
                  title: Text('Product ID: ${item.produceListingId}'),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cartNotifier.removeFromCart(item.id),
                  ),
                );
              },
            ),
      bottomNavigationBar: cart != null && cart.items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  // Implement checkout logic here
                  Navigator.pushNamed(context, '/checkout');
                },
              ),
            )
          : null,
    );
  }
}
