// import 'package:flutter/material.dart';

class UserModel {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final List<Data>? data;

  UserModel({this.statusCode, this.success, this.messages, this.data});

  // Factory method for an initial empty instance
  factory UserModel.initial() {
    return UserModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  UserModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return UserModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: List<String>.from(json['messages'] ?? []),
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'messages': messages,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  final String? accessToken;
  final String? refreshToken;
  final Details? details;

  Data({this.accessToken, this.refreshToken, this.details});

  // Factory method for an initial empty instance
  factory Data.initial() {
    return Data(
      accessToken: '',
      refreshToken: '',
      details: Details.initial(),
    );
  }

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    Details? details,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      details: details ?? this.details,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      details: json['details'] != null ? Details.fromJson(json['details']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'details': details?.toJson(),
    };
  }
}

class Details {
  final String? sId;
  final String? name;
  final String? mobile;
  final String? role;
  final String? email;
  final String? firmName;
  final String? gstNumber;
  final String? status;
  final String? address;
  final List<String>? distributorImage;
  final List<String>? serviceEngineerImage;
  final int? experience;
  final String? certificate;

  Details({
    this.sId,
    this.name,
    this.mobile,
    this.role,
    this.email,
    this.firmName,
    this.gstNumber,
    this.status,
    this.address,
    this.distributorImage,
    this.serviceEngineerImage,
    this.experience,
    this.certificate,
  });

  // Factory method for an initial empty instance
  factory Details.initial() {
    return Details(
      sId: '',
      name: '',
      mobile: '',
      role: '',
      email: '',
      firmName: '',
      gstNumber: '',
      status: '',
      address: '',
      distributorImage: [],
      serviceEngineerImage: [],
      experience: 0,
      certificate: '',
    );
  }

  Details copyWith({
    String? sId,
    String? name,
    String? mobile,
    String? role,
    String? email,
    String? firmName,
    String? gstNumber,
    String? status,
    String? address,
    List<String>? distributorImage,
    List<String>? serviceEngineerImage,
    String? experience,
    String? certificate,
  }) {
    return Details(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      email: email ?? this.email,
      firmName: firmName ?? this.firmName,
      gstNumber: gstNumber ?? this.gstNumber,
      status: status ?? this.status,
      address: address ?? this.address,
      distributorImage: distributorImage ?? this.distributorImage,
      serviceEngineerImage: serviceEngineerImage ?? this.serviceEngineerImage,
      experience: 0,
      certificate: certificate ?? this.certificate,
    );
  }

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      sId: json['_id'],
      name: json['name'],
      mobile: json['mobile'],
      role: json['role'],
      email: json['email'],
      firmName: json['firmName'],
      gstNumber: json['gstNumber'],
      status: json['status'],
      address: json['address'],
      distributorImage: List<String>.from(json['distributorImage'] ?? []),
      serviceEngineerImage: List<String>.from(json['serviceEngineerImage'] ?? []),
      experience: json['experience'],
      certificate: json['certificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'mobile': mobile,
      'role': role,
      'email': email,
      'firmName': firmName,
      'gstNumber': gstNumber,
      'status': status,
      'address': address,
      'distributorImage': distributorImage,
      'serviceEngineerImage': serviceEngineerImage,
      'experience': experience,
      'certificate': certificate,
    };
  }
}
