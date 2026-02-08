import 'package:doco_store/config/app_constants.dart';
import 'package:doco_store/model/api_response.dart';
import 'package:doco_store/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<ApiResponse> login({
    required String username,
    required String password,
  }) {
    return _apiService.request(
      url: AppConstants.BASE_URL + '/auth/login/',
      method: 'POST',
      body: {
        'username': username,
        'password': password,
      },
    );
  }

}