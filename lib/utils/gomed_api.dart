class Bbapi {
  static const String baseUrl = "http://97.74.93.26:3000";

  static const String login = "$baseUrl/distributor/login";
  static const String signup = "$baseUrl/distributor/distributor/signup";
  static const String add = "$baseUrl/products/create/product";
  static const String getProduct = "$baseUrl/products/products";
  static const String update = "$baseUrl/products/updateproduct";
  static const String delete = "$baseUrl/products/deleteproduct";
  static const String refreshToken = "$baseUrl/refresh-token";
  static const String updateProfile = "$baseUrl/distributor/update";
  static const String deleteAccount = "$baseUrl/distributor/delete";
  static const String sparepartAdd = "$baseUrl/spareparts/add";
  static const String serviceAdd = "$baseUrl/services/createservice";
   static const String getService = "$baseUrl/services/getservices";
    static const String serviceupdate= "$baseUrl/services/updateservice";
     static const String deleteService = "$baseUrl/services/deleteservice";
}
