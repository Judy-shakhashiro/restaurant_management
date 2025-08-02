
import '../model/dish.dart';
import '../model/favorite_model.dart';

abstract class ApiBase {
  Future<List<Tag>> fetchTags();
  Future<List<Dish>> fetchDishesByCategory(int categoryId,List<int> t);
}

