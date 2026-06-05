class CategoryModel {
  final int categoryId;
  final String categoryText;

  CategoryModel({required this.categoryId, required this.categoryText});

  Map<String, dynamic> toMap() => {
        'category_id': categoryId,
        'category_text': categoryText,
      };
}
