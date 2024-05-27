class Product {
  final String name;
  final String id;
  final String price;

  Product({required this.name, required this.price, required this.id});

  static Product fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      price: data['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
