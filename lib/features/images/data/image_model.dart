class ImageModel {
  final int id;
  final String preview;
  final String photographer;

  ImageModel({
    required this.id,
    required this.preview,
    required this.photographer,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      preview: json['src']['medium'],
      photographer: json['photographer'],
    );
  }
}