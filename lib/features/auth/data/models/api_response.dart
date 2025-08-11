import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable()
class ApiResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiResponse &&
          runtimeType == other.runtimeType &&
          success == other.success &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => success.hashCode ^ message.hashCode ^ data.hashCode;

  @override
  String toString() => 'ApiResponse(success: $success, message: $message, data: $data)';
}
