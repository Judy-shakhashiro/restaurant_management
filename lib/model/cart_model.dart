



import 'package:get/get.dart';

class ShowCart {
  final bool status;
  final int statusCode;
  final String message;
  final Cart cart;

  ShowCart({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.cart,
  });

  factory ShowCart.fromJson(Map<String, dynamic> json) {
    return ShowCart(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] is int ? json['status_code'] as int : 0,
      message: json['message'] as String? ?? 'Unknown message',
      cart: Cart.fromJson(json['cart'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Cart {
  final int itemsCount;
  final double cartTotalPrice;
  final List<CartItem> items;

  Cart({
    required this.itemsCount,
    required this.cartTotalPrice,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
    
      itemsCount: json['items_count'] is int ? json['items_count'] as int : 0,
     
      cartTotalPrice: (json['cart_total_price'] as num?)?.toDouble() ?? 0.0,
   
      items: (json['items'] is List)
          ? (json['items'] as List<dynamic>)
              .map((e) => CartItem.fromJson(e as Map<String, dynamic>? ?? {}))
              .toList()
          : [],
    );
  }
}


class CartItem {
  final int id;
  final String name;
  final String description;
  final String image;
  final int isSimple;
  final int isRecommended;
  final String basePrice;
  final String extraPrice;
  final String totalPrice;
   RxInt quantity; 
  final CartItemAttributes selectedAttributes;

  CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.isSimple,
    required this.isRecommended,
    required this.basePrice,
    required this.extraPrice,
    required this.totalPrice,
    required int initialQuantity, 
    required this.selectedAttributes,
  }) : quantity = initialQuantity.obs; 

 factory CartItem.fromJson(Map<String, dynamic> json) {
  final attributesJson = json['selected_attributes'] ??
                         json['attributes'];

  return CartItem(
    id: json['id'] is int ? json['id'] as int : 0,
    name: json['name'] as String? ?? '',
    description: json['description'] as String? ?? '',
    image: json['image'] as String? ?? '',
    isSimple: json['is_simple'] is int ? json['is_simple'] as int : 0,
    isRecommended: json['is_recommended'] is int ? json['is_recommended'] as int : 0,
    basePrice: json['base_price'] as String? ?? '0.00',
    extraPrice: json['extra_price'] as String? ?? '0.00',
    totalPrice: json['total_price'] as String? ?? '0.00',
    initialQuantity: json['quantity'] is int ? json['quantity'] as int : 1,
    selectedAttributes: CartItemAttributes.fromJson(
      attributesJson as Map<String, dynamic>? ?? {},
    ),
  );
}

}

class CartItemAttributes {
  final List<BasicAttribute> basic;
  final Map<String, AdditionalAttributeValue>? additional;

  CartItemAttributes({
    required this.basic,
    this.additional,
  });

  factory CartItemAttributes.fromJson(Map<String, dynamic> json) {
    List<BasicAttribute> basicAttributes = [];
    // تحقق مما إذا كانت 'basic' موجودة وليست null وهي قائمة
    if (json['basic'] != null && json['basic'] is List) {
      basicAttributes = (json['basic'] as List<dynamic>)
          .map((e) => BasicAttribute.fromJson(e as Map<String, dynamic>? ?? {}))
          .toList();
    }

    Map<String, AdditionalAttributeValue>? additionalMap;

    if (json['additional'] != null && json['additional'] is Map) {
      additionalMap = (json['additional'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, AdditionalAttributeValue.fromJson(value as Map<String, dynamic>? ?? {})),
      );
    }

    return CartItemAttributes(
      basic: basicAttributes,
      additional: additionalMap,
    );
  }
}

class BasicAttribute {
  final String name;

  BasicAttribute({required this.name});

  factory BasicAttribute.fromJson(Map<String, dynamic> json) {
    return BasicAttribute(
      name: json['name'] as String? ?? '',
    );
  }
}

class AdditionalAttributeValue {
  final String name;

  AdditionalAttributeValue({required this.name});

  factory AdditionalAttributeValue.fromJson(Map<String, dynamic> json) {
    return AdditionalAttributeValue(
      name: json['name'] as String? ?? '',
    );
  }
}


class CartItemDetails {
  final bool status;
  final int statusCode;
  final String message;
  final DishDetails cartItem;

  CartItemDetails({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.cartItem,
  });

  factory CartItemDetails.fromJson(Map<String, dynamic> json) {
    return CartItemDetails(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] is int ? json['status_code'] as int : 0,
      message: json['message'] as String? ?? 'Unknown message',
      cartItem: DishDetails.fromJson(
          json['item'] as Map<String, dynamic>? ?? {}),
    );
  }
}
class DishDetails {
  final int id;
  final String name;
  final String description;
  final String image;
  final String price;


  DishDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
  });

  factory DishDetails.fromJson(Map<String, dynamic> json) {
    return DishDetails(
      id: json['id'] is int ? json['id'] as int : 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      price: json['price'] as String? ?? '0.00',
    );
  }
}

