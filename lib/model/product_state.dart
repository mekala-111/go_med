class ProductModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  ProductModel({this.statusCode, this.success, this.messages, this.data});

  // fromJson method
  ProductModel.fromJson(Map<String, dynamic> json) {
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

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // copyWith method
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

  // initial method (providing default values)
  static ProductModel initial() {
    return ProductModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }
}

class Data {
  String? productId;
  String? distributorId;
  String? productName;
  String? productDescription;
  int? price;
  String? category;
  bool? spareParts;
  String? productImage;

  Data({
    this.productId,
    this.distributorId,
    this.productName,
    this.productDescription,
    this.price,
    this.category,
    this.spareParts,
    this.productImage,
  });

  // fromJson method
  Data.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    distributorId = json['distributorId'];
    productName = json['productName'];
    productDescription = json['productDescription'];

    var priceValue = json['price'];
    if (priceValue is double) {
      // If price is a double, convert it to int
      price = priceValue.toInt();
    } else if (priceValue is int) {
      // If price is an int, use it directly
      price = priceValue;
    } else {
      price = 0; // Default value if the price is not found or invalid
    }

    category = json['category'];
    spareParts = json['spareParts'] == "true" ? true : false;
    productImage = json['productImage'];
  }

  // toJson method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = this.productId;
    data['distributorId'] = this.distributorId;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['price'] = this.price;  // Ensure correct price handling
    data['category'] = this.category;
    data['spareParts'] = this.spareParts;
    data['productImage'] = this.productImage;
    return data;
  }

  // copyWith method
  Data copyWith({
    String? productId,
    String? distributorId,
    String? productName,
    String? productDescription,
    int? price,
    String? category,
    bool? spareParts,
    String? productImage,
  }) {
    return Data(
      productId: productId ?? this.productId,
      distributorId: distributorId ?? this.distributorId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      price: price ?? this.price,
      category: category ?? this.category,
      spareParts: spareParts ?? this.spareParts,
      productImage: productImage ?? this.productImage,
    );
  }

  // initial method (providing default values)
  static Data initial() {
    return Data(
      productId: '',
      distributorId: '',
      productName: '',
      productDescription: '',
      price: 0,
      category: '',
      spareParts: false,
      productImage: '',
    );
  }
}
