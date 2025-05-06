

class BookingModel {
  final int statusCode;
  final bool success;
  final List<String> messages;
  final List<BookingData> data;

  BookingModel({
    required this.statusCode,
    required this.success,
    required this.messages,
    required this.data,
  });

  /// ✅ **Initial method to provide default values**
  factory BookingModel.initial() {
    return BookingModel(
      statusCode: 0,
      success: false,
      messages: [],
      data: [],
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      statusCode: json['statusCode'] ?? 0,
      success: json['success'] ?? false,
      messages: List<String>.from(json['messages'] ?? []),
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => BookingData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class BookingData {
  final String id;
  final User userId;
  final List<Product> productIds;
   String? location;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  BookingData({
    required this.id,
    required this.userId,
    required this.productIds,
   this.location,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['_id'] ?? '',
      userId: User.fromJson(json['userId'] ?? {}),
      productIds: (json['productIds'] as List<dynamic>?)
              ?.map((item) => Product.fromJson(item))
              .toList() ??
          [],
       location: json['location'] ?? 'No Location',  // ✅ FIXED
      address: json['address'] ?? 'No Address',  // ✅ FIXED
      status: json['status'] ?? 'Pending',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  BookingData copyWith({
    String? id,
    User? userId,
    List<Product>? productIds,
    String? status,
  }) {
    return BookingData(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productIds: productIds ?? this.productIds,
      status: status ?? this.status,
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final List<String> profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      profileImage: (json['profileImage'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class Product {
  final String id;
  final String productName;
  final String productDescription;
  final int price;
  int? quantity;
  final String category;
  final bool spareParts;
  final List<String> productImages;
  final String distributorId;
  String? bookingStatus;

  Product({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.quantity,
    required this.category,
    required this.spareParts,
    required this.productImages,
    required this.distributorId,
    required this.bookingStatus
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      productName: json['productName'] ?? 'N/A',
      productDescription: json['productDescription'] ?? 'N/A',
      price: json['price'] ?? 0,
      bookingStatus : json['bookingStatus']?? 'N/A',
      quantity:json['quantity'] ?? 0,
      category: json['category'] ?? 'N/A',
      spareParts: json['spareParts'] == "true",
      productImages: (json['productImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [], distributorId: '',
      // distributorId: Distributor.fromJson(json['distributorId'] ?? {}),
    );
  }
}

class Distributor {
  final String id;
  final String firmName;
  final String ownerName;

  Distributor({
    required this.id,
    required this.firmName,
    required this.ownerName,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: json['_id'] ?? '',
      firmName: json['firmName'] ?? 'Unknown',
      ownerName: json['ownerName'] ?? 'Unknown Owner',
    );
  }
}
