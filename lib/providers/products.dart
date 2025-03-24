import 'dart:convert';
import 'dart:io';

import 'package:go_med/model/sparepartState.dart';

import '../providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import '../utils/gomed_api.dart';
import '../model/product_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/login_auth_state.dart';
// import '../states/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../model/product_state.dart';
import '../providers/loader.dart';
import 'package:http/retry.dart';
import 'package:http_parser/http_parser.dart';
import 'package:go_med/providers/sparepartProvider.dart';


class ProductProvider extends StateNotifier<ProductModel> {
  final Ref ref; // To access other providers
  ProductProvider(this.ref) : super((ProductModel.initial()));

  // Function to add a product and handle the response
  Future<void> addProduct(
      String? productName,
      String? description,
      double? price,
      String category,
      List<File>? image,
      String? spareParts) async {
    final loadingState = ref.read(loadingProvider.notifier);
    print(
        'data...===== $productName,$description,$price,${image?.length},$spareParts,$category');
    try {
      loadingState.state = true;
      print('products..................................$productName');
      // Print images
      if (image != null && image.isNotEmpty) {
        print("Images:");
        for (var i = 0; i < image.length; i++) {
          print("Image ${i + 1}: Path = ${image[i].path}");
        }
      } else {
        print("No images available.");
      }
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');
      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 400 ||
            response.statusCode == 401, // Retry on 401 Unauthorized
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && res?.statusCode == 400 ||
              res?.statusCode == 401) {
            // Handle token restoration logic on the first retry
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            print('Restored Token:++++++++++ $newAccessToken');
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // Creating a Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(Bbapi.add))
        ..headers.addAll({
          "Authorization": "Bearer $token",
          "Content-Type": "multipart/form-data"
        })
        ..fields['productName'] = productName ?? ""
        ..fields['productDescription'] = description ?? ""
        ..fields['price'] = price != null ? price.toString() : "0.0"
        ..fields['category'] = category
        ..fields['spareParts'] = 'false';

      // Adding Image File if Present
      if (image != null && image.isNotEmpty) {
        for (var img in image) {
          final fileExtension = img.path.split('.').last.toLowerCase();

          final contentType = MediaType('image', fileExtension);

          request.files.add(await http.MultipartFile.fromPath(
            'productImages[]', // Ensure this matches the expected field name
            img.path,
            contentType: contentType, // Adjust for actual file type
          ));
        }
      }

      // Sending Request
      // final response = await request.send();
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);
      // Reading Response
      // final responseBody = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      try {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        // Continue with the usual process
      } catch (e) {
        print('Error decoding response body: $e');
        // Handle error or throw an exception
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Product added successfully!");
        getProducts(); // Refresh product list
        ref.watch(sparepartProvider.notifier).getSpareParts(); 
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error adding product: $errorMessage");
      }
    } catch (error) {
      print("Failed to add product: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<void> getProducts() async {
    final loadingState = ref.read(loadingProvider.notifier);
    final productState = ref.read(productProvider.notifier);

    try {
      loadingState.state = true;

      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 400,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 400)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // Sending the GET request
      final response = await client.get(
        Uri.parse(Bbapi.getProduct),
        headers: {
          "Authorization": "Bearer $token",
        },
      );
      // .timeout(const Duration(seconds: 10)); // Adding timeout

      // Handle response
      final responseBody = response.body;
      print('Get Products Status Code: ${response.statusCode}');
      print('Get Products Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('inside if condition----------');
        final res = json.decode(responseBody);
        // Check if the response body contains the necessary data
        // if (res.isEmpty || !res.containsKey('data')) {
        //   throw Exception("No data found in the response.");
        // }
        final productData = ProductModel.fromJson(res);
        state = productData;

        // if (productData.data == null || productData.data!.isEmpty) {
        //   throw Exception("No products found.");
        // }

        // Update product state
        // productState.state = productData.data!;
        print("Products fetched successfully.$productData");
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(responseBody);
        final errorMessage =
            errorBody['message'] ?? "Unexpected error occurred.";
        throw Exception("Error fetching products: $errorMessage");
      }
    } catch (error) {
      print("Failed to fetch products: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<bool> updateProduct(
    String? productName,
    String? description,
    double? price,
    String? category,
    String? productId,
    List<File>? image,
  ) async {
    final loadingState = ref.read(loadingProvider.notifier);
    loadingState.state = true;
     print('productupdate data productNamename:$productName,description:$description,price:$price,image:$image,productIdId:$productId');

    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? userDataString = prefs.getString('userData');

      if (userDataString == null || userDataString.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }

      final Map<String, dynamic> userData = jsonDecode(userDataString);
      String? token = userData['accessToken'];

      if (token == null || token.isEmpty) {
        token = userData['data'] != null &&
                (userData['data'] as List).isNotEmpty &&
                userData['data'][0]['access_token'] != null
            ? userData['data'][0]['access_token']
            : null;
      }

      if (token == null || token.isEmpty) {
        throw Exception("User token is invalid. Please log in again.");
      }

      print('Retrieved Token: $token');

      // Initialize RetryClient for handling retries
      final client = RetryClient(
        http.Client(),
        retries: 3, // Retry up to 3 times
        when: (response) =>
            response.statusCode == 401 || response.statusCode == 404,
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 &&
              (res?.statusCode == 401 || res?.statusCode == 404)) {
            String? newAccessToken =
                await ref.read(loginProvider.notifier).restoreAccessToken();
            req.headers['Authorization'] = 'Bearer $newAccessToken';
          }
        },
      );

      // Creating a Multipart Request
      var request =
          http.MultipartRequest('PUT', Uri.parse("${Bbapi.update}/$productId"))
            ..headers.addAll({
              "Authorization": "Bearer $token",
            })
            ..fields['productName'] = productName ?? ""
            ..fields['productDescription'] = description ?? ""
            ..fields['price'] = price != null ? price.toString() : "0.0"
            ..fields['category'] = category ?? "";

     
       if (image != null && image.isNotEmpty) {
        for (var img in image) {
          final fileExtension = img.path.split('.').last.toLowerCase();

          final contentType = MediaType('image', fileExtension);

          request.files.add(await http.MultipartFile.fromPath(
            'productImages[]', // Ensure this matches the expected field name
            img.path,
            contentType: contentType, // Adjust for actual file type
          ));
        }
      }

      // Sending Request
      final response = await request.send();

      // Reading Response
      final responseBody = await response.stream.bytesToString();
      print('Update Status Code: ${response.statusCode}');
      print('Update Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Product updated successfully!");
        getProducts(); // Refresh product list
        ref.read(sparepartProvider.notifier).getSpareParts(); 
        return true;
      } else {
        final errorBody = jsonDecode(responseBody);
        final errorMessage =
            errorBody['message'] ?? 'Unexpected error occurred.';
        throw Exception("Error updating product: $errorMessage");
      }
    } catch (error) {
      print("Failed to update product: $error");
      rethrow;
    } finally {
      loadingState.state = false;
    }
  }

  Future<bool> deleteProduct(String? productId) async {
    final loadingState = ref.read(loadingProvider.notifier);
    const String apiUrl = Bbapi.delete;
    final loginmodel = ref.read(loginProvider);
    final token = loginmodel.data![0].accessToken;

    try {
      // final prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        throw Exception("User token is missing. Please log in again.");
      }
      loadingState.state = true; // Show loading state
      final client = RetryClient(
        http.Client(),
        retries: 4,
        when: (response) {
          return response.statusCode == 401 || response.statusCode == 400
              ? true
              : false;
        },
        onRetry: (req, res, retryCount) async {
          if (retryCount == 0 && res?.statusCode == 401 ||
              res?.statusCode == 400) {
            // Here, handle your token restoration logic
            // You can access other providers using ref.read if needed
            var accessToken =
                await ref.watch(loginProvider.notifier).restoreAccessToken();

            //print(accessToken); // Replace with actual token restoration logic
            req.headers['Authorization'] = 'Bearer $accessToken';
          }
        },
      );

      final response = await client.delete(
        Uri.parse("$apiUrl/$productId"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Product deleted successfully!");
        getProducts();
        return true;
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            "Error deleting product: ${errorBody['message'] ?? 'Unexpected error occurred.'}");
      }
    } catch (error) {
      throw Exception("Error deleting product: $error");
    }
  }
}

// Define productProvider with ref
final productProvider =
    StateNotifierProvider<ProductProvider, ProductModel>((ref) {
  return ProductProvider(ref);
});
