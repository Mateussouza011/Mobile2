import 'package:equatable/equatable.dart';

/// Response padrão da API
class ApiResponse<T> extends Equatable {
  final bool success;
  final String? message;
  final T? data;
  final Map<String, dynamic>? meta;
  final ApiError? error;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
    this.error,
  });

  factory ApiResponse.success({
    String? message,
    T? data,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      meta: meta,
    );
  }

  factory ApiResponse.error({
    required String message,
    required String code,
    Map<String, dynamic>? details,
  }) {
    return ApiResponse(
      success: false,
      error: ApiError(
        message: message,
        code: code,
        details: details,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': _serializeData(data),
      if (meta != null) 'meta': meta,
      if (error != null) 'error': error!.toJson(),
    };
  }

  dynamic _serializeData(dynamic data) {
    if (data is List) {
      return data.map((item) {
        if (item is Map) return item;
        if (item is Serializable) return item.toJson();
        return item;
      }).toList();
    }
    if (data is Serializable) return data.toJson();
    return data;
  }

  @override
  List<Object?> get props => [success, message, data, meta, error];
}

/// Erro da API
class ApiError extends Equatable {
  final String message;
  final String code;
  final Map<String, dynamic>? details;

  const ApiError({
    required this.message,
    required this.code,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
      if (details != null) 'details': details,
    };
  }

  @override
  List<Object?> get props => [message, code, details];
}

/// Interface para objetos serializáveis
abstract class Serializable {
  Map<String, dynamic> toJson();
}

/// Rate limit info
class RateLimitInfo extends Equatable {
  final int limit;
  final int remaining;
  final DateTime resetAt;

  const RateLimitInfo({
    required this.limit,
    required this.remaining,
    required this.resetAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'remaining': remaining,
      'reset_at': resetAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [limit, remaining, resetAt];
}

/// Pagination meta
class PaginationMeta extends Equatable {
  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  const PaginationMeta({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
    };
  }

  @override
  List<Object?> get props => [page, perPage, total, totalPages];
}
