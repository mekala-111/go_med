class SparepartBookingState {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  SparepartBookingState({this.statusCode, this.success, this.messages, this.data});

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

  static SparepartBookingState initial() => SparepartBookingState(
        statusCode: null,
        success: null,
        messages: [],
        data: [],
      );

  SparepartBookingState.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = {};
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['messages'] = this.messages;
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
  dynamic paidPrice;
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
    dynamic paidPrice,
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

  static Data initial() => Data(
        sId: null,
        serviceEngineer: ServiceEngineer.initial(),
        otp: '',
        totalPrice: 0.0,
        sparePartIds: [],
        location: '',
        address: '',
        status: '',
        createdAt: '',
        updatedAt: '',
        paidPrice: null,
        type: '',
      );

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceEngineer = json['serviceEngineer'] != null
        ? ServiceEngineer.fromJson(json['serviceEngineer'])
        : null;
    otp = json['Otp'];
    totalPrice = (json['totalPrice'] != null)
        ? double.tryParse(json['totalPrice'].toString())
        : null;
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
    paidPrice = json['paidPrice'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    if (this.serviceEngineer != null) {
      data['serviceEngineer'] = this.serviceEngineer!.toJson();
    }
    data['Otp'] = this.otp;
    data['totalPrice'] = this.totalPrice;
    if (this.sparePartIds != null) {
      data['sparePartIds'] =
          this.sparePartIds!.map((v) => v.toJson()).toList();
    }
    data['location'] = this.location;
    data['address'] = this.address;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['paidPrice'] = this.paidPrice;
    data['type'] = this.type;
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

  ServiceEngineer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['role'] = this.role;
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
  });

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
    );
  }

  static SparePartIds initial() => SparePartIds(
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
      );

  SparePartIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parentId = json['parentId'];
    sparePartName = json['sparePartName'];
    description = json['description'];
    sparePartImages = json['sparePartImages'].cast<String>();
    bookingStatus = json['bookingStatus'];
    price = json['price'];
    quantity = json['quantity'];
    availableStock = json['availableStock'];
    distributorId = json['distributorId'] != null
        ? DistributorId.fromJson(json['distributorId'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    data['parentId'] = this.parentId;
    data['sparePartName'] = this.sparePartName;
    data['description'] = this.description;
    data['sparePartImages'] = this.sparePartImages;
    data['bookingStatus'] = this.bookingStatus;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['availableStock'] = this.availableStock;
    if (this.distributorId != null) {
      data['distributorId'] = this.distributorId!.toJson();
    }
    return data;
  }
}

class DistributorId {
  String? sId;
  String? firmName;
  String? ownerName;

  DistributorId({this.sId, this.firmName, this.ownerName});

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

  DistributorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    firmName = json['firmName'];
    ownerName = json['ownerName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = this.sId;
    data['firmName'] = this.firmName;
    data['ownerName'] = this.ownerName;
    return data;
  }
}
