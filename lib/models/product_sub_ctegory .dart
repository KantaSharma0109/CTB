class SubCategory {
  final int id;
  final String name;
  final int categoryId;
  final int status;

  SubCategory({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.status,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      status: json['status'],
    );
  }
}
