import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:product_app/manage_product.dart';

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String price = '';
  String imageUrl = '';
  int category = 2;  // Category should be an integer

  Future<void> _createProduct() async {
    final url = Uri.parse('https://store.annymarket.shop/public/api/product_2');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'pro_name': name,
        'pro_price': int.parse(price),  // Parse price as an integer
        'category': category,  // Ensure category is sent as an integer
        'image': imageUrl,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product created successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ManageProduct()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('Failed to create product. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create product.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ບັນທຶກຄອມພິວເຕີ',
          style: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ManageProduct()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'ຊື່ຄອມພິວເຕີ'),
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ຄອມພິວເຕີ';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ລາຄາ'),
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນລາຄາ';
                  }
                  if (int.tryParse(value) == null) {
                    return 'ກະລຸນາປ້ອນລາຄາເປັນຕົວເລກ';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ທີ່ຢູ່ຮູບພາບ'),
                onChanged: (value) {
                  setState(() {
                    imageUrl = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນ ທີ່ຢູ່ຮູບພາບ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _createProduct();
                  }
                },
                child: Text('ເພີ່ມຄອມພິວເຕີ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
