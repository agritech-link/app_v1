import 'package:AgriTech_Link/screens/dashboard/marketplace/marketplace.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/orders.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/navigation_tabs.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/product_grid.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';

class MyStore extends StatefulWidget {
  const MyStore({super.key});

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<MyStore> {
  int _currentIndex = 2;

  int _currentMarketNavIndex = 0;

  final List<Widget> _pages = [
    MyStore(),
    MarketplacePage(),
    OrdersPage(),
  ];

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
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Marketplace',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {
              // Handle notification button press
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Handle more options button press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          NavigationTabs(
            onTabSelected: _onTabSelected,
            selectedIndex: _currentMarketNavIndex,
          ),
          MarketSearchBar(),
          Expanded(
            child: ProductGrid(),
          )
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
}
