class ServiceenginnerBookingServicesModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  ServiceenginnerBookingServicesModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  ServiceenginnerBookingServicesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'] != null 
        ? List<String>.from(json['messages']) 
        : [];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['statusCode'] = statusCode;
    map['success'] = success;
    map['messages'] = messages;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }

  ServiceenginnerBookingServicesModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return ServiceenginnerBookingServicesModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  static ServiceenginnerBookingServicesModel initial() {
    return ServiceenginnerBookingServicesModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }
}

class Data {
  String? sId;
  UserId? userId;
  List<ServiceIds>? serviceIds;
  String? productId;
  String? location;
  String? address;
  String? date;
  String? time;
  String? status;
  String? serviceEngineerId;
  String? startOtp;
  String? endOtp;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.userId,
    this.serviceIds,
    this.productId,
    this.location,
    this.address,
    this.date,
    this.time,
    this.status,
    this.serviceEngineerId,
    this.startOtp,
    this.endOtp,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? UserId.fromJson(json['userId']) : null;
    if (json['serviceIds'] != null) {
      serviceIds = <ServiceIds>[];
      json['serviceIds'].forEach((v) {
        serviceIds!.add(ServiceIds.fromJson(v));
      });
    }
    productId = json['productId'];
    location = json['location'];
    address = json['address'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    serviceEngineerId = json['serviceEngineerId'];
    startOtp = json['startOtp'];
    endOtp = json['endOtp'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    if (userId != null) {
      map['userId'] = userId!.toJson();
    }
    if (serviceIds != null) {
      map['serviceIds'] = serviceIds!.map((v) => v.toJson()).toList();
    }
    map['productId'] = productId;
    map['location'] = location;
    map['address'] = address;
    map['date'] = date;
    map['time'] = time;
    map['status'] = status;
    map['serviceEngineerId'] = serviceEngineerId;
    map['startOtp'] = startOtp;
    map['endOtp'] = endOtp;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    return map;
  }

  Data copyWith({
    String? sId,
    UserId? userId,
    List<ServiceIds>? serviceIds,
    String? productId,
    String? location,
    String? address,
    String? date,
    String? time,
    String? status,
    String? serviceEngineerId,
    String? startOtp,
    String? endOtp,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      sId: sId ?? this.sId,
      userId: userId ?? this.userId,
      serviceIds: serviceIds ?? this.serviceIds,
      productId: productId ?? this.productId,
      location: location ?? this.location,
      address: address ?? this.address,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      serviceEngineerId: serviceEngineerId ?? this.serviceEngineerId,
      startOtp: startOtp ?? this.startOtp,
      endOtp: endOtp ?? this.endOtp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Data initial() {
    return Data(
      sId: '',
      userId: UserId.initial(),
      serviceIds: [],
      productId: '',
      location: '',
      address: '',
      date: '',
      time: '',
      status: '',
      serviceEngineerId: '',
      startOtp: '',
      endOtp: '',
      createdAt: '',
      updatedAt: '',
    );
  }
}

class UserId {
  String? sId;
  String? mobile;
  String? name;
  String? email;
  List<String>? profileImage;

  UserId({this.sId, this.mobile, this.name, this.email, this.profileImage});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    name = json['name'];
    email = json['email'];
    profileImage = json['profileImage']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['mobile'] = mobile;
    map['name'] = name;
    map['email'] = email;
    map['profileImage'] = profileImage;
    return map;
  }

  UserId copyWith({
    String? sId,
    String? mobile,
    String? name,
    String? email,
    List<String>? profileImage,
  }) {
    return UserId(
      sId: sId ?? this.sId,
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  static UserId initial() {
    return UserId(
      sId: '',
      mobile: '',
      name: '',
      email: '',
      profileImage: [],
    );
  }
}

class ServiceIds {
  String? sId;
  String? name;
  String? details;
  int? price;
  List<String>? productIds;

  ServiceIds({this.sId, this.name, this.details, this.price, this.productIds});

  ServiceIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    details = json['details'];
    price = json['price'];
    productIds = json['productIds']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = sId;
    map['name'] = name;
    map['details'] = details;
    map['price'] = price;
    map['productIds'] = productIds;
    return map;
  }

  ServiceIds copyWith({
    String? sId,
    String? name,
    String? details,
    int? price,
    List<String>? productIds,
  }) {
    return ServiceIds(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      details: details ?? this.details,
      price: price ?? this.price,
      productIds: productIds ?? this.productIds,
    );
  }

  static ServiceIds initial() {
    return ServiceIds(
      sId: '',
      name: '',
      details: '',
      price: 0,
      productIds: [],
    );
  }
}
