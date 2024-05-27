import 'package:belajarfirebase/CRUD/Product.dart';
import 'package:belajarfirebase/CRUD/databaseservice.dart';
import 'package:flutter/material.dart';

class CRUDPage extends StatefulWidget {
  const CRUDPage({super.key});

  @override
  State<CRUDPage> createState() => _CRUDPageState();
}

class _CRUDPageState extends State<CRUDPage> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController pricecontroller = TextEditingController();

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dialog Title'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pricecontroller,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  _addProduct();
                },
                child: Text('Create'))
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Product product) {
    namecontroller.text = product.name;
    pricecontroller.text = product.price;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: namecontroller,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pricecontroller,
                  decoration: InputDecoration(labelText: 'Price'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  _editProduct(product.id);
                },
                child: Text('Save'))
          ],
        );
      },
    );
  }

  void _addProduct() async {
    final String uniqueId = _generateUniqueId(); // Generate a unique ID
    final NewProduct = Product(
        id: uniqueId, name: namecontroller.text, price: pricecontroller.text);
    DatabaseService().addProduct(NewProduct);
    namecontroller.clear();
    pricecontroller.clear();
    Navigator.pop(context);
  }

  void _editProduct(String productId) async {
    final updatedProduct = Product(
        id: productId, name: namecontroller.text, price: pricecontroller.text);
    DatabaseService().updateProduct(updatedProduct); // Use update method
    namecontroller.clear();
    pricecontroller.clear();
    Navigator.pop(context);
  }

  String _generateUniqueId() {
    // Combine multiple techniques for robust uniqueness
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomString = UniqueKey().toString(); // Use UniqueKey for randomness

    return '$timestamp-$randomString'; // Concatenate for combined uniqueness
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Products',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    DatabaseService().logout(context);
                  },
                  child: Text('Log Out')),
              Expanded(
                child: StreamBuilder<List<Product>>(
                  stream: DatabaseService().getProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData) {
                      Center(
                        child: Text("tidak ada data yang ditemukan"),
                      );
                    }

                    if (snapshot.hasData) {
                      final products = snapshot.data!;
                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Container(
                            child: ListTile(
                              title: Text(product.name),
                              subtitle: Text(product.price),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      _showEditDialog(context, product);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      DatabaseService()
                                          .deleteProduct(product.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }

                    // Show a loading indicator while waiting for initial data
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialog(context);
            print('Floating Action Button Pressed');
          },
          child: Icon(Icons.add),
          tooltip: 'Add',
        ),
      ),
    );
  }
}
