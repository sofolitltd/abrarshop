import 'package:abrar_shop/features/authentication/models/user_model.dart';
import 'package:get/get.dart';

import '/data/repositories/users/user_repository.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final isLoading = false.obs;
  final _userRepositories = Get.put(UserRepository());

  Rx<UserModel> user = UserModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchUser(); // Fetch user data when the controller is initialized
  }

  Future<void> fetchUser() async {
    try {
      isLoading.value = true;
      final fetchedUser = await _userRepositories.getUser();
      user.value = fetchedUser; // Update the user observable
    } catch (e) {
      // Handle errors appropriately (e.g., show a snackbar)
      print('Error fetching user: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
