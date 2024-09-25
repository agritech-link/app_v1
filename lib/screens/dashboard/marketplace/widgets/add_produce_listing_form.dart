import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

class AddProduceListingForm extends StatefulWidget {
  @override
  _AddProduceListingFormState createState() => _AddProduceListingFormState();
}

class _AddProduceListingFormState extends State<AddProduceListingForm> {
  final _formKey = GlobalKey<FormState>();
  final _produceName = TextEditingController();
  final _quantity = TextEditingController();
  final _price = TextEditingController();
  final _imageUrl = TextEditingController();
  String _selectedUnit = 'Boxes'; // Default unit

  final List<String> _units = ['Boxes', 'Sacks', 'Bushels', 'Bunches', 'Bags'];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final supabase = Supabase.instance.client;
        final userId = supabase.auth.currentUser?.id;

        if (userId == null) {
          throw Exception('User not logged in');
        }

        final newListing = {
          'produce_name': _produceName.text,
          'quantity': int.parse(_quantity.text),
          'price': double.parse(_price.text),
          'image_url': _imageUrl.text,
          'user_id': userId,
          'unit': _selectedUnit,
        };

        print('Attempting to insert: $newListing');

        final response = await supabase.from('produce_listings').insert(newListing);

        print('Supabase response: $response');

        if (response == null) {
          print('Null response received. Treating as successful insertion.');
          toastification.show(
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flat,
            title: Text("Success"),
            description:
            Text("Your produce listing has been added and is pending review."),
            alignment: Alignment.bottomCenter,
            autoCloseDuration: const Duration(seconds: 4),
            primaryColor: Color(0xff199f19),
            foregroundColor: Color(0xff0b2115),
          );
          _clearForm();
          Navigator.pop(context);
        } else {
          print('Unexpected non-null response: $response');
          throw Exception('Unexpected response from Supabase: $response');
        }
      } catch (e) {
        print('Error in _submitForm: $e');
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flat,
          title: Text("Error adding listing"),
          description: Text(e.toString()),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          animationBuilder: (context, animation, alignment, child) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          primaryColor: Color(0xffff0000),
          icon: Icon(Iconsax.close_square),
          dragToClose: true,
        );
      }
    }
  }


  void _clearForm() {
    _produceName.clear();
    _quantity.clear();
    _price.clear();
    _imageUrl.clear();
    setState(() {
      _selectedUnit = 'Boxes';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Listing')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _produceName,
              cursorColor: Colors.black,
              decoration: InputDecoration(labelText: 'Produce Name', labelStyle: TextStyle(color: Colors.grey), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a produce name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _quantity,
              cursorColor: Colors.black,
              decoration: InputDecoration(labelText: 'Quantity', labelStyle: TextStyle(color: Colors.grey), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedUnit,
              decoration: InputDecoration(labelText: 'Unit', labelStyle: TextStyle(color: Colors.grey), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
              items: _units.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedUnit = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _price,
              cursorColor: Colors.black,
              decoration: InputDecoration(labelText: 'Price', labelStyle: TextStyle(color: Colors.grey), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _imageUrl,
              cursorColor: Colors.black,
              decoration: InputDecoration(labelText: 'Image URL', labelStyle: TextStyle(color: Colors.grey), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an image URL';
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDDF71D),
                  foregroundColor: Color(0xFF0B2115),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0.5),
              onPressed: _submitForm,
              child: Text('Add Listing'),
            ),
          ],
        ),
      ),
    );
  }
}
