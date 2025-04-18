class SparepartBookingState {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  SparepartBookingState({this.statusCode, this.success, this.messages, this.data});

  factory SparepartBookingState.initial() => SparepartBookingState(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );

  SparepartBookingState copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return SparepartBookingState(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  factory SparepartBookingState.fromJson(Map<String, dynamic> json) {
    return SparepartBookingState(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: List<String>.from(json['messages'] ?? []),
      data: (json['data'] as List?)?.map((v) => Data.fromJson(v)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((v) => v.toJson()).toList(),
      };
}


class Data {
  String? sId;
  ServiceEngineer? serviceEngineer;
  List<SparePartIds>? sparePartIds;
  String? location;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.serviceEngineer,
    this.sparePartIds,
    this.location,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.initial() => Data(
        sId: '',
        serviceEngineer: ServiceEngineer.initial(),
        sparePartIds: [],
        location: '',
        address: '',
        status: '',
        createdAt: '',
        updatedAt: '',
      );

  Data copyWith({
    String? sId,
    ServiceEngineer? serviceEngineer,
    List<SparePartIds>? sparePartIds,
    String? location,
    String? address,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return Data(
      sId: sId ?? this.sId,
      serviceEngineer: serviceEngineer ?? this.serviceEngineer,
      sparePartIds: sparePartIds ?? this.sparePartIds,
      location: location ?? this.location,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      sId: json['_id'],
      serviceEngineer: json['serviceEngineer'] != null
          ? ServiceEngineer.fromJson(json['serviceEngineer'])
          : null,
      sparePartIds: (json['sparePartIds'] as List?)
              ?.map((v) => SparePartIds.fromJson(v))
              .toList() ??
          [],
      location: json['location'],
      address: json['address'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'serviceEngineer': serviceEngineer?.toJson(),
        'sparePartIds': sparePartIds?.map((v) => v.toJson()).toList(),
        'location': location,
        'address': address,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class ServiceEngineer {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  List<String>? profileImage;
  String? role;

  ServiceEngineer({
    this.sId,
    this.name,
    this.email,
    this.mobile,
    this.profileImage,
    this.role,
  });

  factory ServiceEngineer.initial() => ServiceEngineer(
        sId: '',
        name: '',
        email: '',
        mobile: '',
        profileImage: [],
        role: '',
      );

  ServiceEngineer copyWith({
    String? sId,
    String? name,
    String? email,
    String? mobile,
    List<String>? profileImage,
    String? role,
  }) {
    return ServiceEngineer(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
    );
  }

  factory ServiceEngineer.fromJson(Map<String, dynamic> json) {
    return ServiceEngineer(
      sId: json['_id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      profileImage: List<String>.from(json['profileImage'] ?? []),
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'profileImage': profileImage,
        'role': role,
      };
}

class SparePartIds {
  String? sId;
  String? sparepartName;
  String? description;
  int? price;
  List<String>? sparePartImages;

  SparePartIds({
    this.sId,
    this.sparepartName,
    this.description,
    this.price,
    this.sparePartImages,
  });

  factory SparePartIds.initial() => SparePartIds(
        sId: '',
        sparepartName: '',
        description: '',
        price: 0,
        sparePartImages: [],
      );

  SparePartIds copyWith({
    String? sId,
    String? sparepartName,
    String? description,
    int? price,
    List<String>? sparePartImages,
  }) {
    return SparePartIds(
      sId: sId ?? this.sId,
      sparepartName: sparepartName ?? this.sparepartName,
      description: description ?? this.description,
      price: price ?? this.price,
      sparePartImages: sparePartImages ?? this.sparePartImages,
    );
  }

  factory SparePartIds.fromJson(Map<String, dynamic> json) {
    return SparePartIds(
      sId: json['_id'],
      sparepartName: json['sparepartName'],
      description: json['description'],
      price: json['price'],
      sparePartImages: List<String>.from(json['sparePartImages'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'sparepartName': sparepartName,
        'description': description,
        'price': price,
        'sparePartImages': sparePartImages,
      };
}
