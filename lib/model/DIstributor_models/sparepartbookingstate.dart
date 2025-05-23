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

  SparepartBookingState.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  ServiceEngineer? serviceEngineer;
  String? otp;
  double? totalPrice;
  List<SparePartIds>? sparePartIds;
  String? location;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;
  double? paidPrice;
  String? type;

  Data({
    this.sId,
    this.serviceEngineer,
    this.otp,
    this.totalPrice,
    this.sparePartIds,
    this.location,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.paidPrice,
    this.type,
  });

  factory Data.initial() => Data(
        sId: '',
        serviceEngineer: ServiceEngineer.initial(),
        otp: '',
        totalPrice: 0.0,
        sparePartIds: [],
        location: '',
        address: '',
        status: '',
        createdAt: '',
        updatedAt: '',
        paidPrice: 0.0,
        type: '',
      );

  Data copyWith({
    String? sId,
    ServiceEngineer? serviceEngineer,
    String? otp,
    double? totalPrice,
    List<SparePartIds>? sparePartIds,
    String? location,
    String? address,
    String? status,
    String? createdAt,
    String? updatedAt,
    double? paidPrice,
    String? type,
  }) {
    return Data(
      sId: sId ?? this.sId,
      serviceEngineer: serviceEngineer ?? this.serviceEngineer,
      otp: otp ?? this.otp,
      totalPrice: totalPrice ?? this.totalPrice,
      sparePartIds: sparePartIds ?? this.sparePartIds,
      location: location ?? this.location,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidPrice: paidPrice ?? this.paidPrice,
      type: type ?? this.type,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceEngineer = json['serviceEngineer'] != null
        ? ServiceEngineer.fromJson(json['serviceEngineer'])
        : null;
    otp = json['Otp'];
    totalPrice = (json['totalPrice'] as num?)?.toDouble();
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
    paidPrice = (json['paidPrice'] as num?)?.toDouble();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    if (serviceEngineer != null) {
      data['serviceEngineer'] = serviceEngineer!.toJson();
    }
    data['Otp'] = otp;
    data['totalPrice'] = totalPrice;
    if (sparePartIds != null) {
      data['sparePartIds'] = sparePartIds!.map((v) => v.toJson()).toList();
    }
    data['location'] = location;
    data['address'] = address;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['paidPrice'] = paidPrice;
    data['type'] = type;
    return data;
  }
}

class ServiceEngineer {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  String? role;

  ServiceEngineer({this.sId, this.name, this.email, this.mobile, this.role});

  factory ServiceEngineer.initial() => ServiceEngineer(
        sId: '',
        name: '',
        email: '',
        mobile: '',
        role: '',
      );

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

  ServiceEngineer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['role'] = role;
    return data;
  }
}

class SparePartIds {
  String? sId;
  String? parentId;
  String? sparePartName;
  String? description;
  List<String>? sparePartImages;
  String? bookingStatus;
  int? price;
  int? quantity;
  int? availableStock;
  DistributorId? distributorId;
  double? userPrice;

  SparePartIds({
    this.sId,
    this.parentId,
    this.sparePartName,
    this.description,
    this.sparePartImages,
    this.bookingStatus,
    this.price,
    this.quantity,
    this.availableStock,
    this.distributorId,
    this.userPrice,
  });

  factory SparePartIds.initial() => SparePartIds(
        sId: '',
        parentId: '',
        sparePartName: '',
        description: '',
        sparePartImages: [],
        bookingStatus: '',
        price: 0,
        quantity: 0,
        availableStock: 0,
        distributorId: DistributorId.initial(),
        userPrice: 0.0,
      );

  SparePartIds copyWith({
    String? sId,
    String? parentId,
    String? sparePartName,
    String? description,
    List<String>? sparePartImages,
    String? bookingStatus,
    int? price,
    int? quantity,
    int? availableStock,
    DistributorId? distributorId,
    double? userPrice,
  }) {
    return SparePartIds(
      sId: sId ?? this.sId,
      parentId: parentId ?? this.parentId,
      sparePartName: sparePartName ?? this.sparePartName,
      description: description ?? this.description,
      sparePartImages: sparePartImages ?? this.sparePartImages,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      availableStock: availableStock ?? this.availableStock,
      distributorId: distributorId ?? this.distributorId,
      userPrice: userPrice ?? this.userPrice,
    );
  }

  SparePartIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parentId = json['parentId'];
    sparePartName = json['sparePartName'];
    description = json['description'];
    sparePartImages = json['sparePartImages']?.cast<String>();
    bookingStatus = json['bookingStatus'];
    price = json['price'];
    quantity = json['quantity'];
    availableStock = json['availableStock'];
    distributorId = json['distributorId'] != null
        ? DistributorId.fromJson(json['distributorId'])
        : null;
    userPrice = (json['userPrice'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['parentId'] = parentId;
    data['sparePartName'] = sparePartName;
    data['description'] = description;
    data['sparePartImages'] = sparePartImages;
    data['bookingStatus'] = bookingStatus;
    data['price'] = price;
    data['quantity'] = quantity;
    data['availableStock'] = availableStock;
    if (distributorId != null) {
      data['distributorId'] = distributorId!.toJson();
    }
    data['userPrice'] = userPrice;
    return data;
  }
}

class DistributorId {
  String? sId;
  String? firmName;
  String? ownerName;

  DistributorId({this.sId, this.firmName, this.ownerName});

  factory DistributorId.initial() => DistributorId(
        sId: '',
        firmName: '',
        ownerName: '',
      );

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

  DistributorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firmName = json['firmName'];
    ownerName = json['ownerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['firmName'] = firmName;
    data['ownerName'] = ownerName;
    return data;
  }
}
