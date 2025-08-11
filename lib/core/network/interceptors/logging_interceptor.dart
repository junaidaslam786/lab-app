
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  LoggingInterceptor({required this.enabled});
  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      PrettyDioLogger(
        requestHeader: true, requestBody: true, responseHeader: false, responseBody: false,
      ).onRequest(options, handler);
    } else {
      handler.next(options);
    }
  }
}
