class SparepartBookingState {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  SparepartBookingState({
    this.statusCode = 0,
    this.success = false,
    this.messages = const [],
    this.data = const [],
  });

  factory SparepartBookingState.initial() => SparepartBookingState();

  SparepartBookingState.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'].cast<String>();
    if (json['data'] != null) {
      data = List<Data>.from(json['data'].map((v) => Data.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'success': success,
    'messages': messages,
    'data': data?.map((v) => v.toJson()).toList(),
  };

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
    this.sId = '',
    this.serviceEngineer,
    this.sparePartIds = const [],
    this.location = '',
    this.address = '',
    this.status = '',
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Data.initial() => Data(serviceEngineer: ServiceEngineer.initial());

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceEngineer = json['serviceEngineer'] != null
        ? ServiceEngineer.fromJson(json['serviceEngineer'])
        : null;
    sparePartIds = json['sparePartIds'] != null
        ? List<SparePartIds>.from(json['sparePartIds'].map((v) => SparePartIds.fromJson(v)))
        : [];
    location = json['location'];
    address = json['address'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    this.sId = '',
    this.name = '',
    this.email = '',
    this.mobile = '',
    this.profileImage = const [],
    this.role = '',
  });

  factory ServiceEngineer.initial() => ServiceEngineer();

  ServiceEngineer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profileImage'] != null
        ? List<String>.from(json['profileImage'])
        : [];
    role = json['role'];
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
  String? price;
  List<String>? sparePartImages;
  String? distributorId;

  SparePartIds({
    this.sId = '',
    this.sparepartName = '',
    this.description = '',
    this.price = '',
    this.sparePartImages = const [],
    this.distributorId = '',
  });

  factory SparePartIds.initial() => SparePartIds();

  SparePartIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sparepartName = json['sparepartName'];
    description = json['description'];
    price = json['price'];
    sparePartImages = json['sparePartImages'] != null
        ? List<String>.from(json['sparePartImages'])
        : [];
    distributorId = json['distributorId'];
  }

  Map<String, dynamic> toJson() => {
    '_id': sId,
    'sparepartName': sparepartName,
    'description': description,
    'price': price,
    'sparePartImages': sparePartImages,
    'distributorId': distributorId,
  };
}
