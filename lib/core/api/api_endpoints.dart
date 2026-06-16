class ApiEndpoints {
  static const String baseUrl =
      'https://prepyouai-backend-pro.up.railway.app';
  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String refresh = '/api/v1/auth/refresh';
  static const String oauthCallback = '/api/v1/auth/oauth-callback';
  static const String createSession = '/api/v1/sessions';
  static const String pipelineStages = '/api/v1/pipeline-stages/session';
  static const String updateStageStatus = '/api/v1/pipeline-stages';
  static const String skills = '/api/v1/skills';
  static const String questions = '/api/v1/questions';
  static const String cvUpload = '/api/v1/cv-upload-stage/upload';
  static const String cvUploadStage = '/api/v1/cv-upload-stage';
  static const String mcqStage = '/api/v1/mcq-stage';
  static const String hrInterviewStage = '/api/v1/hr-interview-stage';
  static const String techInterviewStage = '/api/v1/tech-interview-stage';
  static const String finalReportStage = '/api/v1/final-report-stage';
}
