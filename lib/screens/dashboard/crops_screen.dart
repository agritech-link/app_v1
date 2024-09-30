import 'package:AgriTech_Link/custom_widgets/plant_analysis/analysis_results.dart';
import 'package:flutter/material.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/orders.dart';
import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';

class CropsScreen extends StatefulWidget {
  const CropsScreen({super.key});

  @override
  _CropsScreenState createState() => _CropsScreenState();
}

class _CropsScreenState extends State<CropsScreen> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    OrdersPage(),
  ];

  final List<Map<String, String>> cropData = [
    {"name": "Tomato", "status": "Early blight", "date": "20 June, 2024"},
    {"name": "Wheat", "status": "Healthy", "date": "20 June, 2024"},
    {"name": "Corn", "status": "Healthy", "date": "19 June, 2024"},
    {"name": "Potato", "status": "Late blight", "date": "18 June, 2024"},
    {"name": "Soybean", "status": "Healthy", "date": "20 June, 2024"},
    {"name": "Rice", "status": "Blast", "date": "17 June, 2024"},
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Crop Health',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   'View all',
                  //   style: TextStyle(color: Colors.blue),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ResultsPage()),
                      );
                    },
                  )
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 200, // Adjust this value as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cropData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: _buildCropCard(
                        cropData[index]["name"]!,
                        cropData[index]["status"]!,
                        cropData[index]["date"]!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildCropCard(String cropName, String status, String scanDate) {
    return Container(
      width: 160, // Adjust this value as needed
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getCropIcon(cropName), size: 24),
              SizedBox(width: 8),
              Expanded(
                child: Text(cropName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Expanded(
                child: Text('Scan date',
                    style: TextStyle(color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(scanDate, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text('Result', style: TextStyle(color: Colors.grey)),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Healthy' ? Colors.green[100] : Colors.yellow[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Healthy' ? Colors.green[800] : Colors.yellow[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCropIcon(String cropName) {
    switch (cropName.toLowerCase()) {
      case 'tomato':
        return Icons.local_florist;
      case 'wheat':
        return Icons.grass;
      case 'corn':
        return Icons.eco;
      case 'potato':
        return Icons.spa;
      case 'soybean':
        return Icons.grain;
      case 'rice':
        return Icons.grass;
      default:
        return Icons.agriculture;
    }
  }
}