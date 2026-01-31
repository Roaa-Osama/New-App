import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'image_model.dart';

class ImageApiService {
  static const _baseUrl = 'https://api.pexels.com/v1/curated';

  final String _apiKey = dotenv.env['PEXELS_API_KEY']!;

  Future<List<ImageModel>> fetchImages({
    required int page,
    int perPage = 10,
  }) async {
    final uri = Uri.parse('$_baseUrl?page=$page&per_page=$perPage');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List photos = data['photos'];

      return photos.map((e) => ImageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
    }
  }
}
