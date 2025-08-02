class HomeModel {
  final bool status;
  final int statusCode;
  final String message;
  final ProductData data;

  HomeModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final List<ProductHome> mostOrderedProducts;
  final List<ProductHome> latestProducts;
  final List<ProductHome> recommendedProducts;

  ProductData({
    required this.mostOrderedProducts,
    required this.latestProducts,
    required this.recommendedProducts,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      mostOrderedProducts: List<ProductHome>.from(
          json['most_ordered_products'].map((item) => ProductHome.fromJson(item))),
      latestProducts: List<ProductHome>.from(
          json['latest_products'].map((item) => ProductHome.fromJson(item))),
      recommendedProducts: List<ProductHome>.from(
          json['recommended_products'].map((item) => ProductHome.fromJson(item))),
    );
  }
}

class ProductHome {
  final int id;
  final String name;
  final String description;
  final String price;
  final String image;
  final bool isRecommended;
  final int categoryId;

  ProductHome({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isRecommended,
    required this.categoryId,
  });

  factory ProductHome.fromJson(Map<String, dynamic> json) {
    return ProductHome(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isRecommended: json['is_recommended'],
      categoryId: json['category_id'],
    );
  }
}
