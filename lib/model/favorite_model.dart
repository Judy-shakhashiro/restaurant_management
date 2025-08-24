class WishlistResponse {
  final bool status;
  final int statusCode;
  final String message;
  final List<ProductFavorite> products; // تم التعديل هنا ليصبح قائمة

  WishlistResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.products,
  });

  factory WishlistResponse.fromJson(Map<String, dynamic> json) {
    return WishlistResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductFavorite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'status_code': statusCode,
        'message': message,
        'products': products.map((e) => e.toJson()).toList(),
      };
}

class ProductFavorite {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final bool isSimple;
  final bool isRecommended;
  final int categoryId;
  final List<Tag> tags;

  ProductFavorite({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isFavorite,
    required this.isSimple,
    required this.isRecommended,
    required this.categoryId,
    required this.tags,
  });

  factory ProductFavorite.fromJson(Map<String, dynamic> json) {
    return ProductFavorite(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image'],
      isFavorite: json['is_favorite'],
      isSimple: json['is_simple'],
      isRecommended: json['is_recommended'],
      categoryId: json['category_id'],
      tags: (json['tags'] as List)
          .map((e) => Tag.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price.toString(),
        'image': image,
        'is_favorite': isFavorite,
        'is_simple': isSimple,
        'is_recommended': isRecommended,
        'category_id': categoryId,
        'tags': tags.map((e) => e.toJson()).toList(),
      };
}

class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}