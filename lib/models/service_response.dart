class ServiceResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final dynamic error;

  ServiceResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ServiceResponse.success(T data, [String? message]) {
    return ServiceResponse(
      success: true,
      data: data,
      message: message,
    );
  }

  factory ServiceResponse.error(dynamic error) {
    return ServiceResponse(
      success: false,
      error: error,
      message: error.toString(),
    );
  }
} 