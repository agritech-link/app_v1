import 'package:AgriTech_Link/screens/dashboard/marketplace/orders.dart';
import 'package:flutter/material.dart';
import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  _MarketState createState() => _MarketState();
}

class _MarketState extends State<CropsScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    OrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        title: Text(
          'Crops',
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
      // body: ,

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