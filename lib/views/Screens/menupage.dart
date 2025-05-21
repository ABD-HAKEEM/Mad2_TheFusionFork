import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/theme_provider.dart';
import 'package:mad1_thefusionfork/views/Screens/CartPage.dart';
import 'package:mad1_thefusionfork/views/Screens/HomeScreen.dart';
import 'package:mad1_thefusionfork/views/Screens/accountscreen.dart';
import 'package:mad1_thefusionfork/views/Screens/productcard.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 1;
  List<dynamic> menuItems = [];
  bool isLoading = true;
  String errorMessage = '';
  String baseUrl = 'http://127.0.0.1:8000';

  @override
  void initState() {
    super.initState();
    fetchMenuItems();
  }

  Future<void> fetchMenuItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/products'),
        headers: {
          'Accept': 'applicatioxn/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          menuItems = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load menu items: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const homepage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MenuPage()), // Navigate to CartsScreen
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Cart(
                    item: {},
                  )), // Navigate to CartsScreen
        );
        break;
      case 3:
        // Account tab selected
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Accpage()), // Navigate to AccountScreen
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deliver to',
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text('Main Street, Colombo 3', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) {
                    return ProductCard(item: menuItems[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Cart(item: {}),
            ),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.shopping_cart),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
