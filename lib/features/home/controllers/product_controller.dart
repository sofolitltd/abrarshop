import 'package:abrar_shop/data/repositories/products/product_repository.dart';
import 'package:abrar_shop/features/home/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final _productRepositories = Get.put(ProductRepository());
  RxList<ProductModel> allProducts = <ProductModel>[].obs;
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  //
  fetchProducts() async {
    try {
      // loading
      isLoading.value = true;

      //
      final products = await _productRepositories.getAllProducts();

      //
      allProducts.assignAll(products);
      featuredProducts.assignAll(
          products.where((product) => product.isFeatured).take(10).toList());
    } catch (e) {
      throw "Product | catch : $e";
    } finally {
      isLoading.value = false;
    }
  }
}
