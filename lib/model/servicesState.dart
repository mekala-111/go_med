class ServiceModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  Data? data;

  ServiceModel({this.statusCode, this.success, this.messages, this.data});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages']?.cast<String>();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['messages'] = messages;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  ServiceModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    Data? data,
  }) {
    return ServiceModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  static ServiceModel initial() {
    return ServiceModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: Data.initial(),
    );
  }
}

class Data {
  String? name;
  String? details;
  int? price;
  String? distributorId;
  List<String>? productIds;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.name,
    this.details,
    this.price,
    this.distributorId,
    this.productIds,
    this.sId,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    details = json['details'];
    price = json['price'];
    distributorId = json['distributorId'];
    productIds = json['productIds']?.cast<String>();
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['details'] = details;
    data['price'] = price;
    data['distributorId'] = distributorId;
    data['productIds'] = productIds;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }

  Data copyWith({
    String? name,
    String? details,
    int? price,
    String? distributorId,
    List<String>? productIds,
    String? sId,
    String? createdAt,
    String? updatedAt,
    int? iV,
  }) {
    return Data(
      name: name ?? this.name,
      details: details ?? this.details,
      price: price ?? this.price,
      distributorId: distributorId ?? this.distributorId,
      productIds: productIds ?? this.productIds,
      sId: sId ?? this.sId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      iV: iV ?? this.iV,
    );
  }

  static Data initial() {
    return Data(
      name: '',
      details: '',
      price: 0,
      distributorId: '',
      productIds: [],
      sId: '',
      createdAt: '',
      updatedAt: '',
      iV: 0,
    );
  }
}
