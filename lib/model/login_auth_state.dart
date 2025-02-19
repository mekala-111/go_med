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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
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
  Details? details;

  Data({this.accessToken, this.refreshToken, this.details});

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
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

  static Data initial() {
    return Data(
      accessToken: '',
      refreshToken: '',
      details: Details.initial(),
    );
  }
}

class Details {
  String? sId;
  String? name;  // Changed from Null to String?
  String? mobile;
  String? role;
  String? email;  // Changed from Null to String?
  String? firmName;
  String? gstNumber;
  String? status;
  String? address;
  List<dynamic>? distributorImage;  // Changed from Null to dynamic
  String? experience;  // Changed from Null to String?
  String? certificate;  // Changed from Null to String?

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
    this.experience,
    this.certificate,
  });

  Details.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    mobile = json['mobile'];
    role = json['role'];
    email = json['email'];
    firmName = json['firmName'];
    gstNumber = json['gstNumber'];
    status = json['status'];
    address = json['address'];
    if (json['distributorImage'] != null) {
      distributorImage = json['distributorImage']; // List<dynamic> instead of Null
    }
    experience = json['experience'];
    certificate = json['certificate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
    data['email'] = this.email;
    data['firmName'] = this.firmName;
    data['gstNumber'] = this.gstNumber;
    data['status'] = this.status;
    data['address'] = this.address;
    if (this.distributorImage != null) {
      data['distributorImage'] = this.distributorImage; // No null check needed, it's dynamic
    }
    data['experience'] = this.experience;
    data['certificate'] = this.certificate;
    return data;
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
    List<dynamic>? distributorImage,
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
      experience: experience ?? this.experience,
      certificate: certificate ?? this.certificate,
    );
  }

  static Details initial() {
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
      experience: '',
      certificate: '',
    );
  }
}
