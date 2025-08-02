import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 2.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    update();
  }
}