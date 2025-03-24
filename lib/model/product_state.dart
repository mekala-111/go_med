

class ProductModel  {
  final int? statusCode;
  final bool? success;
  final List<String>? messages;
  final List<Data>? data;

  const ProductModel({
    this.statusCode,
    this.success,
    this.messages,
    this.data,
  });

  // ✅ Initial State
  factory ProductModel.initial() {
    return const ProductModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  // ✅ CopyWith method
  ProductModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return ProductModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  // ✅ JSON Serialization
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      statusCode: json['statusCode'],
      success: json['success'],
      messages: List<String>.from(json['messages'] ?? []),
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((x) => Data.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'success': success,
      'messages': messages,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [statusCode, success, messages, data];
}

// 🌟 Data Class
class Data {
  final String? productId;
  final String? distributorId;
  final String? firmName;
  final String? productName;
  final String? productDescription;
  final int? price;
  final String? category;
  final String? spareParts;
  final List<String>? productImages;
  final bool? activated;

  const Data({
    this.productId,
    this.distributorId,
    this.firmName,
    this.productName,
    this.productDescription,
    this.price,
    this.category,
    this.spareParts,
    this.productImages,
    this.activated,
  });

  // ✅ Initial State
  factory Data.initial() {
    return const Data(
      productId: '',
      distributorId: '',
      firmName: '',
      productName: '',
      productDescription: '',
      price: 0,
      category: '',
      spareParts: '',
      productImages: [],
      activated: false,
    );
  }

  // ✅ CopyWith method
  Data copyWith({
    String? productId,
    String? distributorId,
    String? firmName,
    String? productName,
    String? productDescription,
    int? price,
    String? category,
    String? spareParts,
    List<String>? productImages,
    bool? activated,
  }) {
    return Data(
      productId: productId ?? this.productId,
      distributorId: distributorId ?? this.distributorId,
      firmName: firmName ?? this.firmName,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      price: price ?? this.price,
      category: category ?? this.category,
      spareParts: spareParts ?? this.spareParts,
      productImages: productImages ?? this.productImages,
      activated: activated ?? this.activated,
    );
  }

  // ✅ JSON Serialization
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      productId: json['productId'],
      distributorId: json['distributorId'],
      firmName: json['firmName'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      price: json['price'],
      category: json['category'],
      spareParts: json['spareParts'],
      productImages: List<String>.from(json['productImages'] ?? []),
      activated: json['activated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'distributorId': distributorId,
      'firmName': firmName,
      'productName': productName,
      'productDescription': productDescription,
      'price': price,
      'category': category,
      'spareParts': spareParts,
      'productImages': productImages,
      'activated': activated,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        distributorId,
        firmName,
        productName,
        productDescription,
        price,
        category,
        spareParts,
        productImages,
        activated,
      ];
}
