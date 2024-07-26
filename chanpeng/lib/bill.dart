import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Bill_Product {
  final int id;
  final String proName;
  final String proPrice;
  final int qty;

  Bill_Product({required this.id, required this.proName, required this.proPrice, this.qty = 1});

  factory Bill_Product.fromJson(Map<String, dynamic> json) {
    return Bill_Product(
      id: json['id'],
      proName: json['pro_name'],
      proPrice: json['pro_price'].toString(),
    );
  }
}

class Bill extends StatelessWidget {
  const Bill({Key? key}) : super(key: key);

  Future<List<Bill_Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Bill_Product> products = jsonResponse.map((product) => Bill_Product.fromJson(product)).toList();
      return products.take(5).toList();  // Take only 5 products or less
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ໃບບິນ',
          style: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue,
                      child: const Text(
                        'ລະຫັດໃບບິນ: 00001',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue,
                      child: const Text(
                        'ວັນທີ: 26/07/2024',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            FutureBuilder<List<Bill_Product>>(
              future: fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load products'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('ຍັງບໍ່ມີສິນຄ້າ'));
                } else {
                  final products = snapshot.data!;
                  final totalQty = products.fold(0, (sum, item) => sum + item.qty);
                  final totalPrice = products.fold(0, (sum, item) => sum + int.parse(item.proPrice));

                  return Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ລຳດັບ')),
                          DataColumn(label: Text('ຊື່ຄອມພິວເຕີ')),
                          DataColumn(label: Text('ລາຄາ')),
                          DataColumn(label: Text('ຈຳນວນ')),
                        ],
                        rows: [
                          ...products.map((product) {
                            final index = products.indexOf(product) + 1;
                            return DataRow(cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Text(product.proName)),
                              DataCell(Text(product.proPrice)),
                              DataCell(Text(product.qty.toString())),
                            ]);
                          }).toList(),
                          DataRow(cells: [
                            const DataCell(Text('ລວມທັງໝົດ(ກີບ)', style: TextStyle(fontWeight: FontWeight.bold))),
                            const DataCell(Text('')),
                            DataCell(Text(totalPrice.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                            DataCell(Text(totalQty.toString(), style: const TextStyle(fontWeight: FontWeight.bold))),
                          ]),
                        ],
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
