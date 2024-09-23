import 'package:AgriTech_Link/custom_widgets/account_menu.dart';
import 'package:AgriTech_Link/custom_widgets/plant_analysis/analysis_results.dart';
import 'package:AgriTech_Link/custom_widgets/plant_analysis/plant_analysis_widgets.dart';
import 'package:AgriTech_Link/screens/authentication/sign_in.dart';
import 'package:AgriTech_Link/screens/dashboard/accounts/accounts_overview.dart';
import 'package:AgriTech_Link/screens/dashboard/crops_screen.dart';
import 'package:AgriTech_Link/screens/dashboard/home_screen.dart';
import 'package:AgriTech_Link/screens/dashboard/marketplace/my_store.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => SignIn()));
              },
              child: Text(
                'Sign Out',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    Widget page;
    switch (index) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = ResultsPage();
        break;
      case 2:
        page = MyStore();
        break;
      case 3:
        page = AccountsOverview();
        break;
      default:
        page = HomeScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AccountMenu(
          onLogout: () {
            _showLogoutDialog(context);
          },
        );
      },
    );
  }

  void _openCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UnifiedCameraPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.home, 'Home'),
                _buildNavItem(context, 1, FontAwesomeIcons.seedling, 'Crops'),
                SizedBox(width: 60),
                _buildNavItem(context, 2, Icons.shopping_cart, 'Market'),
                _buildNavItem(context, 3, Icons.person, 'Account'),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 5,
            child: GestureDetector(
              onTap: () => _openCamera(context),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFDDF71D),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Color(0xFF0B2115),
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          _showAccountMenu(context);
        } else {
          onTap(index);
          _navigateToPage(context, index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.green : Colors.grey,
          ),
          SizedBox(height: 4), // Add some space between icon and text
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

