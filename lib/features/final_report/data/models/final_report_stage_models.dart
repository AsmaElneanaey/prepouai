import 'final_report_model.dart';
import '../../domain/entities/report_share_response.dart';

class FinalReportResponseDto {
  const FinalReportResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FinalReportResponseDto.fromJson(Map<String, dynamic> json) {
    return FinalReportResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: FinalReportModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final FinalReportModel data;
}

class ReportShareResponseModel {
  const ReportShareResponseModel({
    required this.token,
  });

  factory ReportShareResponseModel.fromJson(Map<String, dynamic> json) {
    return ReportShareResponseModel(
      token: json['token'] as String? ?? '',
    );
  }

  final String token;

  ReportShareResponse toEntity() {
    return ReportShareResponse(
      token: token,
    );
  }
}

class ReportShareResponseDto {
  const ReportShareResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReportShareResponseDto.fromJson(Map<String, dynamic> json) {
    return ReportShareResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: ReportShareResponseModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final ReportShareResponseModel data;
}
