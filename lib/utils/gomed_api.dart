// class GomedApi {
//   final String baseUrl = "http://68.178.165.167:8000/";
//   final String endpointname = "endpoint";
// }
class Bbapi {
  static const String baseUrl = "http://97.74.93.26:3000";

  static const String login = "$baseUrl/user/login";
  static const String signup = "$baseUrl/user/signup";
  static const String add = "$baseUrl/products/create/product";
  static const String getProduct = "$baseUrl/products/products";
  static const String update = "$baseUrl/products/updateproduct";
  static const String delete = "$baseUrl/products/deleteproduct";
  static const String refreshToken = "$baseUrl/refresh-token";
  static const String updateProfile = "$baseUrl/user/updateProfile";
  static const String deleteAccount = "$baseUrl/user/deleteProfile";
}
