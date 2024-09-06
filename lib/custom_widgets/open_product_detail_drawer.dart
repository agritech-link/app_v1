import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

void openProductDetailDrawer(BuildContext context, String productName, String imageUrl, String quantity, String price) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false,
        builder: (_, controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image with height based on screen size
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Content with padding
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product details
                        Text(
                          productName,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(quantity, style: TextStyle(color: Colors.grey, fontSize: 16)),
                        SizedBox(height: 8),
                        Text(
                          price,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        // Additional content
                        Text(
                          'Additional information about the product can be displayed here.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        // Full-width button
                        Center(
                          child: SizedBox(
                            width: double.infinity, // This makes the button take the full width
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                              onPressed: () {
                                // Handle button press
                              },
                              child: Text('Buy Now'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
