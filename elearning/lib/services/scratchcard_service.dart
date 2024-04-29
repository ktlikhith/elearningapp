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
      scid: json['scid'],
      point: int.parse(json['point']),
      pointImage: json['pointimage'],
      scratchImage: json['scratchimage'],
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
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((cardData) => ScratchCard.fromJson(cardData)).toList();
      } else {
        throw Exception('Failed to fetch scratch cards');
      }
    } catch (e) {
      throw Exception('Error fetching scratch cards: $e');
    }
  }
}

