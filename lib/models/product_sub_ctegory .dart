class ProductSubCategory {
  final int id;
  final String name;
  final int categoryId;
  final int status;
  ProductSubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.status,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['id'],
      name: json['name'].toString(),
      categoryId: json['category_id'],
      status: json['status'],
    );
  }
}
