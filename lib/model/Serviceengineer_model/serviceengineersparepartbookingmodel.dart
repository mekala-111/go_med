class ServiceengineersparepartbookingModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  ServiceengineersparepartbookingModel(
      {this.statusCode, this.success, this.messages, this.data});

  ServiceengineersparepartbookingModel.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((v) => v.toJson()).toList(),
      };

  ServiceengineersparepartbookingModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return ServiceengineersparepartbookingModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  static ServiceengineersparepartbookingModel initial() =>
      ServiceengineersparepartbookingModel(
        statusCode: 0,
        success: false,
        messages: [],
        data: [],
      );
}

class Data {
  String? sId;
  ServiceEngineer? serviceEngineer;
  String? otp;
  double? totalPrice;
  double? paidPrice;
  String? type;
  List<SparePartIds>? sparePartIds;
  String? location;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.serviceEngineer,
    this.otp,
    this.totalPrice,
    this.paidPrice,
    this.type,
    this.sparePartIds,
    this.location,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceEngineer = json['serviceEngineer'] != null
        ? ServiceEngineer.fromJson(json['serviceEngineer'])
        : null;
    otp = json['Otp'];
    totalPrice = json['totalPrice'] != null
        ? (json['totalPrice'] as num).toDouble()
        : null;
    paidPrice = json['paidPrice'] != null
        ? (json['paidPrice'] as num).toDouble()
        : null;
    type = json['type'];
    if (json['sparePartIds'] != null) {
      sparePartIds = <SparePartIds>[];
      json['sparePartIds'].forEach((v) {
        sparePartIds!.add(SparePartIds.fromJson(v));
      });
    }
    location = json['location'];
    address = json['address'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'serviceEngineer': serviceEngineer?.toJson(),
        'Otp': otp,
        'totalPrice': totalPrice,
        'paidPrice': paidPrice,
        'type': type,
        'sparePartIds': sparePartIds?.map((v) => v.toJson()).toList(),
        'location': location,
        'address': address,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  Data copyWith({
    String? sId,
    ServiceEngineer? serviceEngineer,
    String? otp,
    double? totalPrice,
    double? paidPrice,
    String? type,
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
      otp: otp ?? this.otp,
      totalPrice: totalPrice ?? this.totalPrice,
      paidPrice: paidPrice ?? this.paidPrice,
      type: type ?? this.type,
      sparePartIds: sparePartIds ?? this.sparePartIds,
      location: location ?? this.location,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static Data initial() => Data(
        sId: '',
        serviceEngineer: ServiceEngineer.initial(),
        otp: '',
        totalPrice: 0.0,
        paidPrice: 0.0,
        type: '',
        sparePartIds: [],
        location: '',
        address: '',
        status: '',
        createdAt: '',
        updatedAt: '',
      );
}

class ServiceEngineer {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? role;

  ServiceEngineer({this.sId, this.name, this.email, this.mobile, this.role});

  ServiceEngineer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'role': role,
      };

  ServiceEngineer copyWith({
    String? sId,
    String? name,
    String? email,
    String? mobile,
    String? role,
  }) {
    return ServiceEngineer(
      sId: sId ?? this.sId,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
    );
  }

  static ServiceEngineer initial() => ServiceEngineer(
        sId: '',
        name: '',
        email: '',
        mobile: '',
        role: '',
      );
}

class SparePartIds {
  String? sId;
  String? parentId;
  String? sparePartName;
  String? description;
  List<String>? sparePartImages;
  double? userPrice;
  String? bookingStatus;
  int? price;
  int? quantity;
  int? availableStock;
  DistributorId? distributorId;

  SparePartIds({
    this.sId,
    this.parentId,
    this.sparePartName,
    this.description,
    this.sparePartImages,
    this.userPrice,
    this.bookingStatus,
    this.price,
    this.quantity,
    this.availableStock,
    this.distributorId,
  });

  SparePartIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parentId = json['parentId'];
    sparePartName = json['sparePartName'];
    description = json['description'];
    sparePartImages = json['sparePartImages'].cast<String>();
    userPrice = json['userPrice'] != null
    ? (json['userPrice'] is int
        ? (json['userPrice'] as int).toDouble()
        : json['userPrice'])
        :null;
    bookingStatus = json['bookingStatus'];
    price = json['price'];
    quantity = json['quantity'];
    availableStock = json['availableStock'];
    distributorId = json['distributorId'] != null
        ? DistributorId.fromJson(json['distributorId'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'parentId': parentId,
        'sparePartName': sparePartName,
        'description': description,
        'sparePartImages': sparePartImages,
        'userPrice': userPrice,
        'bookingStatus': bookingStatus,
        'price': price,
        'quantity': quantity,
        'availableStock': availableStock,
        'distributorId': distributorId?.toJson(),
      };

  SparePartIds copyWith({
    String? sId,
    String? parentId,
    String? sparePartName,
    String? description,
    List<String>? sparePartImages,
    double? userPrice,
    String? bookingStatus,
    int? price,
    int? quantity,
    int? availableStock,
    DistributorId? distributorId,
  }) {
    return SparePartIds(
      sId: sId ?? this.sId,
      parentId: parentId ?? this.parentId,
      sparePartName: sparePartName ?? this.sparePartName,
      description: description ?? this.description,
      sparePartImages: sparePartImages ?? this.sparePartImages,
      userPrice: userPrice ?? this.userPrice,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock ?? this.availableStock,
      distributorId: distributorId ?? this.distributorId,
    );
  }

  static SparePartIds initial() => SparePartIds(
        sId: '',
        parentId: '',
        sparePartName: '',
        description: '',
        sparePartImages: [],
        userPrice: 0.0,
        bookingStatus: '',
        price: 0,
        quantity: 0,
        availableStock: 0,
        distributorId: DistributorId.initial(),
      );
}

class DistributorId {
  String? sId;
  String? firmName;
  String? ownerName;

  DistributorId({this.sId, this.firmName, this.ownerName});

  DistributorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firmName = json['firmName'];
    ownerName = json['ownerName'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'firmName': firmName,
        'ownerName': ownerName,
      };

  DistributorId copyWith({
    String? sId,
    String? firmName,
    String? ownerName,
  }) {
    return DistributorId(
      sId: sId ?? this.sId,
      firmName: firmName ?? this.firmName,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  static DistributorId initial() => DistributorId(
        sId: '',
        firmName: '',
        ownerName: '',
      );
}
