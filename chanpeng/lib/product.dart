import 'package:flutter/material.dart';
import 'package:product_app/order_list.dart';
import 'main.dart'; // Import the main.dart file
import 'dart:convert'; // Import the dart:convert package to work with JSON
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComputerManagement System',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const Product(),
    );
  }
}

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ລາຍການຄອມພິວເຕີ',
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
      body: ProductGrid(),
    );
  }
}

class ProductData {
  final String imagePath;
  final String name;
  final String price;

  ProductData({required this.imagePath, required this.name, required this.price});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      imagePath: json['image'],
      name: json['pro_name'],
      price: json['pro_price'],
    );
  }
}

Future<List<ProductData>> fetchProducts() async {
  final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((product) => ProductData.fromJson(product)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}

class ProductGrid extends StatefulWidget {
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<List<ProductData>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text(
            'ລາຍການຄອມພິວເຕີ:',
            style: TextStyle(
              fontFamily: 'PhetsarathOT',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<ProductData>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return buildProductCard(context, products[index]);
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OrderList()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text(
              'ເບິ່ງລາຍການສັ່ງຊື້',
              style: TextStyle(fontFamily: 'PhetsarathOT'),
            ),
            style: ElevatedButton.styleFrom(
             backgroundColor: Color.fromARGB(255, 250, 251, 251),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(BuildContext context, ProductData product) {
    return Card(
      elevation: 5.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.network(
            product.imagePath,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Center(child: Text('Error loading image'));
            },
          ),
          const SizedBox(height: 8.0),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'PhetsarathOT',
            ),
          ),
          Text(
            'ລາຄາ: ${product.price} ກີບ',
            style: const TextStyle(
              fontSize: 14.0,
              fontFamily: 'PhetsarathOT',
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Implement your order button action here
            },
            child: const Text(
              'ສັ່ງຊື້',
              style: TextStyle(fontFamily: 'PhetsarathOT'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 250, 251, 251),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
          ),
        ],
      ),
    );
  }
}
