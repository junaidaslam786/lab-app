
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/env.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  DioClient(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  Dio build() {
    final dio = Dio(BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ));

    dio.interceptors.addAll([
      LoggingInterceptor(enabled: Env.isDev),
      AuthInterceptor(_secureStorage),
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const [Duration(milliseconds: 300), Duration(seconds: 1), Duration(seconds: 2)],
        retryEvaluator: (e, i) => e.type != DioExceptionType.cancel && e.response?.statusCode != 401,
      ),
    ]);

    return dio;
  }
}
