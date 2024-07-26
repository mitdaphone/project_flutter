import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:product_app/about_us.dart';
import 'package:product_app/manage_product.dart';
import 'package:product_app/product.dart';
import 'package:product_app/login.dart'; // Import the login page
import 'order_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'PhetsarathOT'),
          bodyMedium: TextStyle(fontFamily: 'PhetsarathOT'),
          bodySmall: TextStyle(fontFamily: 'PhetsarathOT'),
          displayLarge: TextStyle(fontFamily: 'PhetsarathOT'),
          displayMedium: TextStyle(fontFamily: 'PhetsarathOT'),
          displaySmall: TextStyle(fontFamily: 'PhetsarathOT'),
          headlineLarge: TextStyle(fontFamily: 'PhetsarathOT'),
          headlineMedium: TextStyle(fontFamily: 'PhetsarathOT'),
          headlineSmall: TextStyle(fontFamily: 'PhetsarathOT'),
          titleLarge: TextStyle(fontFamily: 'PhetsarathOT'),
          titleMedium: TextStyle(fontFamily: 'PhetsarathOT'),
          titleSmall: TextStyle(fontFamily: 'PhetsarathOT'),
          labelLarge: TextStyle(fontFamily: 'PhetsarathOT'),
          labelMedium: TextStyle(fontFamily: 'PhetsarathOT'),
          labelSmall: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
      ),
      home: LoginScreen(), // Set LoginScreen as the initial screen
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ໜ້າຫຼັກ',
          style: TextStyle(fontFamily: 'PhetsarathOT'),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              accountName: Text(
                'ຜູ້ໃຊ້ງານ',
                style: TextStyle(fontFamily: 'PhetsarathOT', color: Colors.white, fontSize: 20),
              ),
              accountEmail: Text(
                'user@example.com',
                style: TextStyle(fontFamily: 'PhetsarathOT', color: Colors.white),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'ຜູ້ໃຊ້',
                  style: TextStyle(fontFamily: 'PhetsarathOT', color: Colors.teal, fontSize: 24),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.teal),
              title: const Text(
                'ອອກຈາກລະບົບ',
                style: TextStyle(fontFamily: 'PhetsarathOT'),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  buildNavigationCard(
                    context,
                    FontAwesomeIcons.laptop,
                    'ລາຍການຄອມພິວເຕີ',
                    const Product(),
                  ),
                  buildNavigationCard(
                    context,
                    FontAwesomeIcons.shoppingCart,
                    'ການສັ່ງຄອມພິວເຕີ',
                    const OrderList(),
                  ),
                  buildNavigationCard(
                    context,
                    FontAwesomeIcons.cogs,
                    'ຈັດການຄອມພິວເຕີ',
                    const ManageProduct(),
                  ),
                  buildNavigationCard(
                    context,
                    FontAwesomeIcons.infoCircle,
                    'ກ່ຽວກັບພວກເຮົາ',
                    const AboutUs(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavigationCard(BuildContext context, IconData icon, String text, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(icon, size: 50, color: Colors.teal),
            const SizedBox(height: 10),
            Center(
              child: Text(
                text,
                style: const TextStyle(fontFamily: 'PhetsarathOT', fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
