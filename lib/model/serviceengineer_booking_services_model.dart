class ServiceenginnerBookingServicesModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  ServiceenginnerBookingServicesModel({this.statusCode, this.success, this.messages, this.data});

  factory ServiceenginnerBookingServicesModel.fromJson(Map<String, dynamic> json) => ServiceenginnerBookingServicesModel(
        statusCode: json['statusCode'],
        success: json['success'],
        messages: json['messages']?.cast<String>(),
        data: json['data'] != null
            ? (json['data'] as List).map((v) => Data.fromJson(v)).toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((v) => v.toJson()).toList(),
      };

  ServiceenginnerBookingServicesModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) =>
      ServiceenginnerBookingServicesModel(
        statusCode: statusCode ?? this.statusCode,
        success: success ?? this.success,
        messages: messages ?? this.messages,
        data: data ?? this.data,
      );

  static ServiceenginnerBookingServicesModel initial() => ServiceenginnerBookingServicesModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );
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
  ServiceEngineerId? serviceEngineerId;
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        sId: json['_id'],
        userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
        serviceIds: json['serviceIds'] != null
            ? (json['serviceIds'] as List)
                .map((v) => ServiceIds.fromJson(v))
                .toList()
            : null,
        productId: json['productId'],
        location: json['location'],
        address: json['address'],
        date: json['date'],
        time: json['time'],
        status: json['status'],
        serviceEngineerId: json['serviceEngineerId'] != null
            ? ServiceEngineerId.fromJson(json['serviceEngineerId'])
            : null,
        startOtp: json['startOtp'],
        endOtp: json['endOtp'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'userId': userId?.toJson(),
        'serviceIds': serviceIds?.map((v) => v.toJson()).toList(),
        'productId': productId,
        'location': location,
        'address': address,
        'date': date,
        'time': time,
        'status': status,
        'serviceEngineerId': serviceEngineerId?.toJson(),
        'startOtp': startOtp,
        'endOtp': endOtp,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

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
    ServiceEngineerId? serviceEngineerId,
    String? startOtp,
    String? endOtp,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
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

  static Data initial() => Data(
        sId: '',
        userId: UserId.initial(),
        serviceIds: [],
        productId: '',
        location: '',
        address: '',
        date: '',
        time: '',
        status: '',
        serviceEngineerId: ServiceEngineerId.initial(),
        startOtp: '',
        endOtp: '',
        createdAt: '',
        updatedAt: '',
      );
}

class UserId {
  String? sId;
  String? mobile;
  String? name;
  String? email;
  List<String>? profileImage;

  UserId({this.sId, this.mobile, this.name, this.email, this.profileImage});

  factory UserId.fromJson(Map<String, dynamic> json) => UserId(
        sId: json['_id'],
        mobile: json['mobile'],
        name: json['name'],
        email: json['email'],
        profileImage: json['profileImage']?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'mobile': mobile,
        'name': name,
        'email': email,
        'profileImage': profileImage,
      };

  UserId copyWith({
    String? sId,
    String? mobile,
    String? name,
    String? email,
    List<String>? profileImage,
  }) =>
      UserId(
        sId: sId ?? this.sId,
        mobile: mobile ?? this.mobile,
        name: name ?? this.name,
        email: email ?? this.email,
        profileImage: profileImage ?? this.profileImage,
      );

  static UserId initial() => UserId(
        sId: '',
        mobile: '',
        name: '',
        email: '',
        profileImage: [],
      );
}

class ServiceIds {
  String? sId;
  String? name;
  String? details;
  int? price;
  List<String>? productIds;
  DistributorId? distributorId;

  ServiceIds({
    this.sId,
    this.name,
    this.details,
    this.price,
    this.productIds,
    this.distributorId,
  });

  factory ServiceIds.fromJson(Map<String, dynamic> json) => ServiceIds(
        sId: json['_id'],
        name: json['name'],
        details: json['details'],
        price: json['price'],
        productIds: json['productIds']?.cast<String>(),
        distributorId: json['distributorId'] != null
            ? DistributorId.fromJson(json['distributorId'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'details': details,
        'price': price,
        'productIds': productIds,
        'distributorId': distributorId?.toJson(),
      };

  ServiceIds copyWith({
    String? sId,
    String? name,
    String? details,
    int? price,
    List<String>? productIds,
    DistributorId? distributorId,
  }) =>
      ServiceIds(
        sId: sId ?? this.sId,
        name: name ?? this.name,
        details: details ?? this.details,
        price: price ?? this.price,
        productIds: productIds ?? this.productIds,
        distributorId: distributorId ?? this.distributorId,
      );

  static ServiceIds initial() => ServiceIds(
        sId: '',
        name: '',
        details: '',
        price: 0,
        productIds: [],
        distributorId: DistributorId.initial(),
      );
}

class DistributorId {
  String? sId;
  String? ownerName;
  String? firmName;

  DistributorId({this.sId, this.ownerName, this.firmName});

  factory DistributorId.fromJson(Map<String, dynamic> json) => DistributorId(
        sId: json['_id'],
        ownerName: json['ownerName'],
        firmName: json['firmName'],
      );

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'ownerName': ownerName,
        'firmName': firmName,
      };

  DistributorId copyWith({
    String? sId,
    String? ownerName,
    String? firmName,
  }) =>
      DistributorId(
        sId: sId ?? this.sId,
        ownerName: ownerName ?? this.ownerName,
        firmName: firmName ?? this.firmName,
      );

  static DistributorId initial() => DistributorId(
        sId: '',
        ownerName: '',
        firmName: '',
      );
}

class ServiceEngineerId {
  String? sId;
  String? name;
  String? mobile;
  String? email;

  ServiceEngineerId({this.sId, this.name, this.mobile, this.email});

  factory ServiceEngineerId.fromJson(Map<String, dynamic> json) =>
      ServiceEngineerId(
        sId: json['_id'],
        name: json['name'],
        mobile: json['mobile'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'mobile': mobile,
        'email': email,
      };

  ServiceEngineerId copyWith({
    String? sId,
    String? name,
    String? mobile,
    String? email,
  }) =>
      ServiceEngineerId(
        sId: sId ?? this.sId,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
      );

  static ServiceEngineerId initial() => ServiceEngineerId(
        sId: '',
        name: '',
        mobile: '',
        email: '',
      );
}
