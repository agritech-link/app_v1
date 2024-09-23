import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/navigation_tabs.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> orders = [
    Order(
        id: '001',
        customerName: 'John Doe',
        date: DateTime.now(),
        total: 15000,
        status: OrderStatus.Pending),
    Order(
        id: '002',
        customerName: 'Jane Smith',
        date: DateTime.now().subtract(Duration(days: 1)),
        total: 22500,
        status: OrderStatus.Shipped),
    // Add more sample orders here
  ];

  int _currentIndex = 2;

  List<Order> filteredOrders = [];
  OrderStatus? selectedStatus;

  int _currentMarketNavIndex = 2;

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
  void initState() {
    super.initState();
    filteredOrders = orders;
  }

  void filterOrders(String query) {
    setState(() {
      filteredOrders = orders
          .where((order) =>
              order.id.toLowerCase().contains(query.toLowerCase()) ||
              order.customerName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void filterByStatus(OrderStatus? status) {
    setState(() {
      selectedStatus = status;
      if (status == null) {
        filteredOrders = orders;
      } else {
        filteredOrders =
            orders.where((order) => order.status == status).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Filter by Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text('All'),
                        onTap: () {
                          filterByStatus(null);
                          Navigator.pop(context);
                        },
                      ),
                      ...OrderStatus.values
                          .map((status) => ListTile(
                                title: Text(status.toString().split('.').last),
                                onTap: () {
                                  filterByStatus(status);
                                  Navigator.pop(context);
                                },
                              ))
                          .toList(),
                    ],
                  ),
                ),
              );
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Color(0xFF0B2115),
              onChanged: filterOrders,
              decoration: InputDecoration(
                labelText: 'Search',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Color(0xFF0B2115),
                  ),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder( borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFF0B2115)
                  )
                )
              ),

            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Implement refresh logic here
                await Future.delayed(Duration(seconds: 1));
                setState(() {
                  // Update orders list
                });
              },
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Text(
                        '${order.customerName} - ${order.date.toString().split(' ')[0]}'),
                    trailing: Text('₦${order.total / 100}'),
                    leading: CircleAvatar(
                      backgroundColor: order.status.color,
                      child: Text(order.status.toString().split('.').last[0]),
                    ),
                    onTap: () {
                      // Navigate to order details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(order: order),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
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

class Order {
  final String id;
  final String customerName;
  final DateTime date;
  final int total;
  final OrderStatus status;

  Order(
      {required this.id,
      required this.customerName,
      required this.date,
      required this.total,
      required this.status});
}

enum OrderStatus { Pending, Processing, Shipped, Delivered }

extension OrderStatusExtension on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.Pending:
        return Colors.orange;
      case OrderStatus.Processing:
        return Colors.blue;
      case OrderStatus.Shipped:
        return Colors.purple;
      case OrderStatus.Delivered:
        return Colors.green;
    }
  }
}

class OrderDetailsPage extends StatelessWidget {
  final Order order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order.customerName}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Date: ${order.date.toString().split(' ')[0]}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Total: ₦${order.total / 100}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Status: ${order.status.toString().split('.').last}',
                style: TextStyle(fontSize: 18)),
            // Add more order details here
          ],
        ),
      ),
    );
  }
}
