import 'package:flutter/material.dart';
import 'package:mini_commerce/model/product_model/product.dart';
import 'package:uuid/uuid.dart';
import 'package:stripe_payment/stripe_payment.dart';

class CartItem {
  final String id;
  final ProductModel product;
  int quantity;

  CartItem({required this.id, required this.product, required this.quantity});
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  double get totalPrice => _items.values.fold(
    0,
    (sum, item) => sum + (item.product.price ?? 0) * item.quantity,
  );

  int get itemCount => _items.length;

  /// Add a product to the cart
  void add(ProductModel product, {int quantity = 1}) {
    final productId = product.id ?? '';
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += quantity;
    } else {
      _items[productId] = CartItem(
        id: const Uuid().v4(),
        product: product,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  /// Update quantity for a product
  void updateQuantity(ProductModel product, int quantity) {
    final productId = product.id ?? '';
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity = quantity;
    }
    notifyListeners();
  }

  /// Remove a product from the cart
  void remove(ProductModel product) {
    final productId = product.id ?? '';
    _items.remove(productId);
    notifyListeners();
  }

  /// Clear the cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Initialize Stripe (call once in main or provider init)
  void initStripe(String publishableKey) {
    StripePayment.setOptions(
      StripeOptions(
        publishableKey: publishableKey,
        merchantId: "Test",
        androidPayMode: 'test',
      ),
    );
  }

  /// Checkout using Stripe
  Future<bool> checkout() async {
    if (_items.isEmpty) return false;

    try {
      // Step 1: Show Stripe Card Form
      final PaymentMethod paymentMethod =
          await StripePayment.paymentRequestWithCardForm(
            CardFormPaymentRequest(),
          );

      // Step 2: Here, normally you would send paymentMethod to your backend
      // and create a PaymentIntent, then confirm payment with clientSecret
      await Future.delayed(const Duration(seconds: 2)); // simulate processing

      // Step 3: Clear cart after successful payment
      clear();
      return true;
    } catch (e) {
      debugPrint('Checkout error: $e');
      return false;
    }
  }
}
