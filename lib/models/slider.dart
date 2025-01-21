// class AppSlider {
//   late final String id;
//   late final String category;
//   late final String image_path;
//   late final String thumbnail;
//   late final String linked_category;
//   late final String linked_array;

//   AppSlider({
//     required this.id,
//     required this.category,
//     required this.image_path,
//     required this.thumbnail,
//     required this.linked_category,
//     required this.linked_array,
//   });
// }

class AppSlider {
  late final String id;
  late final String category;
  late final String image_path;
  late final String thumbnail;
  late final String linked_category;
  late final String linked_array;

  AppSlider({
    required this.id,
    required this.category,
    required this.image_path,
    required this.thumbnail,
    required this.linked_category,
    required this.linked_array,
  });

  // From JSON factory method to parse API response
  // factory AppSlider.fromJson(Map<String, dynamic> json) {
  //   return AppSlider(
  //     id: json['id'].toString(),
  //     category: json['category'],
  //     image_path: json['image_path'],
  //     thumbnail: json['thumbnail'],
  //     linked_category: json['linked_category'] ?? '',
  //     linked_array: json['linked_array'] ?? '',
  //   );
  // }
}
