class ErrorLogModel {
  final String? errorType;
  final int? errorCode;
  final String? errorMessage;
  final String? errorTraceback;
  final String? source;
  final String? deviceId;
  final String? deviceModel;

  ErrorLogModel({
    this.errorType,
    this.errorCode,
    this.errorMessage,
    this.errorTraceback,
    this.source,
    this.deviceId,
    this.deviceModel,
  });

  factory ErrorLogModel.fromJson(Map<String, dynamic> json) => ErrorLogModel(
    errorType: json["error_type"],
    errorCode: json["error_code"],
    errorMessage: json["error_message"],
    errorTraceback: json["error_traceback"],
    source: json["source"],
    deviceId: json["device_id"],
    deviceModel: json["device_model"],
  );
  Map<String, dynamic> toJson() => {
    "error_type": errorType,
    "error_code": errorCode,
    "error_message": errorMessage,
    "error_traceback": errorTraceback,
    "source": source,
    "device_id": deviceId,
    "device_model": deviceModel,
  };
}
