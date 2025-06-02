import 'package:flutter/material.dart';
import 'package:mad1_thefusionfork/views/Screens/ProductSinglePage.dart';
import 'package:mad1_thefusionfork/views/Screens/cart_manager.dart';
import 'package:mad1_thefusionfork/views/Screens/cartsscreen.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const ProductCard({super.key, required this.item});

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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductSinglePage(item: item),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Image.network(
                'http://tff.ubay.lk${item['image']}',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] ?? 'Menu Item',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['description'] ?? 'No description available',
                      style: TextStyle(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' ${double.tryParse(item['price'].toString())?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Stock: ${item['stock_quantity'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _addToCart(context, item, buyNow: true);
                            },
                            icon: const Icon(Icons.shopping_bag, size: 18),
                            label: const Text('Buy Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                175,
                                76,
                                111,
                              ),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _addToCart(context, item);
                            },
                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                            label: const Text('Add to Cart'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Color.fromARGB(255, 175, 76, 111),
                              ),
                              foregroundColor: const Color.fromARGB(
                                255,
                                175,
                                76,
                                111,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
