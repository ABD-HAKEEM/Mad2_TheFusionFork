import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/views/Screens/CartPage.dart';
import 'package:mad1_thefusionfork/views/Screens/cart_manager.dart';
import 'package:mad1_thefusionfork/views/Screens/cartsscreen.dart';

class ProductSinglePage extends StatelessWidget {
  final Map<String, dynamic> item;
  const ProductSinglePage({super.key, required this.item});

  void _addToCart(
    BuildContext context,
    Map<String, dynamic> item, {
    bool buyNow = false,
  }) {
    CartManager.addItem(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart'),
        duration: const Duration(seconds: 2),
      ),
    );

    if (buyNow) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage(item: item)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(item['name'] ?? 'Product Detail'),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  orientation == Orientation.portrait
                      ? _buildPortraitLayout(context)
                      : _buildLandscapeLayout(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    final String name = item['name'] ?? 'Unknown Product';
    final String description = item['description'] ?? '';
    final String imageUrl = 'http://tff.ubay.lk${item['image']}';
    final String price =
        double.tryParse(item['price'].toString())?.toStringAsFixed(2) ?? '0.00';
    final String stock =
        double.tryParse(
          item['stock_quantity'].toString(),
        )?.toStringAsFixed(2) ??
        '0.00';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const Positioned(
              top: 10,
              child: Icon(Icons.fastfood, size: 40, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Price: $price',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              'Stock: $stock',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _addToCart(context, item);
              },
              icon: const Icon(Icons.shopping_bag, size: 18),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () {
                _addToCart(context, item, buyNow: true);
              },
              icon: const Icon(Icons.shopping_bag, size: 18),
              label: const Text('Buy Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 175, 76, 111),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const Spacer(),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Cart(item: item)),
              );
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.shopping_cart),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    final String name = item['name'] ?? '';
    final String description = item['description'] ?? '';
    final String imageUrl = 'http://tff.ubay.lk/${item['image']}';
    final String price =
        double.tryParse(item['price'].toString())?.toStringAsFixed(2) ?? '0.00';
    final String stock =
        double.tryParse(
          item['stock_quantity'].toString(),
        )?.toStringAsFixed(2) ??
        '0.00';

    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 10,
                child: Icon(Icons.fastfood, size: 40, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 10),
              Text(
                'Price: $price',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Stock: $stock',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add your add to cart logic here
                    },
                    icon: const Icon(Icons.shopping_bag, size: 18),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _addToCart(context, item, buyNow: true);
                    },
                    icon: const Icon(Icons.shopping_bag, size: 18),
                    label: const Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 175, 76, 111),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart(item: item)),
                    );
                  },
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
