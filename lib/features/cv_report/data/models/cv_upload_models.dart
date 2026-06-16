import '../../domain/entities/cv_upload_response.dart';
import '../../domain/entities/cv_parse_response.dart';
import '../../../skills/data/models/skill_model.dart';

class CvUploadResponseModel {
  const CvUploadResponseModel({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.status,
  });

  factory CvUploadResponseModel.fromJson(Map<String, dynamic> json) {
    return CvUploadResponseModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      fileName: json['fileName'] as String? ?? json['file_name'] as String? ?? '',
      fileSize: json['fileSize'] as int? ?? json['file_size'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  final String id;
  final String fileName;
  final int fileSize;
  final String status;

  CvUploadResponse toEntity() {
    return CvUploadResponse(
      id: id,
      fileName: fileName,
      fileSize: fileSize,
      status: status,
    );
  }
}

class CvUploadResponseDto {
  const CvUploadResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CvUploadResponseDto.fromJson(Map<String, dynamic> json) {
    return CvUploadResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: CvUploadResponseModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final CvUploadResponseModel data;
}

class CvParseResponseModel {
  const CvParseResponseModel({
    required this.id,
    required this.isParsed,
    required this.status,
  });

  factory CvParseResponseModel.fromJson(Map<String, dynamic> json) {
    return CvParseResponseModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      isParsed: json['isParsed'] as bool? ?? json['is_parsed'] as bool? ?? false,
      status: json['status'] as String? ?? '',
    );
  }

  final String id;
  final bool isParsed;
  final String status;

  CvParseResponse toEntity() {
    return CvParseResponse(
      id: id,
      isParsed: isParsed,
      status: status,
    );
  }
}

class CvParseResponseDto {
  const CvParseResponseDto({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CvParseResponseDto.fromJson(Map<String, dynamic> json) {
    return CvParseResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: CvParseResponseModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  final bool success;
  final String message;
  final CvParseResponseModel data;
}

class CvSkillsResponseDto {
  const CvSkillsResponseDto({
    required this.success,
    required this.message,
    required this.skills,
  });

  factory CvSkillsResponseDto.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>? ?? const [];
    return CvSkillsResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      skills: list
          .map((e) => SkillModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final bool success;
  final String message;
  final List<SkillModel> skills;
}
