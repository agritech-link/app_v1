class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String unit;
  final int quantity;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.unit,
    required this.quantity,
  });
}

class ProductService {
  final List<Product> _products = [
    Product(name: 'Beefsteak tomato', imageUrl: '', price: 250.00, unit: 'Box', quantity: 10),
    Product(name: 'Hass Avocado', imageUrl: '', price: 250.00, unit: 'Box', quantity: 38),
    Product(name: 'Spelt Wheat', imageUrl: '', price: 950.00, unit: 'Bag', quantity: 5000),
    Product(name: 'Tangerine Oranges', imageUrl: '', price: 950.00, unit: 'Bag', quantity: 1000),
    Product(name: 'Button Mushrooms', imageUrl: '', price: 180.00, unit: 'Box', quantity: 20),
    Product(name: 'Red Bell Peppers', imageUrl: '', price: 300.00, unit: 'Box', quantity: 15),
    Product(name: 'Baby Spinach', imageUrl: '', price: 200.00, unit: 'Bag', quantity: 500),
    Product(name: 'Sweet Potatoes', imageUrl: '', price: 400.00, unit: 'Bag', quantity: 2000),
    Product(name: 'Green Beans', imageUrl: '', price: 150.00, unit: 'Box', quantity: 25),
    Product(name: 'Butternut Squash', imageUrl: '', price: 350.00, unit: 'Each', quantity: 1),
  ];

  List<Product> getProducts() {
    return _products;
  }

  List<Product> filterProducts(String query) {
    return _products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
