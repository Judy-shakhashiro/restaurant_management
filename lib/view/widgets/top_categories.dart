import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_application_restaurant/controller/home_controller.dart';
import 'package:get/get.dart';

Widget buildCategoryRow(BuildContext context,HomeController controller) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      SizedBox(
        height: 120,
        width: 0.8*MediaQuery.of(context).size.width,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          itemCount: controller.deliveryCategories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 1),
          itemBuilder: (context, index) {
            final category = controller.deliveryCategories[index];
            return Obx(() {
              final isSelected =
                  selectedDeliveryIndex.value == index;
              return Animate(
                effects: const [
                  SlideEffect(
                    begin: Offset(0, 0.4),
                    end: Offset(0, 0),
                    duration: Duration(milliseconds: 600),
                    curve: Curves.easeOut,
                  ),
                  FadeEffect(duration: Duration(milliseconds: 600))
                ],
                delay: Duration(milliseconds: index * 80),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () {
                      controller.selectDeliveryCategory(index);
                      Get.to(controller.deliveryCategories[index]['page']);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                            boxShadow: [
                              BoxShadow(
                                color: isSelected ? Colors.deepOrange.withOpacity(0.6) : Colors.grey.shade300,
                                blurRadius: isSelected ? 6 : 4,
                                offset: const Offset(2, 4),
                              ),
                            ],
                            border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                          ),
                          child: Icon(
                            category['icon'],
                            color: Colors.deepOrange,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category['title'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.deepOrange : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    ],
  );
}