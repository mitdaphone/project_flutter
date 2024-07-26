import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'manage_product.dart';

class ProductEdit extends StatefulWidget {
  final int productId;

  ProductEdit({required this.productId});

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;
  int category = 1;  // Category should be an integer

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _imageUrlController = TextEditingController();
    _fetchProductDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _fetchProductDetails() async {
    final response = await http.get(Uri.parse('https://store.annymarket.shop/public/api/product_2/${widget.productId}'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty) {
        final product = jsonResponse[0];
        setState(() {
          _nameController.text = product['pro_name'];
          _priceController.text = product['pro_price'].toString();
          _imageUrlController.text = product['image'];
          category = product['category'];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load product details')),
      );
    }
  }

  Future<void> _updateProduct() async {
    final url = Uri.parse('https://store.annymarket.shop/public/api/product_2/${widget.productId}');
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'pro_name': _nameController.text,
        'pro_price': int.parse(_priceController.text),
        'category': category,
        'image': _imageUrlController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ManageProduct()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('Failed to update product. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ແກ້ໄຂຂໍ້ມູນຄອມພິວເຕີ',
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'ຊື່ຄອມພິວເຕີ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ກະລຸນາປ້ອນຊື່ຄອມພິວເຕີ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'ລາຄາ'),
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
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'ທີ່ຢູ່ຮູບພາບ'),
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
                    _updateProduct();
                  }
                },
                child: Text('ບັນທຶກການແກ້ໄຂ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
