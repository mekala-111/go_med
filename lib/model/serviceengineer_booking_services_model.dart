class ServiceenginnerBookingServicesModel {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final List<Data>? data;

  ServiceenginnerBookingServicesModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  factory ServiceenginnerBookingServicesModel.initial() => ServiceenginnerBookingServicesModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

  factory ServiceenginnerBookingServicesModel.fromJson(Map<String, dynamic> json) {
    return ServiceenginnerBookingServicesModel(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      data: (json['data'] as List?)?.map((e) => Data.fromJson(e)).toList(),
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
}

class Data {
  final String? sId;
  final UserId? userId;
  final List<ServiceIds>? serviceIds;
  final String? productId;
  final String? location;
  final String? address;
  final String? date;
  final String? time;
  final String? status;
  final String? serviceEngineerId;
  final String? createdAt;
  final String? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory Data.initial() => Data(
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
        createdAt: '',
        updatedAt: '',
      );

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      sId: json['_id'],
      userId: json['userId'] != null ? UserId.fromJson(json['userId']) : null,
      serviceIds: (json['serviceIds'] as List?)?.map((e) => ServiceIds.fromJson(e)).toList(),
      productId: json['productId'],
      location: json['location'],
      address: json['address'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      serviceEngineerId: json['serviceEngineerId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userId': userId?.toJson(),
      'serviceIds': serviceIds?.map((e) => e.toJson()).toList(),
      'productId': productId,
      'location': location,
      'address': address,
      'date': date,
      'time': time,
      'status': status,
      'serviceEngineerId': serviceEngineerId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserId {
  final String? sId;
  final String? mobile;
  final String? name;
  final String? email;
  final List<String>? profileImage;

  UserId({
    this.sId,
    this.mobile,
    this.name,
    this.email,
    this.profileImage,
  });

  factory UserId.initial() => UserId(
        sId: '',
        mobile: '',
        name: '',
        email: '',
        profileImage: [],
      );

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(
      sId: json['_id'],
      mobile: json['mobile'],
      name: json['name'],
      email: json['email'],
      profileImage: (json['profileImage'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'mobile': mobile,
      'name': name,
      'email': email,
      'profileImage': profileImage,
    };
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
}

class ServiceIds {
  final String? sId;
  final String? name;
  final String? details;
  final int? price;
  final List<String>? productIds;
  final DistributorId? distributorId;

  ServiceIds({
    this.sId,
    this.name,
    this.details,
    this.price,
    this.productIds,
    this.distributorId,
  });

  factory ServiceIds.initial() => ServiceIds(
        sId: '',
        name: '',
        details: '',
        price: 0,
        productIds: [],
        distributorId: DistributorId.initial(),
      );

  factory ServiceIds.fromJson(Map<String, dynamic> json) {
    return ServiceIds(
      sId: json['_id'],
      name: json['name'],
      details: json['details'],
      price: json['price'],
      productIds: (json['productIds'] as List?)?.map((e) => e.toString()).toList(),
      distributorId:
          json['distributorId'] != null ? DistributorId.fromJson(json['distributorId']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'details': details,
      'price': price,
      'productIds': productIds,
      'distributorId': distributorId?.toJson(),
    };
  }

  ServiceIds copyWith({
    String? sId,
    String? name,
    String? details,
    int? price,
    List<String>? productIds,
    DistributorId? distributorId,
  }) {
    return ServiceIds(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      details: details ?? this.details,
      price: price ?? this.price,
      productIds: productIds ?? this.productIds,
      distributorId: distributorId ?? this.distributorId,
    );
  }
}

class DistributorId {
  final String? sId;
  final String? ownerName;
  final String? firmName;

  DistributorId({
    this.sId,
    this.ownerName,
    this.firmName,
  });

  factory DistributorId.initial() => DistributorId(
        sId: '',
        ownerName: '',
        firmName: '',
      );

  factory DistributorId.fromJson(Map<String, dynamic> json) {
    return DistributorId(
      sId: json['_id'],
      ownerName: json['ownerName'],
      firmName: json['firmName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'ownerName': ownerName,
      'firmName': firmName,
    };
  }

  DistributorId copyWith({
    String? sId,
    String? ownerName,
    String? firmName,
  }) {
    return DistributorId(
      sId: sId ?? this.sId,
      ownerName: ownerName ?? this.ownerName,
      firmName: firmName ?? this.firmName,
    );
  }
}
