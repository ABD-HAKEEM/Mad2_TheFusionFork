import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/views/Screens/cartsscreen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:mad1_thefusionfork/views/Screens/menupage.dart';
import 'cart_manager.dart';

class Cart extends StatefulWidget {
  const Cart({super.key, required Map item});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late final StreamSubscription<GyroscopeEvent> _gyroSubscription;
  bool _cartCleared = false;

  @override
  void initState() {
    super.initState();
    _startGyroscopeListener();
  }

  void _startGyroscopeListener() {
    _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      const double rotationThreshold = 5.0;

      // If user shakes/rotates the phone fast enough and cart isn't already cleared
      if (!_cartCleared &&
          (event.x.abs() > rotationThreshold ||
              event.y.abs() > rotationThreshold)) {
        _cartCleared = true;

        setState(() {
          CartManager.clearCart();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Cart cleared via gyroscope!"),
            duration: Duration(seconds: 2),
          ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MenuPage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager.items;

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: Colors.orange,
        ),
        body: const Center(child: Text('Your cart is empty!')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return ListTile(
            leading: Image.network(
              'http://tff.ubay.lk/${item['image']}',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.fastfood),
            ),
            title: Text(item['name'] ?? ''),
            subtitle: Text('Price: \$${item['price']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  CartManager.removeItem(item);
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${CartManager.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CartManager.clearCart();
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 234, 130, 120),
              ),
              child: const Text('Clear Cart'),
            ),
            ElevatedButton(
              onPressed: () {
                // Pass the entire cart or the first item as an example
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CartPage(
                          item: cartItems.isNotEmpty ? cartItems[0] : {},
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 145, 175, 76),
              ),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
