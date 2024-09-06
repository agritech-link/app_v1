import 'package:AgriTech_Link/screens/authentication/sign_in.dart';
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
              borderRadius: BorderRadius.circular(3.0),),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 3) {
            _showLogoutDialog(context);
          } else {
            onTap(index);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.seedling,
              size: 20,
              color: Colors.green,
            ),
            label: 'Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.black,
        type: BottomNavigationBarType.shifting,
      ),
    );
  }
}
