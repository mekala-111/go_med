class UserModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  UserModel({this.statusCode, this.success, this.messages, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'].cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data ={};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // CopyWith method to create a modified copy of the object
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

  // Initial method to create an initial empty state
  static UserModel initial() {
    return UserModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }
}

class Data {
  String? accessToken;
  String? refreshToken;
  Distributor? distributor;

  Data({this.accessToken, this.refreshToken, this.distributor});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    distributor = json['distributor'] != null
        ?  Distributor.fromJson(json['distributor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['access_token'] = accessToken;
    data['refresh_token'] =refreshToken;
    if (distributor != null) {
      data['distributor'] = distributor!.toJson();
    }
    return data;
  }

  // CopyWith method for Data class
  Data copyWith({
    String? accessToken,
    String? refreshToken,
    Distributor? distributor,
  }) {
    return Data(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      distributor: distributor ?? this.distributor,
    );
  }

  // Initial method to create an initial empty state for Data
  static Data initial() {
    return Data(
      accessToken: '',
      refreshToken: '',
      distributor: Distributor.initial(),
    );
  }
}

class Distributor {
  String? sId;
  String? mobile;
  String? role;
  String? ownerName;
  String? firmName;
  String? gstNumber;
  String? status;
  String? address;

  Distributor(
      {this.sId,
      this.mobile,
      this.role,
      this.ownerName,
      this.firmName,
      this.gstNumber,
      this.status,
      this.address});

  Distributor.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    role = json['role'];
    ownerName = json['ownerName'];
    firmName = json['firmName'];
    gstNumber = json['gstNumber'];
    status = json['status'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['mobile'] = mobile;
    data['role'] = role;
    data['ownerName'] = ownerName;
    data['firmName'] = firmName;
    data['gstNumber'] = gstNumber;
    data['status'] = status;
    data['address'] = address;
    return data;
  }

  // CopyWith method for Distributor class
  Distributor copyWith({
    String? sId,
    String? mobile,
    String? role,
    String? ownerName,
    String? firmName,
    String? gstNumber,
    String? status,
    String? address,
  }) {
    return Distributor(
      sId: sId ?? this.sId,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      ownerName: ownerName ?? this.ownerName,
      firmName: firmName ?? this.firmName,
      gstNumber: gstNumber ?? this.gstNumber,
      status: status ?? this.status,
      address: address ?? this.address,
    );
  }

  // Initial method to create an initial empty state for Distributor
  static Distributor initial() {
    return Distributor(
      sId: '',
      mobile: '',
      role: '',
      ownerName: '',
      firmName: '',
      gstNumber: '',
      status: '',
      address: '',
    );
  }
}
