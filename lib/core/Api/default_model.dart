class DefaultModel {
  bool? status;
  Map<String, dynamic>? errors;
  String? message;
  dynamic data;

  DefaultModel({this.status, this.errors, this.message, this.data});

  DefaultModel.fromJson(Map<String, dynamic> json) {
    status = json["Status"];
    errors = json["Errors"];
    //json['Errors'] != null ? new Errors.fromJson(json['Errors']) : null;
    message = json["Message"];
    data = json["Data"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["Status"] = status;
    data["Errors"] = errors;
    data["Message"] = message;
    data["Data"] = this.data;
    return data;
  }
}