class CategoryMenu {
  final int id;
  final String name;
  final String image;
  final int productsCount;

  CategoryMenu({
    this.id=0,
     this.name='',
     this.image='',
     this.productsCount=0,
  });


  factory CategoryMenu.fromJson(Map<String, dynamic> json) {
    return CategoryMenu(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      productsCount: json['products_count'],
    );
  }
}

