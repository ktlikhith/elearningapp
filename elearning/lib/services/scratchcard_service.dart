import 'dart:convert';
import 'package:elearning/services/auth.dart';
import 'package:http/http.dart' as http;

class ScratchCard {
  final String scid;
  final int point;
  final String pointImage;
  final String scratchImage;

  ScratchCard({
    required this.scid,
    required this.point,
    required this.pointImage,
    required this.scratchImage,
  });

  factory ScratchCard.fromJson(Map<String, dynamic> json) {
    return ScratchCard(
      scid: json['scid']?.toString() ?? "", // Ensure it's a String, default to empty string
      point: int.tryParse(json['point']?.toString() ?? "0") ?? 0, // Convert to int safely
      pointImage: json['pointimage'] ?? "", // Default to empty string if null
      scratchImage: json['scratchimage'] ?? "", // Default to empty string if null
    );
  }
}

class ScratchCardService {
  static Future<List<ScratchCard>> fetchScratchCards(String token) async {
    try {
      final userInfo = await SiteConfigApiService.getUserId(token);
      final userId = userInfo['id'];

      final apiUrl = Uri.parse(
        '${Constants.baseUrl}/webservice/rest/server.php?'
        'moodlewsrestformat=json&wstoken=$token&'
        'wsfunction=local_reward_scratch_card&userid=$userId',
      );

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is List) {
          return responseData
              .map((cardData) => ScratchCard.fromJson(cardData))
              .toList();
        } else {
          return []; // Return empty list if data is not in expected format
        }
      } else {
        throw Exception('Failed to fetch scratch cards');
      }
    } catch (e) {
      throw Exception('Error fetching scratch cards: $e');
    }
  }
}
