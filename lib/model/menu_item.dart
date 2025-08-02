import 'dish.dart';

abstract class MenuItem {}

class CategoryHeaderItem extends MenuItem {
  final String title;
  final int categoryId;
  CategoryHeaderItem({required this.title, required this.categoryId});
}

class DishItem extends MenuItem {
  final Dish dish;
  final int categoryId;
  DishItem({required this.dish, required this.categoryId});
}
class LoadingItem extends MenuItem {
  LoadingItem();

}
class NoItemsFoundItem extends MenuItem {}
