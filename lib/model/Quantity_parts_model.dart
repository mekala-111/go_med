class QuantityPartsModel {
  int? statusCode;
  bool? success;
  List<String>? messages;
  List<Data>? data;

  QuantityPartsModel({this.statusCode, this.success, this.messages, this.data});

  // From JSON
  QuantityPartsModel.fromJson(Map<String, dynamic> json) {
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

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['success'] = this.success;
    data['messages'] = this.messages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  // Copy with method
  QuantityPartsModel copyWith({
    int? statusCode,
    bool? success,
    List<String>? messages,
    List<Data>? data,
  }) {
    return QuantityPartsModel(
      statusCode: statusCode ?? this.statusCode,
      success: success ?? this.success,
      messages: messages ?? this.messages,
      data: data ?? this.data,
    );
  }

  // Initial method (default values)
  static QuantityPartsModel initial() {
    return QuantityPartsModel(
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
  String? firmName;
  String? ownerName;
  String? productName;
  String? productDescription;
  double? price;  // This expects a double
  String? category;
  List<SpareParts>? spareParts;
  List<String>? productImages;
  bool? activated;

  Data({
    this.productId,
    this.distributorId,
    this.firmName,
    this.ownerName,
    this.productName,
    this.productDescription,
    this.price,
    this.category,
    this.spareParts,
    this.productImages,
    this.activated,
  });

  // From JSON
  Data.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    distributorId = json['distributorId'];
    firmName = json['firmName'];
    ownerName = json['ownerName'];
    productName = json['productName'];
    productDescription = json['productDescription'];
    
    // Ensure the price is always a double
    price = json['price'] is int ? (json['price'] as int).toDouble() : json['price']?.toDouble();
    
    category = json['category'];
    if (json['spareParts'] != null) {
      spareParts = <SpareParts>[];
      json['spareParts'].forEach((v) {
        spareParts!.add(SpareParts.fromJson(v));
      });
    }
    productImages = json['productImages'].cast<String>();
    activated = json['activated'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productId'] = this.productId;
    data['distributorId'] = this.distributorId;
    data['firmName'] = this.firmName;
    data['ownerName'] = this.ownerName;
    data['productName'] = this.productName;
    data['productDescription'] = this.productDescription;
    data['price'] = this.price;
    data['category'] = this.category;
    if (this.spareParts != null) {
      data['spareParts'] = this.spareParts!.map((v) => v.toJson()).toList();
    }
    data['productImages'] = this.productImages;
    data['activated'] = this.activated;
    return data;
  }

  // Copy with method
  Data copyWith({
    String? productId,
    String? distributorId,
    String? firmName,
    String? ownerName,
    String? productName,
    String? productDescription,
    double? price,
    String? category,
    List<SpareParts>? spareParts,
    List<String>? productImages,
    bool? activated,
  }) {
    return Data(
      productId: productId ?? this.productId,
      distributorId: distributorId ?? this.distributorId,
      firmName: firmName ?? this.firmName,
      ownerName: ownerName ?? this.ownerName,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      price: price ?? this.price,
      category: category ?? this.category,
      spareParts: spareParts ?? this.spareParts,
      productImages: productImages ?? this.productImages,
      activated: activated ?? this.activated,
    );
  }

  // Initial method (default values)
  static Data initial() {
    return Data(
      productId: '',
      distributorId: '',
      firmName: '',
      ownerName: '',
      productName: '',
      productDescription: '',
      price: 0.0,
      category: '',
      spareParts: [],
      productImages: [],
      activated: false,
    );
  }
}

class SpareParts {
  String? s0;
  String? s1;
  String? s2;
  String? s3;
  List<String>? sparePartImages;
  String? sparepartId;
  String? sparepartName;
  String? description;
  String? sId;
  double? sparepartPrice;  // This expects a double
  int? sparepartQuantity;

  SpareParts({
    this.s0,
    this.s1,
    this.s2,
    this.s3,
    this.sparePartImages,
    this.sparepartId,
    this.sparepartName,
    this.description,
    this.sId,
    this.sparepartPrice,
    this.sparepartQuantity,
  });

  // From JSON
  SpareParts.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    sparePartImages = json['sparePartImages'].cast<String>();
    sparepartId = json['sparepartId'];
    sparepartName = json['sparepartName'];
    description = json['description'];
    sId = json['_id'];
    
    // Ensure the sparepartPrice is always a double
    sparepartPrice = json['sparepartPrice'] is int
        ? (json['sparepartPrice'] as int).toDouble()
        : json['sparepartPrice']?.toDouble();
    
    sparepartQuantity = json['sparepartQuantity'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['0'] = this.s0;
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['sparePartImages'] = this.sparePartImages;
    data['sparepartId'] = this.sparepartId;
    data['sparepartName'] = this.sparepartName;
    data['description'] = this.description;
    data['_id'] = this.sId;
    data['sparepartPrice'] = this.sparepartPrice;
    data['sparepartQuantity'] = this.sparepartQuantity;
    return data;
  }

  // Copy with method
  SpareParts copyWith({
    String? s0,
    String? s1,
    String? s2,
    String? s3,
    List<String>? sparePartImages,
    String? sparepartId,
    String? sparepartName,
    String? description,
    String? sId,
    double? sparepartPrice,  // Use double here
    int? sparepartQuantity,
  }) {
    return SpareParts(
      s0: s0 ?? this.s0,
      s1: s1 ?? this.s1,
      s2: s2 ?? this.s2,
      s3: s3 ?? this.s3,
      sparePartImages: sparePartImages ?? this.sparePartImages,
      sparepartId: sparepartId ?? this.sparepartId,
      sparepartName: sparepartName ?? this.sparepartName,
      description: description ?? this.description,
      sId: sId ?? this.sId,
      sparepartPrice: sparepartPrice ?? this.sparepartPrice,
      sparepartQuantity: sparepartQuantity ?? this.sparepartQuantity,
    );
  }

  // Initial method (default values)
  static SpareParts initial() {
    return SpareParts(
      s0: '',
      s1: '',
      s2: '',
      s3: '',
      sparePartImages: [],
      sparepartId: '',
      sparepartName: '',
      description: '',
      sId: '',
      sparepartPrice: 0.0,  // Default to 0.0
      sparepartQuantity: 0,
    );
  }
}
