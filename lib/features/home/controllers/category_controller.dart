// import 'package:get/get.dart';
//
// import '/data/repositories/categories/category_repository.dart';
// import '../models/category_model.dart';
//
// class CategoryController extends GetxController {
//   static CategoryController get instance => Get.find();
//
//   final isLoading = false.obs;
//   final _categoryRepositories = Get.put(CategoryRepository());
//   RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
//   RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
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
//   Future<List<CategoryModel>> getCategoryProduct(String categoryId) async {
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
//   //     final List<CategoryModel> categories =
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

import 'package:get/get.dart';

import '/data/repositories/categories/category_repository.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepositories = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> allMainCategories = <CategoryModel>[].obs;

  //
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> subCategories =
      <CategoryModel>[].obs; // For subcategories

  RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories().then((_) {
      assignFirstSubcategory();
    });
  }

  // fetch data
  fetchCategories() async {
    try {
      isLoading.value = true;
      final categories = await _categoryRepositories.getAllCategories();

      //
      allCategories.assignAll(categories);

      //
      allMainCategories.assignAll(
          categories.where((category) => category.parentId.isEmpty).toList());

      //
      featuredCategories.assignAll(categories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());

      //
    } catch (e) {
      throw 'Something wrong when fetch: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch subcategories based on selected parent category
  void fetchSubCategories(String parentId) async {
    try {
      subCategories.assignAll(
        allCategories
            .where((category) => category.parentId == parentId)
            .toList(),
      );
    } catch (e) {
      // Handle errors appropriately
      print("Error fetching subcategories: $e");
      subCategories.clear(); // Clear the list in case of an error
    }
  }

  //
  assignFirstSubcategory() {
    if (featuredCategories.isNotEmpty) {
      selectedCategory.value = featuredCategories[0].id;
      fetchSubCategories(featuredCategories[0].id);
    }
  }
}
