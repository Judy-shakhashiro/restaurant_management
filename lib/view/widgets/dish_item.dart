import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/static/config.dart';
import '../../model/dish.dart';
class DishItemTile extends StatefulWidget {
  final Dish dish;

  const DishItemTile({Key? key, required this.dish}) : super(key: key);

  @override
  State<DishItemTile> createState() => _DishItemTileState();
}

class _DishItemTileState extends State<DishItemTile> with SingleTickerProviderStateMixin {
  bool _imageLoaded = false;
  bool _imageFailed = false;
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _preloadImage();
  }

  void _preloadImage() {
    final image = Image.network(
      widget.dish.image.startsWith('http')
          ? widget.dish.image
          : '${Linkapi.backUrl}/images/${widget.dish.image}',
    ).image;

    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (info, _) {
          if (mounted) {
            setState(() {
              _imageLoaded = true;
              _controller.forward();
            });

            // Notify controller only once per dish
           // final c = Get.put(MenuController());
          }
        },
        onError: (_, __) {
          if (mounted) {
            setState(() {
              _imageLoaded = true;
              _imageFailed = true;
              _controller.forward();
            });

          //  final c = Get.find<MyMenuController>();

          }
        },
      ),
    );
  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    final fullUrl = dish.image.startsWith('http')
        ? dish.image
        : '${Linkapi.backUrl}/images/${dish.image}';

    if (!_imageLoaded) {
      // Show shimmer while loading
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    // Fade + slide in when ready
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
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
                    child: _imageFailed
                        ? Image.asset(
                      'assets/images/image_error.png',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      fullUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
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
                            color: Colors.orange.withAlpha(220),
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
                        color: Colors.orange[800],
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
        ),
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
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.orange),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.orange)),
      ],
    ),
  );
}
