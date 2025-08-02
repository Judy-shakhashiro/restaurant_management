import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/dish.dart';
import '../model/favorite_model.dart';
import '../services/api_service.dart';
import '../services/search_service.dart';

class MySearchController extends GetxController {
  final selectedTagIds = <int>[].obs;// For active tags
  final tags = <Tag>[].obs;

  Future<void> _loadTags() async {
    tags.value = await ApiService().fetchTags();}

  // Text editing
  final searchText = TextEditingController();
  final SearchService service=SearchService();
  final errorMessage= RxnString();
  // State
  var query = ''.obs;
  var isLoading = false.obs;
  var results = <Dish>[].obs; // replace String with your model
  var showSummaryList = true.obs;
  @override
  void onInit() {
    super.onInit();
    _loadTags();
    searchText.addListener(() {
      final text = searchText.text.trim();

      if (text != query.value && text.length > 2) {
        query.value = text;
        performSearch(text);
      }

      if (text.isEmpty) {
        results.clear();
      }
    });
  }

  void toggleTag(int tagId) async {
    if (selectedTagIds.contains(tagId)) {
      selectedTagIds.remove(tagId);
      results.clear();
      await performSearch(query.value);
    } else {
      selectedTagIds.add(tagId);
      results.clear();
     await performSearch(query.value);
    }}
  Future<void> performSearch(String text) async {

    if (text.isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;
    final res=await service.fetchSearchResults(text,selectedTagIds);
    print(res);
    results.value=res;
    isLoading.value = false;
  }


  @override
  void onClose() {
    searchText.dispose();
    super.onClose();
  }
}
