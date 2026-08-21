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

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String dateOfBirth,
    String firstName,
    String lastName,
  ) async {
    final response = await _apiService.post(
      ApiConstants.registerEndpoint,
      data: {
        'email': email,
        'password': password,
        'dateOfBirth': dateOfBirth,
        'firstName': firstName,
        'lastName': lastName,
      },
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

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiService.get(ApiConstants.profileEndpoint);
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String theme,
  }) async {
    final response = await _apiService.put(
      ApiConstants.profileEndpoint,
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'theme': theme,
      },
    );
    return response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : {};
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await _apiService.put(
      ApiConstants.profilePasswordEndpoint,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': confirmNewPassword,
      },
    );
  }
}
