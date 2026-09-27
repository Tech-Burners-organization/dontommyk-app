class ErrorResponse {
  const ErrorResponse({this.status, this.statusCode, this.message});

  final String? status;
  final int? statusCode;
  final String? message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status']?.toString(),
      statusCode: json['statusCode'] as int?,
      message: json['message']?.toString(),
    );
  }
}
