class AdminAprovedProducts {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  AdminAprovedProducts
({this.statusCode, this.success, this.messages, this.data});

  factory AdminAprovedProducts
.initial() {
    return AdminAprovedProducts
  (
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  AdminAprovedProducts
 copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return AdminAprovedProducts
  (
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  AdminAprovedProducts
.fromJson(Map<String, dynamic> json) {
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
  String? distributorId;
  String? productId;
  String? parentId;
  int? price;
  int? quantity;
  String? adminApproval;
  bool? activated;
  String? productName;
  String? categoryId;
  String? categoryName;

  Data({
    this.distributorId,
    this.productId,
    this.parentId,
    this.price,
    this.quantity,
    this.adminApproval,
    this.activated,
    this.productName,
    this.categoryId,
    this.categoryName,
  });

  factory Data.initial() {
    return Data(
      distributorId: '',
      productId: '',
      parentId: '',
      price: 0,
      quantity: 0,
      adminApproval: '',
      activated: false,
      productName: '',
      categoryId: '',
      categoryName: '',
    );
  }

  Data copyWith({
    String? distributorId,
    String? productId,
    String? parentId,
    int? price,
    int? quantity,
    String? adminApproval,
    bool? activated,
    String? productName,
    String? categoryId,
    String? categoryName,
  }) {
    return Data(
      distributorId: distributorId ?? this.distributorId,
      productId: productId ?? this.productId,
      parentId: parentId ?? this.parentId,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      adminApproval: adminApproval ?? this.adminApproval,
      activated: activated ?? this.activated,
      productName: productName ?? this.productName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  Data.fromJson(Map<String, dynamic> json) {
    distributorId = json['distributorId'];
    productId = json['productId'];
    parentId = json['parentId'];
    price = json['price'];
    quantity = json['quantity'];
    adminApproval = json['adminApproval'];
    activated = json['activated'];
    productName = json['productName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['distributorId'] = distributorId;
    data['productId'] = productId;
    data['parentId'] = parentId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['adminApproval'] = adminApproval;
    data['activated'] = activated;
    data['productName'] = productName;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    return data;
  }
}
