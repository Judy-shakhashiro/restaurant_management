// dish_item.dart

import 'package:flutter/material.dart';
import '../../core/static/routes.dart';
import '../../model/dish.dart';

class DishItemTile extends StatelessWidget {
  final Dish dish;

  const DishItemTile({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fullUrl = '${Linkapi.backUrl}/images/${dish.image}';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: FadeInImage.assetNetwork(
                 image: 'fullUrl',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // loadingBuilder: (context, child, loadingProgress) {
                  //   if (loadingProgress == null) return child;
                  //   return Shimmer.fromColors(
                  //     baseColor: Colors.grey[300]!,
                  //     highlightColor: Colors.grey[100]!,
                  //     child: Container(
                  //       height: 200,
                  //       width: double.infinity,
                  //       color: Colors.white,
                  //     ),
                  //   );
                  // },
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/placeholder.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    );
                  },
                  placeholder: 'assets/placeholder.png',
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: dish.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withAlpha(220),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag.name,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dish.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(dish.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 4),
                Text(
                  '${dish.price} SP',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepOrange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                if (dish.isRecommended)
                  SizedBox(
                    width: 140,
                    child: _buildFlagIcon(Icons.star_border, 'Recommended'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper widget to show flags
Widget _buildFlagIcon(IconData icon, String label) {
  return Container(
    margin: EdgeInsets.only(right: 8),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.deepOrange[50],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.deepOrange),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
      ],
    ),
  );
}