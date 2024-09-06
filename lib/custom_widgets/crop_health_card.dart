import 'package:flutter/material.dart';

enum HealthStatus { good, warning, danger }

class CropHealthCard extends StatelessWidget {
  final String cropName;
  final String scanDate;
  final String health;
  final HealthStatus healthStatus;

  const CropHealthCard({
    Key? key,
    required this.cropName,
    required this.scanDate,
    required this.health,
    required this.healthStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getCropIcon(),
              SizedBox(width: 8),
              Text(cropName, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 12),
          Text('Scan date', style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(scanDate, style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.health_and_safety, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('Result',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          SizedBox(height: 4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getHealthStatusColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              health,
              style: TextStyle(
                  color: _getHealthStatusColor(), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCropIcon() {
    IconData iconData;
    switch (cropName.toLowerCase()) {
      case 'tomato':
        iconData = Icons.local_florist;
        break;
      case 'wheat':
        iconData = Icons.grass;
        break;
      default:
        iconData = Icons.spa;
    }
    return Icon(iconData, color: Colors.green);
  }

  Color _getHealthStatusColor() {
    switch (healthStatus) {
      case HealthStatus.good:
        return Colors.green;
      case HealthStatus.warning:
        return Colors.orange;
      case HealthStatus.danger:
        return Colors.red;
    }
  }
}
