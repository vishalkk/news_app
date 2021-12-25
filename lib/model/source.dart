import "dart:convert";

SourceModel apiModelFromJson(String str) =>
    SourceModel.fromJson(json.decode(str));

class SourceModel {
  final String id;
  final String name;

  final String description;
  final String url;
  final String category;
  final String country;
  final String language;

 
  SourceModel._({
    required this.id,
    required this.name,
    required this.description,
    required this.language,
    required this.country,
    required this.category,
    required this.url,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel._(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        url: json["url"] ?? "",
        category: json["category"] ?? "",
        country: json["country"] ?? "",
        language: json["language"] ?? "",
      );
}
