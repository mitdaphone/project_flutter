import 'package:flutter/material.dart';
import 'package:product_app/create_product.dart';
import 'package:product_app/product_edit.dart';
import 'product_detail.dart';
import 'main.dart'; // Import the main.dart file
import 'dart:convert';
import 'package:http/http.dart' as http;

// Define the Product model
class get_Product {
  final int id;
  final String proName;
  final String proPrice;
  final String imageUrl;

  get_Product({required this.id, required this.proName, required this.proPrice, required this.imageUrl});

  factory get_Product.fromJson(Map<String, dynamic> json) {
    return get_Product(
      id: json['id'],
      proName: json['pro_name'],
      proPrice: json['pro_price'],
      imageUrl: json['image'],
    );
  }
}

// Function to fetch products from API
Future<List<get_Product>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((product) => get_Product.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

// Function to delete a product by ID
Future<void> deleteProduct(int id) async {
  final response = await http.delete(
    Uri.parse('https://store.annymarket.shop/public/api/product_2/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete product');
  }
}

class ManageProduct extends StatelessWidget {
  const ManageProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ຈັດການຄອມພິວເຕີ',
          style: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => ProductForm()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'ເພີ່ມຄອມພິວເຕີ',
                style: TextStyle(fontFamily: 'PhetsarathOT'),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<get_Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load products'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text('ລຳດັບ'),
                        ),
                        DataColumn(
                          label: Text('ຊື່'),
                        ),
                        DataColumn(
                          label: Text('ລາຄາ'),
                        ),
                        DataColumn(
                          label: Text('ຈັດການ'),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                        snapshot.data!.length,
                        (index) {
                          final product = snapshot.data![index];
                          return DataRow(
                            cells: <DataCell>[
                              DataCell(Text((index + 1).toString())), // Displaying the index + 1
                              DataCell(Text(product.proName)),
                              DataCell(Text(product.proPrice)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.info),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetail(
                                            productId: product.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductEdit(
                                            productId: product.id,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async {
                                      bool? confirmed = await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('ລືບລາຍການຄອມພິວເຕີ'),
                                          content: Text('ທ່ານໝັ້ນໃຈບໍ່ວ່າຈະລົບລາຍການນີ້'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('ບໍ່'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text('ແມ່ນແລ້ວ'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirmed == true) {
                                        try {
                                          await deleteProduct(product.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Product deleted successfully')),
                                          );
                                          // Refresh the products list
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(builder: (context) => const ManageProduct()),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to delete product')),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ],
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
