import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_commerce/model/product_model/product.dart';

class ProductService {
  final CollectionReference _productCollection = FirebaseFirestore.instance
      .collection('products');

  /// Stream all products as a list of ProductModel
  Stream<List<ProductModel>> streamProducts() {
    return _productCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromJson({'id': doc.id, ...data});
      }).toList();
    });
  }

  /// Get a single product by ID
  Future<ProductModel?> getProduct(String id) async {
    try {
      final doc = await _productCollection.doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return ProductModel.fromJson({'id': doc.id, ...data});
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}
