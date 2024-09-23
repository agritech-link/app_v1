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

        final response = await supabase.from('produce_listings').insert(newListing);

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Listing added successfully')),
          );
          _clearForm();
        } else {
          throw response?.error ?? Exception('Unknown error occurred');
        }
      } catch (e) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: Text("Error adding listing."),
          description: Text("Something went wrong. Please try again"),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          animationBuilder: (
              context,
              animation,
              alignment,
              child,
              ) {
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
              decoration: InputDecoration(labelText: 'Produce Name'),
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
              decoration: InputDecoration(labelText: 'Quantity'),
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
              decoration: InputDecoration(labelText: 'Unit'),
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
              decoration: InputDecoration(labelText: 'Price'),
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
              decoration: InputDecoration(labelText: 'Image URL'),
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
