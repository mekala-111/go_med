class ServiceEngineerProductsModel
 {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  ServiceEngineerProductsModel
  ({this.statusCode, this.success, this.messages, this.data});

  factory ServiceEngineerProductsModel
  .fromJson(Map<String, dynamic> json) {
    return ServiceEngineerProductsModel
    (
      statusCode: json['statusCode'],
      success: json['success'],
      messages: json['messages']?.cast<String>(),
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
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

  /// ✅ Initial state
  factory ServiceEngineerProductsModel
  .initial() {
    return ServiceEngineerProductsModel
    (
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  /// ✅ Copy with method
  ServiceEngineerProductsModel
   copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return ServiceEngineerProductsModel
    (
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }
}

class Data {
  String? distributorId;
  String? productId;
  String? parentId;
  String? productName;
  String? productDescription;
  String? categoryId;
  String? categoryName;
  int? price;
  int? quantity;
  List<String>? productImages;
  String? adminApproval;
  bool? activated;

  Data({
    this.distributorId,
    this.productId,
    this.parentId,
    this.productName,
    this.productDescription,
    this.categoryId,
    this.categoryName,
    this.price,
    this.quantity,
    this.productImages,
    this.adminApproval,
    this.activated,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      distributorId: json['distributorId'],
      productId: json['productId'],
      parentId: json['parentId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      price: json['price'],
      quantity: json['quantity'],
      productImages: json['productImages']?.cast<String>(),
      adminApproval: json['adminApproval'],
      activated: json['activated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distributorId': distributorId,
      'productId': productId,
      'parentId': parentId,
      'productName': productName,
      'productDescription': productDescription,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'quantity': quantity,
      'productImages': productImages,
      'adminApproval': adminApproval,
      'activated': activated,
    };
  }

  /// ✅ Initial state
  factory Data.initial() {
    return Data(
      distributorId: '',
      productId: '',
      parentId: '',
      productName: '',
      productDescription: '',
      categoryId: '',
      categoryName: '',
      price: 0,
      quantity: 0,
      productImages: [],
      adminApproval: '',
      activated: false,
    );
  }

  /// ✅ Copy with method
  Data copyWith({
    String? distributorId,
    String? productId,
    String? parentId,
    String? productName,
    String? productDescription,
    String? categoryId,
    String? categoryName,
    int? price,
    int? quantity,
    List<String>? productImages,
    String? adminApproval,
    bool? activated,
  }) {
    return Data(
      distributorId: distributorId ?? this.distributorId,
      productId: productId ?? this.productId,
      parentId: parentId ?? this.parentId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productImages: productImages ?? this.productImages,
      adminApproval: adminApproval ?? this.adminApproval,
      activated: activated ?? this.activated,
    );
  }
}
