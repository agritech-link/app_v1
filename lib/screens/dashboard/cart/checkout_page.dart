import 'package:AgriTech_Link/providers/cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.watch(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: cart == null || cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView(
        children: [
          ...cart.items.map((item) => ListTile(
            title: Text('Product ID: ${item.produceListingId}'),
            subtitle: Text('Quantity: ${item.quantity}'),
          )),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Place Order',
                    style: TextStyle(color: Colors.black),
                  ),
            onPressed: () async {
              // Order placement logic here
              await cartNotifier.clearCart();
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.flat,
                title: Text("Success"),
                description: Text("Your order has been placed successfully!"),
                alignment: Alignment.bottomCenter,
                autoCloseDuration: const Duration(seconds: 4),
                primaryColor: Color(0xff199f19),
                foregroundColor: Color(0xff0b2115),
              );
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}