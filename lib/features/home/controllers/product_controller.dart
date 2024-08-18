import 'package:abrar_shop/data/repositories/products/product_repository.dart';
import 'package:abrar_shop/features/home/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final _productRepositories = Get.put(ProductRepository());

  RxList<ProductModel> allProducts = <ProductModel>[].obs;

  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  RxList<ProductModel> allFeaturedProducts = <ProductModel>[].obs;

  RxList<ProductModel> categoryProducts = <ProductModel>[].obs;
  RxList<ProductModel> subCategoryProducts = <ProductModel>[].obs;

  final RxString selectedSortOption = 'Name'.obs;
  final RxString selectedFeaturedSortOption = 'Name'.obs;
  final RxString selectedCategorySortOption = 'Name'.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  // featured product
  fetchProducts() async {
    try {
      // loading
      isLoading.value = true;

      //
      final products = await _productRepositories.getAllProducts();

      // all products
      allProducts.assignAll(products);

      // featured product limited
      featuredProducts.assignAll(
        products.where((product) => product.isFeatured).take(8).toList(),
      );

      // all
      allFeaturedProducts.assignAll(
        products.where((product) => product.isFeatured).toList(),
      );
    } catch (e) {
      throw "Product | catch : $e";
    } finally {
      isLoading.value = false;
    }
  }

  // product by category
  Future<List<ProductModel>> getCategoryProduct(String categoryId) async {
    try {
      categoryProducts.assignAll(
        allProducts
            .where((product) => product.categoryId == categoryId)
            .toList(),
      );
      return categoryProducts;
    } catch (e) {
      throw "Product | catch : $e";
    }
  }

  //
  Future<List<ProductModel>> getSubCategoryProduct(String subCategoryId) async {
    try {
      subCategoryProducts.assignAll(
        allProducts
            .where((product) => product.subCategoryId == subCategoryId)
            .toList(),
      );
      return subCategoryProducts;
    } catch (e) {
      throw "Product | catch : $e";
    }
  }

  //
  void setProducts(String setOption, List<ProductModel> products) {
    selectedSortOption.value = setOption;

    // Sort only if the product list is not empty
    if (products.isNotEmpty) {
      List<ProductModel> sortedProducts = List.from(products); // Create a copy

      switch (setOption) {
        case 'Name':
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Low to High':
          sortedProducts.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          break;
        case 'High to Low':
          sortedProducts.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          break;
        default:
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
      }

      allProducts.assignAll(sortedProducts); // Update the observable list
    }
  }

  //
  void setFeaturedProducts(String setOption, List<ProductModel> products) {
    selectedFeaturedSortOption.value = setOption;

    // Sort only if the product list is not empty
    if (products.isNotEmpty) {
      List<ProductModel> sortedProducts = List.from(products); // Create a copy

      switch (setOption) {
        case 'Name':
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Low to High':
          sortedProducts.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          break;
        case 'High to Low':
          sortedProducts.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          break;
        default:
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
      }

      allFeaturedProducts
          .assignAll(sortedProducts); // Update the observable list
    }
  }

  //
  void setCategoryProducts(String setOption, List<ProductModel> products) {
    selectedCategorySortOption.value = setOption;

    // Sort only if the product list is not empty
    if (products.isNotEmpty) {
      List<ProductModel> sortedProducts = List.from(products); // Create a copy

      switch (setOption) {
        case 'Name':
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Low to High':
          sortedProducts.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          break;
        case 'High to Low':
          sortedProducts.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          break;
        default:
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
      }

      categoryProducts.assignAll(sortedProducts); // Update the observable list
    }
  }

  //
  void setSubCategoryProducts(String setOption, List<ProductModel> products) {
    selectedCategorySortOption.value = setOption;

    // Sort only if the product list is not empty
    if (products.isNotEmpty) {
      List<ProductModel> sortedProducts = List.from(products); // Create a copy

      switch (setOption) {
        case 'Name':
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
          break;
        case 'Low to High':
          sortedProducts.sort((a, b) => a.salePrice.compareTo(b.salePrice));
          break;
        case 'High to Low':
          sortedProducts.sort((a, b) => b.salePrice.compareTo(a.salePrice));
          break;
        default:
          sortedProducts.sort((a, b) => a.name.compareTo(b.name));
      }

      subCategoryProducts
          .assignAll(sortedProducts); // Update the observable list
    }
  }
}
