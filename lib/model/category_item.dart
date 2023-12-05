

// ignore_for_file: constant_identifier_names

enum ECategoryType {
  food("Food"),
  transport("Transport"),
  beautyAndClothes("Beauty and clothes"),
  business("Business"),
  health("Health"),
  other("Other");

  const ECategoryType(this.text);
  final String text;
}

class CategoryItem {
  String? name;
  double? currentCount;
  double? totalCount;
  ECategoryType? type;
  DateTime? date;

  CategoryItem(
      {this.name,
      this.currentCount = 0.0,
      this.totalCount,
      this.type,
      this.date});
  factory CategoryItem.fromJson(Map<String, dynamic> parsedJson) {
    return CategoryItem(
        name: parsedJson['name'] ?? "",
        currentCount: parsedJson['currentCount'] ?? "",
        totalCount: parsedJson['totalCount'] ?? "",
        type: ECategoryType.values.byName(parsedJson['type']),
        date: DateTime.tryParse(parsedJson['date']));
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "currentCount": currentCount,
      "totalCount": totalCount,
      "type": type!.name,
      "date": date.toString()
    };
  }
}

// void _saveCategories(List<CategoryItem> categories) async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//   List<String> categoriesEncoded =
//       categories.map((person) => jsonEncode(person.toJson())).toList();
//   await sharedPreferences.setStringList('categories', categoriesEncoded);
// }

// Future<List<CategoryItem>> _getCategories(List<CategoryItem> persons) async {
//   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

//   final categories =
//       await sharedPreferences.setStringList('persons', persons);
//   return categories.map((category) => CategoryItem.fromJson(category)).toList();
// }

enum Day {
  MONDAY("Monday"),
  TUESDAY("Tuesday");

  const Day(this.text);
  final String text;
}
