

class DishDetails {
  final bool status;
  final int statusCode;
  final String message;
  final Product product;

  DishDetails({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.product,
  });

  factory DishDetails.fromJson(Map<String, dynamic> json) {
    return DishDetails(
      status: json['status'],
      statusCode: json['status_code'],
      message: json['message'],
      product: Product.fromJson(json['product']),
    );
  }

}

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String image;
  final bool isSimple;
  final bool isRecommended;
  final Attributes attributes;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isSimple,
    required this.isRecommended,
    required this.attributes,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      isSimple: json['is_simple'],
      isRecommended: json['is_recommended'],
      //category: Category.fromJson(json['category']),
      attributes: Attributes.fromJson(json['attributes']),
    );
  }

}

class Category {
  final int id;
  final String name;
  final String image;

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
  };
}

class Attributes {
  BasicAttributes? basic;
  AdditionalAttributes? additional;

  Attributes({
    this.basic,
    this.additional,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) {
    return Attributes(
      basic: json['basic']!=null? BasicAttributes.fromJson(json['basic']):null,
      additional: json['additional']!=null? AdditionalAttributes.fromJson(json['additional']):null,
    );
  }
}

class BasicAttributes {
  List<AttributeItem>? size;
   List<AttributeItem>? piecesNumber;

  BasicAttributes({
      this.size,
      this.piecesNumber,
  });

  factory BasicAttributes.fromJson(Map<String, dynamic> json) {
    return BasicAttributes(
      size: json['size']!=null?List<AttributeItem>.from(
        json['size'].map((x) => AttributeItem.fromJson(x)),
      ):null,
      piecesNumber: json['pieces number']!=null?List<AttributeItem>.from(
        json['pieces number'].map((x) => AttributeItem.fromJson(x)),
      ):null,
    );
  }

}

class AdditionalAttributes {
   List<AttributeItem>? sauce;
   List<AttributeItem>? addons;

  AdditionalAttributes({
     this.sauce,
     this.addons,
  });
  factory AdditionalAttributes.fromJson(Map<String, dynamic> json) {
    return AdditionalAttributes(
      sauce: json['sauce']!=null? List<AttributeItem>.from(
        json['sauce'].map((x) => AttributeItem.fromJson(x)),
      ):null,
      addons:json['addons']!=null?  List<AttributeItem>.from(
        json['addons'].map((x) => AttributeItem.fromJson(x)),
      ):null,
    );
  }

}

class AttributeItem {
  final int id;
  final String name;
  final String price;
  final bool isDefault;

  AttributeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isDefault,
  });

  factory AttributeItem.fromJson(Map<String, dynamic> json) {
    return AttributeItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'is_default': isDefault,
  };
}