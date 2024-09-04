import 'package:flutter/material.dart';

class PasswordCreationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            child: Text('Get help?', style: TextStyle(color: Colors.black)),
            onPressed: () {
              // Implement help functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create your password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Choose a password",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "At least 8 characters long, containing a letter and a number",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('DONE'),
                  onPressed: () {
                    // Implement account creation and navigation to the main app
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .primaryColor, // Updated from 'primary' to 'backgroundColor'
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
