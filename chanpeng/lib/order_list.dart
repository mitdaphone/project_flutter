import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/main.dart';
import 'dart:convert';
import 'bill.dart';

class Order_Product {
  final int id;
  final String proName;
  final String proPrice;
  final int qty;

  Order_Product({required this.id, required this.proName, required this.proPrice, this.qty = 1});

  factory Order_Product.fromJson(Map<String, dynamic> json) {
    return Order_Product(
      id: json['id'],
      proName: json['pro_name'],
      proPrice: json['pro_price'].toString(),
    );
  }
}

class OrderList extends StatelessWidget {
  const OrderList({Key? key}) : super(key: key);

  Future<List<Order_Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      List<Order_Product> products = jsonResponse.map((product) => Order_Product.fromJson(product)).toList();
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
          'ລາຍການສັ່ງຊື້ຄອມພິວເຕີ',
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
          children: <Widget>[
            FutureBuilder<List<Order_Product>>(
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
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
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Bill()),
                );
              },
              child: const Text('ເບິ່ງໃບບິນ'),
            ),
          ],
        ),
      ),
    );
  }
}
