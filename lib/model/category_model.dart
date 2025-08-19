class CategoriesResponse {
  final bool status;
  final int statusCode;
  final String message;
  final List<CategoryR> categories;

  CategoriesResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      categories: List<CategoryR>.from(
        json['categories'].map((cat) => CategoryR.fromJson(cat)),
      ),
    );
  }
}

class CategoryR {
  final int id;
  final String name;
  final String image;
  final int productsCount;

  CategoryR({
    this.id=0,
    this.name='',
    this.image='',
    this.productsCount=0,
  });

  factory CategoryR.fromJson(Map<String, dynamic> json) {
    return CategoryR(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      productsCount: json['products_count'],
    );
  }
}




