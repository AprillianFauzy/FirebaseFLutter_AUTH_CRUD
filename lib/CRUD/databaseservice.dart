import 'package:belajarfirebase/CRUD/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushNamed(context, '/login');
  }

  void addProduct(Product product) async {
    final productRef = _database.ref().child('products');
    await productRef.push().set(product.toMap());
    print("Data berhasil dikirim");
  }

  Stream<List<Product>> getProducts() {
    final databaseReference = _database.ref('products');
    return databaseReference.onValue.map((event) {
      final data = event.snapshot.value;
      if (data == null) {
        print('Data kosong');
        return [];
      } else
        () {
          print('Data didapatkan');
          print(data);
          return;
        };

      try {
        final Map<dynamic, dynamic> dataMap = data as Map<dynamic, dynamic>;
        final products = dataMap.entries.map((entry) {
          final productMap = Map<String, dynamic>.from(entry.value as Map);
          return Product.fromMap(
              productMap, entry.key); // Gunakan key sebagai product ID
        }).toList();
        return products;
      } catch (e) {
        print("Error casting data: $e");
        return [];
      }
    });
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final reference = _database.ref().child('products/$productId');
      DataSnapshot snapshot = await reference.get();

      if (snapshot.exists) {
        await reference.remove();
        print("Data berhasil dihapus");
      } else {
        print("Produk tidak ditemukan");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateProduct(Product updatedProduct) async {
    try {
      final reference = _database.ref().child('products/${updatedProduct.id}');
      await reference.update(updatedProduct.toMap());
      print("Data berhasil diupdate"); // Update message
    } catch (e) {
      print('Error updating product: $e');
    }
  }
}
