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

  SparepartBookingState.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    messages = json['messages'] != null ? List<String>.from(json['messages']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'success': success,
        'messages': messages,
        'data': data?.map((v) => v.toJson()).toList(),
      };
}

class Data {
  String? sId;
  ServiceEngineer? serviceEngineer;
  List<SparePartIds>? sparePartIds;
  String? location;
  String? address;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.serviceEngineer,
    this.sparePartIds,
    this.location,
    this.address,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.initial() => Data(
        sId: '',
        serviceEngineer: ServiceEngineer.initial(),
        sparePartIds: [],
        location: '',
        address: '',
        status: '',
        createdAt: '',
        updatedAt: '',
      );

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    serviceEngineer = json['serviceEngineer'] != null
        ? ServiceEngineer.fromJson(json['serviceEngineer'])
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
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'serviceEngineer': serviceEngineer?.toJson(),
        'sparePartIds': sparePartIds?.map((v) => v.toJson()).toList(),
        'location': location,
        'address': address,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}

class ServiceEngineer {
  String? sId;
  String? name;
  String? email;
  String? mobile;
  List<String>? profileImage;
  String? role;

  ServiceEngineer({
    this.sId,
    this.name,
    this.email,
    this.mobile,
    this.profileImage,
    this.role,
  });

  factory ServiceEngineer.initial() => ServiceEngineer(
        sId: '',
        name: '',
        email: '',
        mobile: '',
        profileImage: [],
        role: '',
      );

  ServiceEngineer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profileImage'] != null
        ? List<String>.from(json['profileImage'])
        : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'profileImage': profileImage,
        'role': role,
      };
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
      );

  SparePartIds.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    parentId = json['parentId'];
    sparePartName = json['sparePartName'];
    description = json['description'];
    sparePartImages = json['sparePartImages'] != null
        ? List<String>.from(json['sparePartImages'])
        : null;
    bookingStatus = json['bookingStatus'];
    price = json['price'];
    quantity = json['quantity'];
    availableStock = json['availableStock'];
  }

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'parentId': parentId,
        'sparePartName': sparePartName,
        'description': description,
        'sparePartImages': sparePartImages,
        'bookingStatus': bookingStatus,
        'price': price,
        'quantity': quantity,
        'availableStock': availableStock,
      };
}
