import 'dish_details_mode.dart';

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
      status: json['status'] as bool,
      statusCode: json['status_code'] as int,
      message: json['message'] as String,
      cartItem: DishDetails.fromJson(json['item'] as Map<String, dynamic>),
    );
  }
}