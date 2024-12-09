import 'package:elearning/services/homepage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider with ChangeNotifier {
  List<EventData> _Eventdata = [];
 
  bool _isLoading = false;
  String? _error;

  List<EventData> get Eventdata => _Eventdata;
 
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvent() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
       SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
     if (token == null || token.isEmpty) {
        throw Exception('Token not found. Please log in again.');
      }

      HomePageData homePageData = await HomePageService.fetchHomePageData(token);
      _Eventdata = homePageData.evenData;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
