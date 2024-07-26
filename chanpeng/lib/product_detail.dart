import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductDetail extends StatelessWidget {
  final int productId;

  ProductDetail({required this.productId});

  Future<Map<String, dynamic>> fetchProductDetails() async {
    final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2/$productId'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        return jsonResponse[0];  // Assuming the first item in the list is the product details
      } else {
        throw Exception('Product not found');
      }
    } else {
      print('Failed to load product details. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load product details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ລາຍລະອຽດຄອມພິວເຕີ',
          style: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load product details'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Image.network(
                      product['image'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'ຊື່ຄອມພິວເຕີ: ${product['pro_name']}',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ລາຄາ: ${product['pro_price']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
