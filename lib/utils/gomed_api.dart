class Bbapi {
  static const String baseUrl = "http://97.74.93.26:3000";


  static const String login = "$baseUrl/distributor/login";
  static const String signup = "$baseUrl/distributor/signup";
  static const String refreshToken = "$baseUrl/auth/refresh-token";


  static const String add = "$baseUrl/products/create/product";
  static const String getProduct = "$baseUrl/products/distributor/products";
  static const String update = "$baseUrl/products/updateproduct";
  static const String delete = "$baseUrl/products/deleteproduct";
  static const String serviceEngineerupdate ="$baseUrl/distributor/updateServiceEngineer";
  static const String serviceEngineerdelete ="$baseUrl/distributor/deleteServiceEngineer";
  static const String serviceEngineerProducts ="$baseUrl/products/getallproducts";
  static const String getServiceengineers = "$baseUrl/admin/service-engineers";
  static const String serviceEnginnerProductsApproved = "$baseUrl/products/products/approved";
  static const String bookingSparepart = "$baseUrl/sparepartsBooking/create";
  static const String getSparepartBooking = "$baseUrl/sparepartsBooking/list";
  static const String deleteSparepartBooking ="$baseUrl/sparepartsBooking/delete";
  static const String serviceenginnerBookingServices ="$baseUrl /servicebooking/list";
 
  
  static const String updateProfile = "$baseUrl/distributor/update";
  static const String deleteAccount = "$baseUrl/distributor/delete";

  static const String sparepartAdd = "$baseUrl/spareparts/add";
  static const String sparepartGet = "$baseUrl/spareparts/list";
  static const String sparepartupdate = "$baseUrl/spareparts/update";
  static const String sparepartdelete = "$baseUrl/spareparts/delete";
  static const String serviceAdd = "$baseUrl/services/createservice";
  static const String getService = "$baseUrl/services/getallservices";//serviceenginner
  static const String serviceupdate = "$baseUrl/services/updateservice";
  static const String deleteService = "$baseUrl/services/deleteservice";
  static const String bookingsGet = "$baseUrl/productbooking/distributor";
  static const String bookingUpdate = "$baseUrl/productbooking/update";
  
  static const String distributorProducts = "$baseUrl/products/adminAddProducts";
  static const String quantityParts = "$baseUrl/products/products/all";
  static const String requestProduct="$baseUrl/products/distributor/request-product";
  static const String requestAceeptedProducts="$baseUrl/products/requested-products";

}
