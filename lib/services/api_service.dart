import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle unauthorized error (e.g., logout or refresh token)
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> login(String email, String password) async {
    return await _dio.post(
      AppConstants.loginEndpoint,
      data: FormData.fromMap({
        'username': email,
        'password': password,
      }),
    );
  }

  Future<Response> register(String name, String email, String password) async {
    return await _dio.post(
      AppConstants.registerEndpoint,
      data: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> getTasks() async {
    return await _dio.get(AppConstants.tasksEndpoint);
  }

  Future<Response> createTask(Map<String, dynamic> taskData) async {
    return await _dio.post(AppConstants.tasksEndpoint, data: taskData);
  }

  Future<Response> updateTask(int taskId, Map<String, dynamic> taskData) async {
    return await _dio.put('${AppConstants.tasksEndpoint}/$taskId', data: taskData);
  }

  Future<Response> deleteTask(int taskId) async {
    return await _dio.delete('${AppConstants.tasksEndpoint}/$taskId');
  }
}
