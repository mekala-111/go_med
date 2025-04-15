class DistributorProductsModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  DistributorProductsModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  factory DistributorProductsModel.fromJson(Map<String, dynamic> json) {
    return DistributorProductsModel(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: List<String>.from(json['messages'] ?? []),
      data: (json['data'] as List?)?.map((e) => Data.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'messages': messages,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }

  DistributorProductsModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return DistributorProductsModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  static DistributorProductsModel initial() {
    return DistributorProductsModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }
}

class Data {
  String? productId;
  String? productName;
  String? productDescription;
  String? categoryId;
  String? categoryName;
  int? price;
  int? quantity;
  String? adminApproval;
  bool? activated;
  List<String>? productImages;
  List<LinkedSpareParts>? linkedSpareParts;

  Data({
    this.productId,
    this.productName,
    this.productDescription,
    this.categoryId,
    this.categoryName,
    this.price,
    this.quantity,
    this.adminApproval,
    this.activated,
    this.productImages,
    this.linkedSpareParts,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      productId: json['productId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      price: json['price'],
      quantity: json['quantity'],
      adminApproval: json['adminApproval'],
      activated: json['activated'],
      productImages: List<String>.from(json['productImages'] ?? []),
      linkedSpareParts: (json['linkedSpareParts'] as List?)
          ?.map((e) => LinkedSpareParts.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productDescription': productDescription,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'price': price,
      'quantity': quantity,
      'adminApproval': adminApproval,
      'activated': activated,
      'productImages': productImages,
      'linkedSpareParts':
          linkedSpareParts?.map((e) => e.toJson()).toList(),
    };
  }

  Data copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    String? categoryId,
    String? categoryName,
    int? price,
    int? quantity,
    String? adminApproval,
    bool? activated,
    List<String>? productImages,
    List<LinkedSpareParts>? linkedSpareParts,
  }) {
    return Data(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      adminApproval: adminApproval ?? this.adminApproval,
      activated: activated ?? this.activated,
      productImages: productImages ?? this.productImages,
      linkedSpareParts: linkedSpareParts ?? this.linkedSpareParts,
    );
  }

  static Data initial() {
    return Data(
      productId: '',
      productName: '',
      productDescription: '',
      categoryId: '',
      categoryName: '',
      price: 0,
      quantity: 0,
      adminApproval: '',
      activated: false,
      productImages: [],
      linkedSpareParts: [],
    );
  }
}

class LinkedSpareParts {
  String? productId;
  String? parentId;
  String? productName;
  String? productDescription;
  int? price;
  int? quantity;
  List<String>? productImages;
  String? createdAt;
  String? updatedAt;

  LinkedSpareParts({
    this.productId,
    this.parentId,
    this.productName,
    this.productDescription,
    this.price,
    this.quantity,
    this.productImages,
    this.createdAt,
    this.updatedAt,
  });

  factory LinkedSpareParts.fromJson(Map<String, dynamic> json) {
    return LinkedSpareParts(
      productId: json['productId'],
      parentId: json['parentId'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      quantity: json['quantity'],
      productImages: List<String>.from(json['productImages'] ?? []),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'parentId': parentId,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'quantity': quantity,
      'productImages': productImages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  LinkedSpareParts copyWith({
    String? productId,
    String? parentId,
    String? productName,
    String? productDescription,
    int? price,
    int? quantity,
    List<String>? productImages,
    String? createdAt,
    String? updatedAt,
  }) {
    return LinkedSpareParts(
      productId: productId ?? this.productId,
      parentId: parentId ?? this.parentId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      productImages: productImages ?? this.productImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static LinkedSpareParts initial() {
    return LinkedSpareParts(
      productId: '',
      parentId: '',
      productName: '',
      productDescription: '',
      price: 0,
      quantity: 0,
      productImages: [],
      createdAt: '',
      updatedAt: '',
    );
  }
}
