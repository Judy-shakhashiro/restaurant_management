class CartDetails {
  final bool status;
  final int statusCode;
  final String message;
  final CartItemDetails? item;

  CartDetails({
    required this.status,
    required this.statusCode,
    required this.message,
    this.item,
  });

  factory CartDetails.fromJson(Map<String, dynamic> json) {
    return CartDetails(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] is int ? json['status_code'] as int : 0,
      message: json['message'] as String? ?? 'Unknown message',
      item: json['item'] != null
          ? CartItemDetails.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartItemDetails {
  final int id;
  final String name;
  final String description;
  final String image;
  final int isSimple;
  final int quantity;
  final String price;
  final CartAttributes? attributes;

  CartItemDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.isSimple,
    required this.quantity,
    required this.price,
    this.attributes,
  });

  factory CartItemDetails.fromJson(Map<String, dynamic> json) {
    return CartItemDetails(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isSimple: json['is_simple'] is int ? json['is_simple'] as int : 0,
      quantity: json['quantity'] is int ? json['quantity'] as int : 0,
      price: json['price'] as String? ?? '0.0',
      attributes: json['attributes'] != null
          ? CartAttributes.fromJson(json['attributes'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartAttributes {
  final BasicAttributes? basic;
  final AdditionalAttributes? additional;

  CartAttributes({this.basic, this.additional});

  factory CartAttributes.fromJson(Map<String, dynamic> json) {
    return CartAttributes(
      basic: json['basic'] != null
          ? BasicAttributes.fromJson(json['basic'] as Map<String, dynamic>)
          : null,
      additional: json['additional'] != null
          ? AdditionalAttributes.fromJson(json['additional'] as Map<String, dynamic>)
          : null,
    );
  }
}


class BasicAttributes {
  final List<AttributeItem>? size;
  final List<AttributeItem>? piecesNumber; 

  BasicAttributes({this.size, this.piecesNumber});

  factory BasicAttributes.fromJson(Map<String, dynamic> json) {
    return BasicAttributes(
      size: (json['size'] as List<dynamic>?)
          ?.map((e) => AttributeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      // ✅ تم تعديل اسم المفتاح هنا
      piecesNumber: (json['pieces number'] as List<dynamic>?)
          ?.map((e) => AttributeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AdditionalAttributes {
  final List<AttributeItem>? sauce;
  final List<AttributeItem>? addons;

  AdditionalAttributes({this.sauce, this.addons});

  factory AdditionalAttributes.fromJson(Map<String, dynamic> json) {
    return AdditionalAttributes(
      sauce: (json['sauce'] as List<dynamic>?)
          ?.map((e) => AttributeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      addons: (json['addons'] as List<dynamic>?)
          ?.map((e) => AttributeItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}


class AttributeItem {
  final int id;
  final String name;
  final String price;
  final bool isDefault;
  bool isSelected; // تم إزالة final

  AttributeItem({
    required this.id,
    required this.name,
    required this.price,
    required this.isDefault,
    required this.isSelected ,
  });

  factory AttributeItem.fromJson(Map<String, dynamic> json) {
    return AttributeItem(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '0.0',
      isDefault: json['is_default'] as bool? ?? false,
      isSelected: json['is_selected'] as bool? ?? false,
    );
  }
}