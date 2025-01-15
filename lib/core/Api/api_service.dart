import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'api_error.dart';
import 'default_model.dart';


class ApiService {
  static final Dio _dio = Dio();

  static String baseUrl = 'https://ml-test.atwdemo.com/chat';

  static String token = '';

  // _dio.options.headers['Authorization'] = 'Bearer $token';

  static Future<dynamic> api({
    required String endPoint,
    Map<String, dynamic>? data,
    String? fileKey,
    List<String>? filesPaths,
    bool isRaw = false,
    Map<String, dynamic>? queryParamters,
    Options? options,
    Function(int, int)? onReceiveProgress,
    required RequestType requestType,
    required BuildContext context,
  }) async {
    try {
      Map<String, String> headers = {
        "Accept": "application/json",
        "Authorization": "Bearer $token"
        //"X-localization": AppUtil.Lang == "" ? "en" : AppUtil.Lang
        // "token": token ?? "",
      };
      FormData formData = FormData();
      if (data != null) {
        data.forEach((key, value) {
          formData.fields.add(MapEntry(key, value.toString()));
        });
      }
      if (fileKey != null && filesPaths != null && filesPaths.isNotEmpty) {
        filesPaths.forEach((element) async {
          formData.files.add(
            MapEntry(
              fileKey,
              await MultipartFile.fromFile(element),
            ),
          );
        });
      }

      final response = requestType == RequestType.post
          ? await _dio.post(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
        options: Options(headers: headers),
        queryParameters: queryParamters,

      )
          : requestType == RequestType.get
          ? await _dio.get(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
        options:  Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParamters,
      )
          : requestType == RequestType.update
          ? await _dio.put(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
        options: options,
        queryParameters: queryParamters,
      )
          : await _dio.delete(
        '$baseUrl$endPoint',
        data: isRaw ? data : formData,
        options: options,
        queryParameters: queryParamters,
      );

      return DefaultModel.fromJson(response.data);
    } catch (error) {
      if (error is DioException) {
        // Handle Dio errors
        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            return DefaultModel(
                status: false, message: 'Connection timeout with ApiServer');
          case DioExceptionType.sendTimeout:
            return DefaultModel(
                status: false, message: 'Send timeout with ApiServer');
          case DioExceptionType.receiveTimeout:
            return DefaultModel(
                status: false, message: 'Receive timeout with ApiServer');
          case DioExceptionType.badResponse:
            {
              var response = error.response?.data;
              // ApiError apiError = ApiError.fromJson(response);

              // Show a user-friendly error message
              // AppUtil.showCustomToast(
              //   message: apiError.message ?? 'Unexpected error occurred.',
              //   context: context,
              // );

              // Optionally, you can show a more detailed message based on errors.
              // if (apiError.errors != null && apiError.errors!.isNotEmpty) {
              //   apiError.errors!.forEach((key, value) {
              //     // AppUtil.showCustomToast(
              //     //   message: '$key: ${value.join(', ')}',
              //     //   context: context,
              //     // );
              //   });
              // }

              return DefaultModel(status: false, message: 'error');
            }
          case DioExceptionType.cancel:
            return DefaultModel(
                status: false, message: 'Request to ApiServer was canceled');
          case DioExceptionType.connectionError:
            return DefaultModel(
                status: false, message: 'No Internet Connection');
          case DioExceptionType.unknown:
          default:
            return DefaultModel(
                status: false, message: 'Unexpected Error, Please try again!');
        }
      } else {
        // Handle general errors
        log(error.toString());
        // AppUtil.showCustomToast(message: error.toString(), context: context);
        return DefaultModel(status: false, message: error.toString());
      }
    }
  }
}


enum RequestType {
  post,
  get,
  update,
  delete,
}