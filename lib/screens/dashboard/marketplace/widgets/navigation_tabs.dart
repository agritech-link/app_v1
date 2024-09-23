import 'package:AgriTech_Link/screens/dashboard/marketplace/widgets/add_produce_listing_form.dart';
import 'package:flutter/material.dart';

class NavigationTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  NavigationTabs({required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
    child: Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(0),
            child: TabButton(text: 'My Store', isSelected: selectedIndex == 0),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(1),
            child: TabButton(text: 'Market', isSelected: selectedIndex == 1),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(2),
            child: TabButton(text: 'Orders', isSelected: selectedIndex == 2),
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduceListingForm()));
          },
          child: Text('ADD NEW'),
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFDDF71D),
              foregroundColor: Color(0xFF0B2115),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)
              )
          ),
        ),
      ],
    ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String text;
  final bool isSelected;

  TabButton({required this.text, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}


