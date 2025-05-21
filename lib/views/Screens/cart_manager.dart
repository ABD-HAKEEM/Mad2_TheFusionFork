class CartManager {
  static final List<Map<String, dynamic>> _cartItems = [];

  static List<Map<String, dynamic>> get items => _cartItems;

  static void addItem(Map<String, dynamic> item) {
    _cartItems.add(item);
  }

  static void clearCart() {
    _cartItems.clear();
  }

  static void removeItem(Map<String, dynamic> item) {
    _cartItems.remove(item);
  }

  static double get totalPrice => _cartItems.fold(0, (sum, item) {
        final price = item['price'];
        if (price is String) {
          return sum + (double.tryParse(price) ?? 0.0);
        } else if (price is num) {
          return sum + price.toDouble();
        }
        return sum;
      });
}
