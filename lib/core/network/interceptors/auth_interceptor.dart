import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final token = await _storage.read(key: _accessTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        print('✅ Auth token added to ${options.method} ${options.path}');
      } else {
        print('⚠️ No auth token found for ${options.method} ${options.path}');
      }
    } catch (e) {
      print('❌ Error reading auth token: $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print('❌ Request failed: ${err.response?.statusCode} ${err.requestOptions.path}');
    
    if (err.response?.statusCode == 401) {
      print('🔄 Attempting token refresh...');
      
      try {
        final refreshToken = await _storage.read(key: _refreshTokenKey);
        if (refreshToken == null) {
          print('❌ No refresh token available');
          await _clearTokens();
          return handler.next(err);
        }

        // Create a new Dio instance for refresh to avoid interceptor loop
        final refreshDio = Dio();
        final response = await refreshDio.post(
          '${err.requestOptions.baseUrl}/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final data = response.data['data'];
          final newAccessToken = data['accessToken'] as String?;
          final newRefreshToken = data['refreshToken'] as String?;

          if (newAccessToken != null) {
            await _storage.write(key: _accessTokenKey, value: newAccessToken);
            print('✅ New access token stored');
          }
          if (newRefreshToken != null) {
            await _storage.write(key: _refreshTokenKey, value: newRefreshToken);
            print('✅ New refresh token stored');
          }

          // Retry original request with new token
          if (newAccessToken != null) {
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccessToken';
            final retryResponse = await Dio().fetch(opts);
            return handler.resolve(retryResponse);
          }
        }
      } catch (refreshError) {
        print('❌ Token refresh failed: $refreshError');
        await _clearTokens();
      }
    }
    
    handler.next(err);
  }

  Future<void> _clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    print('🗑️ Tokens cleared');
  }
}
