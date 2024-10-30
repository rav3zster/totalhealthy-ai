import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as Get;

import '../../../models/error_log_model.dart';
import '../../utitlity/debug_print.dart';
import '/app/core/base/controllers/auth_controller.dart';
import 'api_endpoints.dart';
// import '/app/models/logs/error_log_model.dart';

class APIMethods {
  static const _Get get = _Get();
  static const _Post post = _Post();
  static const _Patch patch = _Patch();
  static const _Put put = _Put();
  static const _Delete delete = _Delete();

  static const _Log log = _Log();
}

class _Get {
  const _Get();

  Future<Response> download(
      {required String url, ResponseType? responseType}) async {
    try {
      final response =
          await Dio().get(url, options: Options(responseType: responseType));
      return response;
    } on DioError catch (err) {
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> get({required String url, bool? isToken = true}) async {
    try {
      final response = await Dio().get(url,
          options:
              isToken == false ? null : Options(headers: await getHeader()));
      printDebug("API METHODS GET $url", "27", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS $url", "30", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> getWithCustomToken(
      {required String url, required String token}) async {
    try {
      final response = await Dio().get(url,
          options: Options(headers: {"Authorization": "Token $token"}));
      printDebug("API METHODS GET WCT $url", "39", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS CT $url", "42", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

class _Post {
  const _Post();

  Future<Response> post({required String url, required Map map}) async {
    try {
      print("post");
      final response = await Dio().post(url,
          data: json.encode(map), options: Options(headers: await getHeader()));
      printDebug("API METHODS POST $url", "72", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS POST $url", "75", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> postFormData(
      {required String url, required FormData map}) async {
    try {
      final response = await Dio()
          .post(url, data: map, options: Options(headers: await getHeader()));
      printDebug("API METHODS POST FD $url", "84", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS POST FD $url", "87", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> postWithCustomToken(
      {required String url, required Map map, required String token}) async {
    try {
      final response = await Dio().post(url,
          data: json.encode(map),
          options: Options(headers: {"Authorization": "Token $token"}));
      printDebug("API METHODS POST WCT $url", "96", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS POST WCT $url", "99", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> postFormDataWithCustomToken(
      {required String url,
      required FormData map,
      required String token}) async {
    try {
      final response = await Dio().post(url,
          data: map,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $token"
          }));
      printDebug(
          "API METHODS POST FD WCT $url", "108", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS POST FD WCT $url", "111",
          "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> postFormDataWithoutToken(
      {required String url, required FormData map}) async {
    try {
      final response = await Dio().post(url, data: map);
      printDebug(
          "API METHODS POST FD WT $url", "120", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS POST FD WT $url", "123",
          "${err.response} ${err.message}");
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> postWithoutToken(
      {required String url, required Map map}) async {
    try {
      final response = await Dio().post(url, data: json.encode(map));
      printDebug("API METHODS POST WT $url", "123", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS POST FD WT $url", "136",
          "${err.response} ${err.message}");
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> getWithoutToken({required String url}) async {
    try {
      final response = await Dio().get(url);
      printDebug("API METHODS POST WT $url", "123", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug("API METHODS POST FD WT $url", "136",
          "${err.response} ${err.message}");
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

class _Patch {
  const _Patch();

  Future<Response> patch({required String url, required Map map}) async {
    try {
      final response = await Dio()
          .patch(url, data: map, options: Options(headers: await getHeader()));
      printDebug("API METHODS PATCH $url", "152", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS POST $url", "155", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> patchFormData(
      {required String url, required FormData map}) async {
    try {
      final response = await Dio()
          .patch(url, data: map, options: Options(headers: await getHeader()));
      printDebug("API METHODS PATCH FD $url", "164", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS POST FD $url", "167", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

class _Put {
  const _Put();

  Future<Response> put({required String url, required Map map}) async {
    try {
      final response = await Dio().put(url,
          data: json.encode(map), options: Options(headers: await getHeader()));
      printDebug("API METHODS PUT $url", "183", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS PUT $url", "186", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }

  Future<Response> putFormData(
      {required String url, required FormData map}) async {
    try {
      final response = await Dio()
          .put(url, data: map, options: Options(headers: await getHeader()));
      printDebug("API METHODS PUT FD $url", "195", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS PUT FD $url", "198", "${err.response} ${err.message}");
      await APIMethods.log.logError(url, err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

class _Delete {
  const _Delete();

  Future<Response> delete({required String url}) async {
    try {
      final response =
          await Dio().delete(url, options: Options(headers: await getHeader()));
      printDebug("API METHODS DELETE $url", "213", response.data.toString());
      return response;
    } on DioError catch (err) {
      printDebug(
          "API METHODS DELETE $url", "216", "${err.response} ${err.message}");
      //await APIMethods.log.logError(url,err);
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

class _Log {
  const _Log();
  Future<Response> logError(String url, DioError err) async {
    try {
      ErrorLogModel error = ErrorLogModel(
          errorType: "API",
          errorCode: err.response?.statusCode ?? 0,
          errorMessage: err.response?.data.toString(),
          errorTraceback: err.stackTrace.toString(),
          source: url,
          deviceId: "null",
          deviceModel: "null");
      final response =
          await Dio().post(APIEndpoints.logs.errorLogs, data: error.toJson());
      return response;
    } on DioError catch (err) {
      printDebug("LOG API ERROR $url", "244", "${err.response} ${err.message}");
      return err.response ?? Response(requestOptions: err.requestOptions);
    }
  }
}

Future<Map<String, String>> getHeader() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String> map = {};
  map['Content-Type'] = "application/json";
  // map['Access-Control-Allow-Origin'] = '*';
  map['authorization'] = "Bearer ${Get.Get.find<AuthController>().authToken}";
  return map;
}

Map<String, String> getHeader2() {
  Map<String, String> map = {};
  map['Content-Type'] = "application/json";
  // map['Access-Control-Allow-Origin'] = '*';
  map['authorization'] = "Bearer ${"Utils.authToken"}";
  return map;
}

Map<String, String> getHeaderWithMultipart() {
  Map<String, String> map = {};
  map['Content-Type'] =
      "multipart/form-data; boundary=--------------------------706668994758108691715396";
  map["mimeType"] = "multipart/form-data";
  // map['Access-Control-Allow-Origin'] = '*';

  map['authorization'] = "Bearer ${"Utils.authToken"}";
  return map;
}
