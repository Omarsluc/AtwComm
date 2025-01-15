// class ApiError {
//   String? message;
//   Map<String, List<String>>? errors;
//
//   ApiError({this.message, this.errors});
//
//   factory ApiError.fromJson(Map<String, dynamic> json) {
//     return ApiError(
//       message: json['message'],
//       errors: (json['errors'] as Map<String, dynamic>?)?.map(
//             (key, value) => MapEntry(key, List<String>.from(value)),
//       ),
//     );
//   }
// }