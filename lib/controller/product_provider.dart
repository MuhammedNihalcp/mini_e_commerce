import 'package:flutter/material.dart';

import '../model/product_model/product.dart';
import '../service/product_service.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  ProductProvider() {
    fetchProducts();
  }

  /// Fetch products using stream
  void fetchProducts() {
    _isLoading = true;
    notifyListeners();

    _service.streamProducts().listen(
      (productList) {
        _products = productList;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Get product by ID
  Future<ProductModel?> getProductById(String id) async {
    try {
      return await _service.getProduct(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Search products by name
  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products;
    return _products
        .where(
          (p) => (p.name ?? '').toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
