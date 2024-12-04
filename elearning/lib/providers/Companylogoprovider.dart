import 'package:elearning/services/auth.dart';
import 'package:elearning/services/tanentlogo_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantLogoProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _tenantData;

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, dynamic>? get tenantData => _tenantData;

  Future<void> fetchTenantUserData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
      final data = await TanentLogo.fetchTenantUserData(token!);
      _tenantData = data;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
