import 'package:ticketa/core/constants/api_constants.dart';
import 'package:ticketa/core/network/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _apiService.post(
      ApiConstants.loginEndpoint,
      data: {'email': email, 'password': password},
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<Map<String, dynamic>> register(String email, String password, String dateOfBirth) async {
    final response = await _apiService.post(
      ApiConstants.registerEndpoint,
      data: {'email': email, 'password': password, 'dateOfBirth': dateOfBirth},
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<Map<String, dynamic>> confirmEmail(String email, String code) async {
    final response = await _apiService.post(
      ApiConstants.confirmEmailEndpoint,
      data: {'email': email, 'code': code},
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<Map<String, dynamic>> resendConfirmation(String email) async {
    final response = await _apiService.post(
      ApiConstants.resendConfirmationEndpoint,
      data: {'email': email},
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<void> logout() async {
    await _apiService.post(ApiConstants.logoutEndpoint);
  }

  Future<Map<String, dynamic>> refresh() async {
    final response = await _apiService.post(ApiConstants.refreshEndpoint);
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await _apiService.post(
      ApiConstants.forgotPasswordEndpoint,
      data: {'email': email},
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }
}
