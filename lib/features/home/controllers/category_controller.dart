import 'package:get/get.dart';

import '/data/repositories/categories/category_repository.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final isLoading = false.obs;
  final _categoryRepositories = Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  // fetch data
  fetchCategories() async {
    try {
      //show loader
      isLoading.value = true;

      // fetch all categories
      final categories = await _categoryRepositories.getAllCategories();

      // update categories list
      allCategories.assignAll(categories);

      //filter featured categories
      featuredCategories.assignAll(categories
          .where((category) => category.isFeatured && category.parentId.isEmpty)
          .take(8)
          .toList());

      //
    } catch (e) {
      throw 'Something wrong when fetch: $e';
    } finally {
      // close loader
      isLoading.value = false;
    }
  }
}
