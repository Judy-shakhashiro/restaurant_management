import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../model/cat_model.dart';
import '../model/home_page_model.dart';
import '../services/home-serv.dart'; // Import for video controller

class HomeController extends GetxController {
  // Reactive variables for UI state
  var isLoading = true.obs;
  var errorMessage = Rx<String?>(null);

  // Data models
  var homeData = Rx<HomeModel?>(null);
  var categoriesData = Rx<CategoriesResponse?>(null);

  // UI related state
  var selectedDeliveryIndex = (-1).obs; // For the delivery/takeaway/in-restaurant categories
  var selectedCategoryId = Rx<int?>(null); // For the food categories below the video

  // Video Player Controller
  late VideoPlayerController videoController;
  var isVideoInitialized = false.obs;
  var isVideoPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeVideoPlayer();
    fetchInitialData();
  }

  @override
  void onClose() {
    videoController.dispose();
    super.onClose();
  }

  void _initializeVideoPlayer() {
    videoController = VideoPlayerController.networkUrl(Uri.parse(
        'https://media.istockphoto.com/id/2029934651/video/salad-bowl-of-salmon-avocado-broccoli-olives-and-fresh-romaine-lettuce-poke-bowl-salad-stock.mp4?s=mp4-640x640-is&k=20&c=qAtwpNe4fmXLUdWzEIiOsYfz_LCwNAwZHkYa_knsWfs='))
      ..initialize().then((_) {
        isVideoInitialized.value = true;
        videoController.play();
        isVideoPlaying.value = true;
        videoController.setLooping(true);
      }).catchError((error) {
        print("Error initializing video player: $error");
        // Handle video loading error if needed
      });
  }

  void toggleVideoPlayPause() {
    if (videoController.value.isPlaying) {
      videoController.pause();
      isVideoPlaying.value = false;
    } else {
      videoController.play();
      isVideoPlaying.value = true;
    }
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      // Fetch both futures concurrently
      final results = await Future.wait([
        HomeServ().fetchHomeData(),
        HomeServ().fetchCategories(),
      ]);

      homeData.value = results[0] as HomeModel;
      categoriesData.value = results[1] as CategoriesResponse;

    } catch (e) {
      errorMessage.value = 'Failed to load data: $e';
      print('Error fetching home data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectDeliveryCategory(int index) {
    selectedDeliveryIndex.value = index;
  }

  void selectFoodCategory(int? categoryId) {
    selectedCategoryId.value = categoryId;
    // You might want to refresh products based on selectedCategoryId here
    // e.g., if you have another service call to fetch products by category
  }
}