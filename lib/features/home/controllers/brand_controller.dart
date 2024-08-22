// import 'package:get/get.dart';
//
// import '/data/repositories/categories/brand_repository.dart';
// import '../models/category_model.dart';
//
// class CategoryController extends GetxController {
//   static CategoryController get instance => Get.find();
//
//   final isLoading = false.obs;
//   final _categoryRepositories = Get.put(CategoryRepository());
//   RxList<BrandModel> allCategories = <BrandModel>[].obs;
//   RxList<BrandModel> featuredCategories = <BrandModel>[].obs;
//
//   RxString selectedCategory = ''.obs;
//
//   @override
//   void onInit() {
//     fetchCategories();
//     super.onInit();
//   }
//
//   // fetch data
//   fetchCategories() async {
//     try {
//       //show loader
//       isLoading.value = true;
//
//       // fetch all categories
//       final categories = await _categoryRepositories.getAllCategories();
//
//       // update categories list
//       allCategories.assignAll(categories);
//
//       //filter featured categories
//       featuredCategories.assignAll(categories
//           .where((category) => category.isFeatured && category.parentId.isEmpty)
//           .take(8)
//           .toList());
//
//       //
//     } catch (e) {
//       throw 'Something wrong when fetch: $e';
//     } finally {
//       // close loader
//       isLoading.value = false;
//     }
//   }
//
//   // product by category
//   Future<List<BrandModel>> getCategoryProduct(String categoryId) async {
//     try {
//       allCategories.assignAll(
//         allCategories.where((category) => category.parentId == categoryId).toList(),
//       );
//       return allCategories;
//     } catch (e) {
//       throw "Product | catch : $e";
//       return [];
//     }
//   }
//
// //
//   // fetchCategoriesByQuery(Query? query) async {
//   //   try {
//   //     if (query == null) return [];
//   //
//   //     // loading
//   //     isLoading.value = true;
//   //
//   //     //
//   //     final List<BrandModel> categories =
//   //         await _categoryRepositories.getCategoriesByQuery(query);
//   //
//   //     return categories;
//   //   } catch (e) {
//   //     throw "Categories | catch : $e";
//   //     return [];
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
// }

import 'package:abrar_shop/data/repositories/brands/brand_repository.dart';
import 'package:abrar_shop/features/home/models/brand_model.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  final isLoading = false.obs;
  final _brandsRepository = Get.put(BrandRepository());
  RxList<BrandModel> allBrands = <BrandModel>[].obs;
  RxList<BrandModel> allMainBrands = <BrandModel>[].obs;

  //
  RxList<BrandModel> featuredBrands = <BrandModel>[].obs;

  RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  // fetch data
  fetchBrands() async {
    try {
      isLoading.value = true;
      final brands = await _brandsRepository.getAllBrands();

      //
      allBrands.assignAll(brands);

      //
      featuredBrands.assignAll(
          brands.where((brand) => brand.isFeatured).take(8).toList());

      //
    } catch (e) {
      throw 'Something wrong when fetch: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
