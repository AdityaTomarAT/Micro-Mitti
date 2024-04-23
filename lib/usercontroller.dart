import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'usermodel.dart';
import 'dart:convert';

class UserController extends GetxController {
  final box = GetStorage();
  Rxn<UserModel> userData = Rxn<UserModel>();

 void saveUserData(UserModel user) {
  box.write('user', json.encode(user.toMap()));
  userData.value = user;

  // final box = GetStorage();
  box.write('user_id', user.userId);
  box.write('user_firstname', user.firstname);
  box.write('user_lastname', user.lastname);
  box.write('user_email', user.email);
  box.write('user_mobilenumber', user.mobilenumber);
  box.write('user_password', user.password);
}

  void loadUserData() {
  // final box = GetStorage();

  if (box.hasData('user')) {
    final userMap = json.decode(box.read('user'));
    final loadedUser = UserModel.fromMap(userMap);
    userData.value = loadedUser;
  }
}

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
}
