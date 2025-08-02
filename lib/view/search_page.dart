import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/view/widgets/dish_item.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../controller/search_controller.dart';
import '../globals.dart';
import '../model/favorite_model.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MySearchController>(
      init: MySearchController(),
      builder: (ctrl) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0,right: 8,left: 8),
                  child: Obx(() => TextField(
                    onChanged: (text){
                      ctrl.showSummaryList.value = true;
                      ctrl.results.clear();
                      ctrl.errorMessage.value=null;
                    },
                    onSubmitted: (text){
                      if ((text.length < 3)&&ctrl.selectedTagIds.isNotEmpty||(text.length < 3)) {
                        ctrl.errorMessage.value = 'Enter at least 3 characters';
                      }
                      ctrl.query.value = text;
                      ctrl.showSummaryList.value = false; // hide suggestions
                    },
                    controller: ctrl.searchText,
                    decoration: InputDecoration(
                      hintText: 'Search something...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey)
                      ),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.orange),
                      borderRadius: BorderRadius.circular(30)),
                      errorText: ctrl.errorMessage.value, // show the error
                    ),
                  )),
                ),

            Obx(()=>
             Container(
              height: 50,
              margin: const EdgeInsets.all(8),
                      child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ctrl.tags.length,
                      itemBuilder: (_, i) {
                      final Tag tag = ctrl.tags[i];
                      return GestureDetector(
                      onTap: () {
                      // showDialog(context: context, builder:(BuildContext context){
                      //   return Center(child: Icon(Icons.restaurant));
                      // });
                      ctrl.toggleTag(tag.id);

                      },
                      child: Obx(() {
                      final active = ctrl.selectedTagIds.contains(tag.id);
                      return Container(
                      margin: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 6),
                      padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                      color: active
                      ? Colors.orange
              : tagColors[i % tagColors.length], // Assuming tagColors is accessible
                      borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                      tag.name,
                      style: TextStyle(
                      fontSize: active ? 16 : 14,
                      color: active ? Colors.white : Colors.black,
                      ),
                      ),
                      );
                      }),
                      );
                      },
                      ),
                      ),
            ),
                Expanded(
                  child: Obx(() {
                    // 1) No query yet → show center animation
                    if (ctrl.query.value.isEmpty|| ctrl.query.value.length<3) {
                      return Center(
                        child: Icon(Icons.search,size: 50,),
                        // child: Lottie.asset(
                        //   'assets/animations/search.json',
                        //   width: 200,
                        //   height: 200,
                        //   repeat: true,
                        // ),
                        //
                      );
                    }
                    // 2) Searching → spinner
                    if (ctrl.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // 3) Show results (or “no results”)
                    if (ctrl.results.isEmpty&& ctrl.searchText.value.text.length>3) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text(
                                'No dishes found for the selected tags and search.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Please try different search and filters.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (ctrl.showSummaryList.value) {
                      // Show summary suggestions (names only)
                      return ListView.separated(
                        itemCount: ctrl.results.length,
                        separatorBuilder: (_, __) => Divider(),
                        itemBuilder: (_, i) {
                          final item = ctrl.results[i];
                          return ListTile(
                            title: Text(item.name),
                            leading: Container(
                              clipBehavior: Clip.hardEdge,
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),),
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network('$backUrl/images/${item
                                  .image}',fit: BoxFit.cover,),
                            )),
                            onTap: () {
                              ctrl.searchText.text = item.name;
                              ctrl.query.value = item.name;
                              ctrl.showSummaryList.value = false;
                            },
                          );
                        },
                      );
                    }

                    else{
                    return ListView.builder(
                      itemCount: ctrl.results.length,
                      itemBuilder: (_, i) {
                        final item = ctrl.results[i];
                        return DishItemTile(dish: item);
                      },
                    );}
                  }),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
