

import 'favorite_model.dart';

class Dish {
  final int id;
  final String name;
  final String description;
  final String price;
  final String image;
  final bool isSimple;
  final bool isRecommended;
  final int categoryId;
  final List<Tag> tags;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isSimple,
    required this.isRecommended,
    required this.categoryId,
    required this.tags,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isSimple: json['is_simple'],
      isRecommended: json['is_recommended'],
      categoryId: json['category_id'],
      tags: (json['tags'] as List)
          .map((tag) => Tag.fromJson(tag))
          .toList(),

    );
  }
}

