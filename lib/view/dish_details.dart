import 'package:flutter/material.dart';
import 'package:flutter_application_restaurant/controller/cart_controller.dart';
import 'package:flutter_application_restaurant/core/static/global_lotti.dart';
import 'package:flutter_application_restaurant/core/static/routes.dart';
import 'package:get/get.dart';

import '../controller/favourite_controller.dart';
import '../controller/dish_details_controller.dart';
import '../model/dish_details_model.dart';
class DishDetailsPage extends StatefulWidget {
  final int productId;
  const DishDetailsPage({super.key, required this.productId});

  @override
  State<DishDetailsPage> createState() => _DetailsState();
}

class _DetailsState extends State<DishDetailsPage> with TickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();
 

  final GlobalKey _sizeSectionKey = GlobalKey();
  final GlobalKey _piecesNumberSectionKey = GlobalKey();
  final GlobalKey _addonsSectionKey = GlobalKey();
  final GlobalKey _saucesSectionKey = GlobalKey();

  // Get your controller instance
   late final DishDetailsController controller;
// DishDetailsController controller =Get.put(DishDetailsController(productId: productId));
  @override
  void initState() {
    super.initState();
   controller = Get.put(DishDetailsController(productId: widget.productId));
    ever(controller.dishDetails, (_) {
      _updateTabController();
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateTabController() {
    if (!mounted) return; // Ensure the widget is still mounted

    final dishDetails = controller.dishDetails.value;
    if (dishDetails == null) {
      _tabController?.removeListener(_handleTabSelection);
      _tabController?.dispose();
      _tabController = null;
      if (mounted) setState(() {}); // Rebuild to clear tabs if details are gone
      return;
    }

    final List<String> tabsTitles = [];
    if (dishDetails.product.attributes.basic?.size != null &&
        dishDetails.product.attributes.basic!.size!.isNotEmpty) {
      tabsTitles.add('Size');
    }
    if (dishDetails.product.attributes.basic?.piecesNumber != null &&
        dishDetails.product.attributes.basic!.piecesNumber!.isNotEmpty) {
      tabsTitles.add('Pieces');
    }
    if (dishDetails.product.attributes.additional?.addons != null &&
        dishDetails.product.attributes.additional!.addons!.isNotEmpty) {
      tabsTitles.add('Addons');
    }
    if (dishDetails.product.attributes.additional?.sauce != null &&
        dishDetails.product.attributes.additional!.sauce!.isNotEmpty) {
      tabsTitles.add('Sauces');
    }

    if (_tabController == null || _tabController!.length != tabsTitles.length) {
      _tabController?.removeListener(_handleTabSelection);
      _tabController?.dispose();
      _tabController = TabController(length: tabsTitles.length, vsync: this);
      _tabController!.addListener(_handleTabSelection);
    }
    if (mounted) setState(() {}); 
  }


  void _handleTabSelection() {
    if (_tabController != null && _tabController!.indexIsChanging) {
      GlobalKey? targetKey;
      int currentTabIndex = 0;
      final dishDetails = controller.dishDetails.value;

      if (dishDetails == null) return;

      if (dishDetails.product.attributes.basic?.size != null &&
          dishDetails.product.attributes.basic!.size!.isNotEmpty) {
        if (_tabController!.index == currentTabIndex) targetKey = _sizeSectionKey;
        currentTabIndex++;
      }
      if (dishDetails.product.attributes.basic?.piecesNumber != null &&
          dishDetails.product.attributes.basic!.piecesNumber!.isNotEmpty) {
        if (_tabController!.index == currentTabIndex) targetKey = _piecesNumberSectionKey;
        currentTabIndex++;
      }
      if (dishDetails.product.attributes.additional?.addons != null &&
          dishDetails.product.attributes.additional!.addons!.isNotEmpty) {
        if (_tabController!.index == currentTabIndex) targetKey = _addonsSectionKey;
        currentTabIndex++;
      }
      if (dishDetails.product.attributes.additional?.sauce != null &&
          dishDetails.product.attributes.additional!.sauce!.isNotEmpty) {
        if (_tabController!.index == currentTabIndex) targetKey = _saucesSectionKey;
        currentTabIndex++;
      }

      if (targetKey != null && targetKey.currentContext != null) {
        Scrollable.ensureVisible(
          targetKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: 0.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     final WishlistController cont = Get.find();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(child: MyLottiLoading()),
        );
      }

      if (controller.errorMessage.value != null) {
        return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 60),
                      const SizedBox(height: 20),
                      const Text(
                        'Please try again.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.red)
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                   onPressed: () {
                      controller.fetchDishDetails();
                        }, // Retry fetch
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                  
                ),
                    ],
                  ),
                );
      }

      final dishDetails = controller.dishDetails.value;
      if (dishDetails == null || _tabController == null) {
        return const Scaffold(
          body: MyLottiNodata()
        );
      }

      final product = dishDetails.product;
      final basicAttributes = product.attributes.basic;
      final additionalAttributes = product.attributes.additional;

      final List<Widget> tabs = [];
      if (basicAttributes?.size != null && basicAttributes!.size!.isNotEmpty) {
        tabs.add(const Tab(text: 'Size'));
      }
      if (basicAttributes?.piecesNumber != null && basicAttributes!.piecesNumber!.isNotEmpty) {
        tabs.add(const Tab(text: 'Pieces'));
      }
      if (additionalAttributes?.addons != null && additionalAttributes!.addons!.isNotEmpty) {
        tabs.add(const Tab(text: 'Addons'));
      }
      if (additionalAttributes?.sauce != null && additionalAttributes!.sauce!.isNotEmpty) {
        tabs.add(const Tab(text: 'Sauces'));
      }

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title:const Text('Details',style: TextStyle(fontSize: 22),),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: controller.resetSelections, 
              child: const Text(
                'RESET',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const SizedBox(width: 8),
          ],
          bottom: TabBar(
            controller: _tabController!,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.deepOrange,
            tabs: tabs,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                        child: product.image.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(15), 
                                child: Image.network(
                                  '${Linkapi.bacUrlImage}${product.image}',
                                  height: 160,
                                  width: 400, 
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.image_outlined,
                                    size: 120,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.image_not_supported,
                                size: 200,
                                color: Colors.grey,
                              ),
                      ),
                      Positioned(
                  child: Obx(() {
                    bool isFav = cont.isFavorite(dishDetails.product.id);
                    return CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () async {
                          await cont.toggleFavorite(dishDetails.product.id);
                        },
                      ),
                    );
                  }),
                ),
                                      ]
                    )
,
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                        Text(
                      '${product.price}  EGP', 
                      style:const  TextStyle(fontSize: 22, color: Colors.deepOrange),
                    ),
                      ],
                    ),
                  const  Padding(
                      padding:  EdgeInsets.only(right: 200),
                      child: Divider(thickness: 2,color: Colors.deepOrange,),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  //  const SizedBox(height: 16),
                    
                    const SizedBox(height: 24),

                    if (basicAttributes?.size != null && basicAttributes!.size!.isNotEmpty) ...[
                      _buildSectionHeader(' Choose Size :', _sizeSectionKey),
                      const SizedBox(height: 16),
                      Obx(() => Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: basicAttributes.size!
                            .map((item) => _buildSizeOption(item, controller))
                            .toList(),
                      )),
                      const SizedBox(height: 24),
                    ],

                    if (basicAttributes?.piecesNumber != null && basicAttributes!.piecesNumber!.isNotEmpty) ...[
                      _buildSectionHeader(' Choose Pieces Number :', _piecesNumberSectionKey),
                      const SizedBox(height: 16),
                      Obx(() => Column( // Use Obx here
                        children: basicAttributes.piecesNumber!
                            .map((item) => _buildPiecesNumberOption(item, controller))
                            .toList(),
                      )),
                      const SizedBox(height: 24),
                    ],

                    if (additionalAttributes?.addons != null && additionalAttributes!.addons!.isNotEmpty) ...[
                      _buildSectionHeader(' Choose Addons :', _addonsSectionKey),
                      const SizedBox(height: 16),
                      Obx(() => Column( // Use Obx here
                        children: additionalAttributes.addons!
                            .map((item) => _buildAddonItem(item, controller))
                            .toList(),
                      )),
                      const SizedBox(height: 24),
                    ],

                    if (additionalAttributes?.sauce != null && additionalAttributes!.sauce!.isNotEmpty) ...[
                      _buildSectionHeader(' Choose Sauces :', _saucesSectionKey),
                      const SizedBox(height: 16),
                      Obx(() => Column( // Use Obx here
                        children: additionalAttributes.sauce!
                            .map((item) => _buildSauceItem(item, controller))
                            .toList(),
                      )),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              ),
            ),
            _buildAddToCartBar(controller),
          ],
        ),
      );
    });
  }

  Widget _buildSectionHeader(String title, [GlobalKey? key]) {
    return Align(
      key: key,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
         const Icon(Icons.arrow_forward,color: Colors.black,),
          Text(
            title,
            style:const  TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color:  Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(AttributeItem item, DishDetailsController controller) {
    bool isSelected = controller.selectedSize.value?.id == item.id;
    return GestureDetector(
      onTap: () => controller.updateSelectedSize(item),
      child: Card(
        color: isSelected ? Colors.red[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? Colors.deepOrange : Colors.black38,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Icon(Icons.local_dining_outlined, size: 45, color: Colors.deepOrange),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.deepOrange : Colors.black,
                  fontSize: 17
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${double.parse(item.price).toStringAsFixed(2)}EGP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.deepOrange : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildPiecesNumberOption(AttributeItem item, DishDetailsController controller) {
  bool isSelected = controller.selectedPiecesNumber.value?.id == item.id;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
    child: GestureDetector(
      onTap: () => controller.updateSelectedPiecesNumber(item),
      child: Stack(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.deepOrange : Colors.grey[300]!,
                  width: 3,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.layers,
                    color: isSelected ? Colors.deepOrange : Colors.black,
                    size: 36,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isSelected ? Colors.deepOrange : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '+ ${double.parse(item.price).toStringAsFixed(2)} EGP',
                          style: const TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Radio<AttributeItem>(
                    value: item,
                    groupValue: controller.selectedPiecesNumber.value,
                    onChanged: controller.updateSelectedPiecesNumber,
                    activeColor: Colors.deepOrange,
                  ),
                ],
              ),
            ),
          ),

          if (item.isDefault)
            Positioned(
              top: 0,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Default",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _buildAddonItem(AttributeItem item, DishDetailsController controller) {
  bool isSelected = controller.selectedAddons.any((selectedItem) => selectedItem.id == item.id);
  bool isDefault = item.isDefault;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Stack(
      children: [
        Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepOrange.shade50 : Colors.white, 
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                width: 3,
                color: isSelected ? Colors.deepOrange : Colors.grey[300]!, 
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const SizedBox(width: 60, height: 60, child: Icon(Icons.fastfood_sharp, color: Colors.black, size: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isSelected ? Colors.deepOrange : Colors.black, 
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              controller.toggleAddonSelection(item, value ?? false);
                            },
                            activeColor: Colors.deepOrange,
                          ),
                          Text(
                            'Extra (+ ${double.parse(item.price).toStringAsFixed(2)}EGP)',
                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
                  onPressed: isSelected ? () => controller.toggleAddonSelection(item, false) : null,
                ),
              ],
            ),
          ),
        ),
        if (isDefault)
          Positioned(
            top: 0,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Default",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

  // Widget _buildDefaultBadge() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //     decoration: BoxDecoration(
  //       color: Colors.orange[100],
  //       borderRadius: BorderRadius.circular(5),
  //     ),
  //     child: Text(
  //       'DEFAULT',
  //       style: TextStyle(color: Colors.orange[800], fontSize: 10, fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }

  Widget _buildSauceItem(AttributeItem item, DishDetailsController controller) {
  bool isSelected = controller.selectedSauces.any((selectedItem) => selectedItem.id == item.id);
  bool isDefault = item.isDefault;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Stack(
      children: [
        Card(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepOrange.shade50 : Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                width: 3,
                color: isSelected ? Colors.deepOrange : Colors.grey[300]!,
              ),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const SizedBox(width: 60, height: 60, child: Icon(Icons.liquor, color: Colors.black, size: 40)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isSelected ? Colors.deepOrange : Colors.black,
                        ),
                      ),
                      Text(
                        '+ ${double.parse(item.price).toStringAsFixed(2)}EGP',
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                isSelected
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.deepOrange, size: 30),
                        onPressed: () => controller.toggleSauceSelection(item, false),
                      )
                    : ElevatedButton(
                        onPressed: () => controller.toggleSauceSelection(item, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize:const Size(70, 36),
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text('Add', style: TextStyle(fontSize: 15)),
                      ),
              ],
            ),
          ),
        ),
        if (isDefault)
          Positioned(
            top: 0,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "Default",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}








  Widget _buildAddToCartBar(DishDetailsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                '${controller.totalPrice.value.toStringAsFixed(2)}EGP', 
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
              const Text(
                'inclusive of taxes',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ],
          ),
         ElevatedButton.icon(
            onPressed: () async { 
              final cartController = Get.put(CartController());
              await controller.addToCart(); 
              cartController.fetchCartItems();
            },
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            label: const Text(
              'ADD TO CART',
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}