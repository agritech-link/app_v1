import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/navigation_tabs.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  int _currentIndex = 2;
  int _currentMarketNavIndex = 1;

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
            icon: const Icon(Icons.print, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabs(),
          MarketSearchBar(),
          _buildCategories(),
          Expanded(child: _buildProductGrid()),
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

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: NavigationTabs(
        selectedIndex: _currentMarketNavIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }

  Widget _buildTab(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildAddNewButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFCBFA50),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'ADD NEW',
        style: TextStyle(fontWeight: FontWeight.bold),
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
    final products = [
      {'name': 'Spell Millet', 'price': '950.00', 'image': 'assets/millet.jpg'},
      {
        'name': 'Tangerine Orange',
        'price': '350.00',
        'image': 'assets/orange.jpg'
      },
      {'name': 'Onion', 'price': '950.00', 'image': 'assets/onion.jpg'},
      {
        'name': 'Beefsteak tomato',
        'price': '250.00',
        'image': 'assets/tomato.jpg'
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildProductCard(Map<String, String> product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(
              product['image']!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('₦ ${product['price']!}/1kg'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('In stock'),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

