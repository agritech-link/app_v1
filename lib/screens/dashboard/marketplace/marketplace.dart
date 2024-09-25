import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:AgriTech_Link/providers/cart/cart_provider.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/navigation_tabs.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
// import '../providers/cart_provider.dart';
// import '../widgets/custom_bottom_navbar.dart';
// import '../widgets/navigation_tabs.dart';
// import '../widgets/market_search_bar.dart';

class MarketplacePage extends ConsumerStatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends ConsumerState<MarketplacePage> {
  int _currentIndex = 2;
  int _currentMarketNavIndex = 1;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user != null) {
        final response = await supabase
            .from('produce_listings')
            .select()
            .neq('user_id', user.id)
            .order('created_at', ascending: false);

        setState(() {
          _products = List<Map<String, dynamic>>.from(response);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/myStore');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/market');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Marketplace',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          MarketSearchBar(),
          _buildCategories(),
          Expanded(child: _isLoading ? _buildLoadingIndicator() : _buildProductGrid()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: NavigationTabs(
        selectedIndex: _currentMarketNavIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['ALL', 'FRUITS', 'VEGETABLES', 'PESTICIDES', 'SEEDS'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                categories[index],
                style: TextStyle(
                  color: index == 0 ? Colors.black : Colors.grey,
                  fontWeight: index == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_products[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Card(
      elevation: 0.7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: product['image_url'] ?? '',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['produce_name'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('₦ ${product['price']?.toString() ?? ''} / ${product['unit'] ?? 'unit'}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quantity: ${product['quantity']?.toString() ?? '0'}'),
                    _buildAddToCartButton(product),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(Map<String, dynamic> product) {
    return Consumer(
      builder: (context, ref, child) {
        final cartNotifier = ref.watch(cartProvider.notifier);
        return GestureDetector(
          onTap: () => _showAddToCartDialog(product, cartNotifier),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 16),
          ),
        );
      },
    );
  }

  void _showAddToCartDialog(Map<String, dynamic> product, CartNotifier cartNotifier) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${product['produce_name']} to cart'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Price: ₦${product['price']} / ${product['unit']}'),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add to Cart'),
              onPressed: () {
                cartNotifier.addToCart(product['id'], quantity);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${product['produce_name']} added to cart')),
                );
              },
            ),
          ],
        );
      },
    );
  }
}