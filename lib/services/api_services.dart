import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// API Response wrapper
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String message, {int? statusCode, Map<String, dynamic>? errors}) {
    return ApiResponse(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}

// User model
class User {
  final int id;
  final String email;
  final String fullName;
  final String phone;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
    };
  }
}

// Token model
class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }
}

// Main API Service
class ApiService {
  // TODO: Replace with your actual Django server URL
  static const String _baseUrl = 'http://127.0.0.1:8000/api'; // For local development
  // static const String _baseUrl = 'https://your-domain.com/api'; // For production

  static const Duration _timeout = Duration(seconds: 30);

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';

  // Get headers with authentication
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final accessToken = await _getAccessToken();
      if (accessToken != null) {
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    return headers;
  }

  // Get access token from storage
  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Get refresh token from storage
  Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // Save tokens to storage
  Future<void> _saveTokens(AuthTokens tokens) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, tokens.accessToken);
    await prefs.setString(_refreshTokenKey, tokens.refreshToken);
  }

  // Save user data to storage
  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, json.encode(user.toJson()));
    await prefs.setString('user_role', user.role);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_name', user.fullName);
    await prefs.setInt('user_id', user.id);
  }

  // Clear all stored data
  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userDataKey);
    await prefs.remove('user_role');
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    await prefs.remove('user_id');
    await prefs.remove('remember_me');
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_userDataKey);
    if (userDataString != null) {
      final userData = json.decode(userDataString);
      return User.fromJson(userData);
    }
    return null;
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final accessToken = await _getAccessToken();
    final refreshToken = await _getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  // Refresh access token
  Future<bool> _refreshAccessToken() async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse('$_baseUrl/users/token/refresh/'),
        headers: await _getHeaders(includeAuth: false),
        body: json.encode({'refresh': refreshToken}),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_accessTokenKey, data['access']);
        return true;
      } else {
        // Refresh token is invalid, clear all data
        await _clearStoredData();
        return false;
      }
    } catch (e) {
      print('Error refreshing token: $e');
      return false;
    }
  }

  // Generic HTTP request method with automatic token refresh
  Future<ApiResponse<T>> _makeRequest<T>(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
        Map<String, String>? queryParams,
        T Function(dynamic)? fromJson,
        bool includeAuth = true,
        bool retryOnUnauthorized = true,
      }) async {
    try {
      // Build URL
      Uri url = Uri.parse('$_baseUrl$endpoint');
      if (queryParams != null) {
        url = url.replace(queryParameters: queryParams);
      }

      // Prepare headers
      final headers = await _getHeaders(includeAuth: includeAuth);

      // Make request
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers).timeout(_timeout);
          break;
        case 'POST':
          response = await http.post(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          ).timeout(_timeout);
          break;
        case 'PUT':
          response = await http.put(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          ).timeout(_timeout);
          break;
        case 'PATCH':
          response = await http.patch(
            url,
            headers: headers,
            body: body != null ? json.encode(body) : null,
          ).timeout(_timeout);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers).timeout(_timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Handle unauthorized response with token refresh
      if (response.statusCode == 401 && includeAuth && retryOnUnauthorized) {
        final refreshed = await _refreshAccessToken();
        if (refreshed) {
          // Retry the request with new token
          return await _makeRequest<T>(
            method,
            endpoint,
            body: body,
            queryParams: queryParams,
            fromJson: fromJson,
            includeAuth: includeAuth,
            retryOnUnauthorized: false, // Prevent infinite retry
          );
        } else {
          // Token refresh failed, clear stored data
          await _clearStoredData();
          return ApiResponse.error('Session expired. Please login again.', statusCode: 401);
        }
      }

      // Parse response
      return _parseResponse<T>(response, fromJson);

    } on SocketException catch (e) {
      return ApiResponse.error('Network error. Please check your connection.', statusCode: 0);
    } on TimeoutException catch (e) {
      return ApiResponse.error('Request timeout. Please try again.', statusCode: 0);
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e', statusCode: 0);
    }
  }

  // Parse HTTP response
  ApiResponse<T> _parseResponse<T>(http.Response response, T Function(dynamic)? fromJson) {
    try {
      final statusCode = response.statusCode;

      if (statusCode >= 200 && statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse.success(null as T, statusCode: statusCode);
        }

        final responseData = json.decode(response.body);

        if (fromJson != null) {
          final data = fromJson(responseData);
          return ApiResponse.success(data, statusCode: statusCode);
        } else {
          return ApiResponse.success(responseData as T, statusCode: statusCode);
        }
      } else {
        // Handle error responses
        String errorMessage = 'Request failed';
        Map<String, dynamic>? errors;

        if (response.body.isNotEmpty) {
          try {
            final errorData = json.decode(response.body);

            if (errorData is Map<String, dynamic>) {
              errors = errorData;

              // Handle different error response formats
              if (errorData.containsKey('detail')) {
                errorMessage = errorData['detail'];
              } else if (errorData.containsKey('non_field_errors')) {
                if (errorData['non_field_errors'] is List && errorData['non_field_errors'].isNotEmpty) {
                  errorMessage = errorData['non_field_errors'][0];
                }
              } else if (errorData.containsKey('message')) {
                errorMessage = errorData['message'];
              } else if (errorData.containsKey('error')) {
                errorMessage = errorData['error'];
              } else {
                // Extract first error message from field errors
                for (var key in errorData.keys) {
                  var value = errorData[key];
                  if (value is String) {
                    errorMessage = value;
                    break;
                  } else if (value is List && value.isNotEmpty) {
                    errorMessage = value[0].toString();
                    break;
                  }
                }
              }
            }
          } catch (e) {
            errorMessage = response.body;
          }
        }

        return ApiResponse.error(errorMessage, statusCode: statusCode, errors: errors);
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e', statusCode: response.statusCode);
    }
  }

  // AUTHENTICATION METHODS

  // Login
  Future<ApiResponse<User>> login(String email, String password) async {
    final response = await _makeRequest<AuthTokens>(
      'POST',
      '/users/login/',
      body: {
        'email': email,
        'password': password,
      },
      fromJson: (data) => AuthTokens.fromJson(data),
      includeAuth: false,
    );

    if (response.success && response.data != null) {
      await _saveTokens(response.data!);

      // Get user data
      final userResponse = await getCurrentUserFromAPI();
      if (userResponse.success && userResponse.data != null) {
        await _saveUserData(userResponse.data!);
        return ApiResponse.success(userResponse.data!, message: 'Login successful');
      } else {
        await _clearStoredData();
        return ApiResponse.error('Failed to get user data');
      }
    } else {
      return ApiResponse.error(response.message ?? 'Login failed');
    }
  }

  // Register Academic Officer (specific endpoint)
  Future<ApiResponse<Map<String, dynamic>>> registerAcademicOfficer({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    return await _makeRequest<Map<String, dynamic>>(
      'POST',
      '/users/signup/academic-officer/',
      body: {
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'password': password,
        'confirm_password': confirmPassword,
      },
      fromJson: (data) => data,
      includeAuth: false,
    );
  }

  // Generic register method (you'll need to add this endpoint to Django)
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String email,
    required String fullName,
    required String phone,
    required String password,
    required String confirmPassword,
    required String role,
  }) async {
    // For now, only academic officer registration is available
    if (role == 'academic_officer') {
      return await registerAcademicOfficer(
        email: email,
        fullName: fullName,
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
      );
    } else {
      return ApiResponse.error('Registration for $role is not available through this endpoint');
    }
  }

  // Get current user from API
  Future<ApiResponse<User>> getCurrentUserFromAPI() async {
    return await _makeRequest<User>(
      'GET',
      '/users/me/',
      fromJson: (data) => User.fromJson(data),
    );
  }

  // Logout
  Future<ApiResponse<void>> logout() async {
    final refreshToken = await _getRefreshToken();

    if (refreshToken != null) {
      // Try to logout from server
      await _makeRequest<void>(
        'POST',
        '/users/logout/',
        body: {'refresh': refreshToken},
        retryOnUnauthorized: false,
      );
    }

    // Clear local storage regardless of server response
    await _clearStoredData();
    return ApiResponse.success(null, message: 'Logout successful');
  }

  // Validate token (useful for checking if user is still authenticated)
  Future<ApiResponse<bool>> validateToken() async {
    final response = await getCurrentUserFromAPI();
    return ApiResponse.success(response.success);
  }

  // GENERIC CRUD OPERATIONS

  // Get list of items
  Future<ApiResponse<List<T>>> getList<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson, {
        Map<String, String>? queryParams,
      }) async {
    return await _makeRequest<List<T>>(
      'GET',
      endpoint,
      queryParams: queryParams,
      fromJson: (data) {
        if (data is List) {
          return data.map((item) => fromJson(item)).toList();
        } else if (data is Map && data.containsKey('results')) {
          final List<dynamic> results = data['results'];
          return results.map((item) => fromJson(item)).toList();
        } else if (data is Map && data.containsKey('data')) {
          final List<dynamic> results = data['data'];
          return results.map((item) => fromJson(item)).toList();
        } else {
          throw Exception('Unexpected response format');
        }
      },
    );
  }

  // Get single item
  Future<ApiResponse<T>> getItem<T>(
      String endpoint,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    return await _makeRequest<T>(
      'GET',
      endpoint,
      fromJson: (data) => fromJson(data),
    );
  }

  // Create item
  Future<ApiResponse<T>> createItem<T>(
      String endpoint,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    return await _makeRequest<T>(
      'POST',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Update item
  Future<ApiResponse<T>> updateItem<T>(
      String endpoint,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    return await _makeRequest<T>(
      'PUT',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Partial update item
  Future<ApiResponse<T>> patchItem<T>(
      String endpoint,
      Map<String, dynamic> data,
      T Function(Map<String, dynamic>) fromJson,
      ) async {
    return await _makeRequest<T>(
      'PATCH',
      endpoint,
      body: data,
      fromJson: (data) => fromJson(data),
    );
  }

  // Delete item
  Future<ApiResponse<void>> deleteItem(String endpoint) async {
    return await _makeRequest<void>(
      'DELETE',
      endpoint,
    );
  }

  // SPECIFIC API METHODS FOR YOUR SCHOOL MANAGEMENT SYSTEM

  // Students
  Future<ApiResponse<List<dynamic>>> getStudents() async {
    return await getList('/students/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getStudent(int id) async {
    return await getItem('/students/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createStudent(Map<String, dynamic> data) async {
    return await createItem('/students/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateStudent(int id, Map<String, dynamic> data) async {
    return await updateItem('/students/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteStudent(int id) async {
    return await deleteItem('/students/$id/');
  }

  // Teachers
  Future<ApiResponse<List<dynamic>>> getTeachers() async {
    return await getList('/teachers/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getTeacher(int id) async {
    return await getItem('/teachers/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createTeacher(Map<String, dynamic> data) async {
    return await createItem('/teachers/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateTeacher(int id, Map<String, dynamic> data) async {
    return await updateItem('/teachers/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteTeacher(int id) async {
    return await deleteItem('/teachers/$id/');
  }

  // Admissions
  Future<ApiResponse<List<dynamic>>> getAdmissions() async {
    return await getList('/admissions/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAdmission(int id) async {
    return await getItem('/admissions/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createAdmission(Map<String, dynamic> data) async {
    return await createItem('/admissions/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateAdmission(int id, Map<String, dynamic> data) async {
    return await updateItem('/admissions/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteAdmission(int id) async {
    return await deleteItem('/admissions/$id/');
  }

  // Academics
  Future<ApiResponse<List<dynamic>>> getAcademics() async {
    return await getList('/academics/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAcademic(int id) async {
    return await getItem('/academics/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createAcademic(Map<String, dynamic> data) async {
    return await createItem('/academics/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateAcademic(int id, Map<String, dynamic> data) async {
    return await updateItem('/academics/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteAcademic(int id) async {
    return await deleteItem('/academics/$id/');
  }

  // Employees
  Future<ApiResponse<List<dynamic>>> getEmployees() async {
    return await getList('/employees/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getEmployee(int id) async {
    return await getItem('/employees/$id/', (data) => data);
  }

  Future<ApiResponse<dynamic>> createEmployee(Map<String, dynamic> data) async {
    return await createItem('/employees/', data, (data) => data);
  }

  Future<ApiResponse<dynamic>> updateEmployee(int id, Map<String, dynamic> data) async {
    return await updateItem('/employees/$id/', data, (data) => data);
  }

  Future<ApiResponse<void>> deleteEmployee(int id) async {
    return await deleteItem('/employees/$id/');
  }

  // Dashboards
  Future<ApiResponse<dynamic>> getStudentDashboard() async {
    return await getItem('/dashboards/student/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getTeacherDashboard() async {
    return await getItem('/dashboards/teacher/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getParentDashboard() async {
    return await getItem('/dashboards/parent/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAdminDashboard() async {
    return await getItem('/dashboards/admin/', (data) => data);
  }

  Future<ApiResponse<dynamic>> getAcademicOfficerDashboard() async {
    return await getItem('/dashboards/academic-officer/', (data) => data);
  }

  // Utility methods
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
}