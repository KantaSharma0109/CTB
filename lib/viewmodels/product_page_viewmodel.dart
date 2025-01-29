import 'package:chef_taruna_birla/models/products.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../config/config.dart';
import '../models/product_sub_ctegory .dart';
import '../models/slider.dart';
import '../services/mysql_db_service.dart';
import '../utils/utility.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductPageViewModel with ChangeNotifier {
  List<Products> _productList = [];
  List<Products> _subProductList = [];
  bool _isLoading = false;
  bool _isEachProductLoading = false;
  bool _isVerticalLoading = false;
  bool _isSearching = false;
  int _offset = 0;
  String _userId = '';
  String _selectedCategory = '';
  String _selectedSubCategory = '';
  String url = Constants.isDevelopment
      ? Constants.devBackendUrl
      : Constants.prodBackendUrl;
  List<AppSlider> _appslider = [];
  List<ProductSubCategory> _subCategories = [];

  bool get isLoading => _isLoading;
  bool get isEachProductLoading => _isEachProductLoading;
  bool get isVerticalLoading => _isVerticalLoading;
  bool get isSearching => _isSearching;
  List<Products> get productList => _productList;
  List<Products> get subProductList => _subProductList;
  String get selectedCategory => _selectedCategory;
  String get selectedSubCategory => _selectedSubCategory;
  List<AppSlider> get appslider => _appslider;
  List<ProductSubCategory> get subCategories => _subCategories;

  setOffset() {
    _offset = _offset + 20;
    notifyListeners();
  }

  setSelectedCategory(String value) {
    _selectedCategory = value;
    notifyListeners();
  }

  setSelectedSubCategory(String value) {
    _selectedSubCategory = value;
    notifyListeners();
  }

  // setVerticalLoading(bool value) {
  //   _isVerticalLoading = value;
  //   notifyListeners();
  // }
  //
  // Future<void> updateCart(id, value, BuildContext context) async {
  //   Map<String, dynamic> _updateCart = await MySqlDBService().runQuery(
  //     requestType: RequestType.POST,
  //     url:
  //         value == 'add' ? '$url/users/addtocart' : '$url/users/removefromcart',
  //     body: {
  //       'user_id': _userId,
  //       'category': 'product',
  //       'id': id,
  //     },
  //   );
  //
  //   bool _status = _updateCart['status'];
  //   var _data = _updateCart['data'];
  //   // print(_data);
  //   if (_status) {
  //     // data loaded
  //     // print(_data);
  //     if (value == 'add') {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const CartPage(),
  //         ),
  //       );
  //     }
  //   } else {
  //     Utility.printLog('Something went wrong.');
  //   }
  // }
  //
  // Future<void> updateWhislist(id, value) async {
  //   Map<String, dynamic> _updateCart = await MySqlDBService().runQuery(
  //     requestType: RequestType.POST,
  //     url: value == 'add'
  //         ? '$url/users/addtowhislist'
  //         : '$url/users/removefromwhislist',
  //     body: {
  //       'user_id': _userId,
  //       'category': 'product',
  //       'id': id,
  //     },
  //   );

  //   bool _status = _updateCart['status'];
  //   var _data = _updateCart['data'];
  //   // print(_data);
  //   if (_status) {
  //   } else {
  //     Utility.printLog('Something went wrong.');
  //   }
  // }

  //Get product Images
  // Future<void> getProductImages(String id, BuildContext context) async {
  //   _isEachProductLoading = false;
  //   notifyListeners();
  //   Utility.showProgress(true);
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: Constants.isDevelopment
  //         ? '${Constants.devBackendUrl}/getproductImages/$id'
  //         : '${Constants.prodBackendUrl}/getproductImages/$id',
  //   );

  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];
  //   if (_status) {
  //     _isEachProductLoading = true;
  //     notifyListeners();
  //     Utility.showProgress(false);
  //   } else {
  //     _isEachProductLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Some error occurred');
  //     // Utility.databaseErrorPopup(context);
  //   }
  // }
  // Future<void> getProductImages(String productId, BuildContext context) async {
  //   _isEachProductLoading = false;
  //   notifyListeners();
  //   Utility.showProgress(true);

  //   // Construct the appropriate URL based on the environment (development or production)
  //   final String url = Constants.isDevelopment
  //       ? '${Constants.baseUrl}product.php/getProductImages'
  //       : '${Constants.baseUrl}product.php/getProductImages';

  //   // Make the GET request
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: '$url?product_id=$productId',
  //   );

  //   // Process the response
  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];
  //   if (_status) {
  //     _isEachProductLoading = true;
  //     notifyListeners();
  //     Utility.showProgress(false);
  //     // Handle the response (e.g., update UI with images)
  //     print("Product Images: $_data");
  //   } else {
  //     _isEachProductLoading = true;
  //     notifyListeners();
  //     Utility.showProgress(false);
  //     Utility.printLog('Some error occurred');
  //     // Handle error (e.g., show error dialog)
  //   }
  // }

  //Get Search product Data Function
  Future<void> getSearchedProducts(String value, BuildContext context) async {
    _isSearching = true;
    _isLoading = false;
    _offset = 0;
    _productList.clear();
    notifyListeners();
    // Utility.showProgress(true);
    String requestUrl =
        '${Constants.baseUrl}/getSearchedProduct/$value/${Application.userId}?language_id=${Application.languageId}';
    print("Sending request to backend: $requestUrl");
    Map<String, dynamic> _getNews = await MySqlDBService()
        .runQuery(requestType: RequestType.GET, url: requestUrl);
    print('API Response: $_getNews');
    bool _status = _getNews['status'];
    var _data = _getNews['data'];
    if (_status) {
      _data[ApiKeys.data].forEach((product) => {
            _productList.add(
              Products(
                id: product[ApiKeys.id].toString(),
                name: product[ApiKeys.name].toString(),
                description: product[ApiKeys.description].toString(),
                c_name: product[ApiKeys.c_name].toString(),
                category_id: product[ApiKeys.category_id].toString(),
                price: product[ApiKeys.price].toString(),
                discount_price: product[ApiKeys.discount_price].toString(),
                stock: int.parse(product[ApiKeys.stock].toString()),
                image_path: product[ApiKeys.image_path].toString(),
                share_url: product[ApiKeys.share_url].toString(),
                // count: int.parse(product[ApiKeys.count].toString()),
                // whislistcount:
                //     int.parse(product[ApiKeys.whislistcount].toString()),
              ),
            ),
          });
      _isLoading = true;
      notifyListeners();
      // Utility.showProgress(false);
    } else {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Some error occurred');
      // Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getSearchedProducts(String value, BuildContext context) async {
  //   _isSearching = true;
  //   _isLoading = false;
  //   _offset = 0;
  //   _productList.clear();
  //   notifyListeners();

  //   String requestUrl =
  //       '${Constants.baseUrl}product.php/getSearchedProduct/$value/${Application.userId}?language_id=${Application.languageId}';
  //   print("Sending request to backend: $requestUrl");
  //   Map<String, dynamic> _getNews = await MySqlDBService()
  //       .runQuery(requestType: RequestType.GET, url: requestUrl);

  //   print('API Response: $_getNews');
  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];

  //   if (_status) {
  //     _data.forEach((product) {
  //       _productList.add(
  //         Products(
  //           id: product['id'].toString(),
  //           name: product['name'].toString(),
  //           description: product['description'].toString(),
  //           c_name: product['c_name'].toString(),
  //           category_id: product['category_id'].toString(),
  //           price: product['price'].toString(),
  //           discount_price: product['discount_price'].toString(),
  //           stock: int.parse(product['stock'].toString()),
  //           image_path: product['image_path'].toString(),
  //           share_url: product['share_url'].toString(),
  //         ),
  //       );
  //     });
  //     _isLoading = true;
  //     notifyListeners();
  //   } else {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Some error occurred');
  //     Utility.databaseErrorPopup(context);
  //   }
  // }

  //Get More product Data Function
  Future<void> getMoreProductData(BuildContext context) async {
    _isSearching = false;
    _isVerticalLoading = true;
    notifyListeners();
    Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
        requestType: RequestType.GET,
        // url: _selectedCategory == 'All'
        //     ? '$url/getUserProduct/${Application.userId}/$_offset?language_id=${Application.languageId}'
        //     : '$url/getCategoryProduct/$_selectedCategory/${Application.userId}/$_offset?language_id=${Application.languageId}',
        url: _selectedCategory == 'All' || _selectedCategory.isEmpty
            ? '$url?offset=$_offset&user_id=${Application.userId}&language_id=${Application.languageId}'
            : '$url?category=$selectedCategory&user_id=${Application.userId}&offset=$_offset&language_id=${Application.languageId}');

    ;

    bool _status = _getNews['status'];
    var _data = _getNews['data'];
    if (_status) {
      var jsonResult = _data[ApiKeys.data];
      jsonResult.forEach((product) => {
            _productList.add(
              Products.fromJson(product),
            ),
          });

      _isVerticalLoading = false;
      notifyListeners();
    } else {
      notifyListeners();
      Utility.printLog('Some error occurred');
      // Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getMoreProductData(BuildContext context) async {
  //   _isSearching = false;
  //   _isVerticalLoading = true;
  //   notifyListeners();

  //   String url = _selectedCategory == 'All'
  //       ? '${Constants.baseUrl}product.php/getUserProduct/${Application.userId}/$_offset?language_id=${Application.languageId}'
  //       : '${Constants.baseUrl}product.php/getCategoryProduct/$_selectedCategory/${Application.userId}/$_offset?language_id=${Application.languageId}';
  //   print("Sending request to backend: $_selectedCategory");
  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> _getNews = json.decode(response.body);
  //       bool _status = _getNews['status'];
  //       var _data = _getNews['data'];

  //       if (_status) {
  //         var jsonResult =
  //             _data['data']; // Assuming 'data' is the key for products
  //         jsonResult.forEach((product) {
  //           _productList.add(Products.fromJson(product));
  //         });

  //         _isVerticalLoading = false;
  //         notifyListeners();
  //       } else {
  //         _isVerticalLoading = false;
  //         notifyListeners();
  //         Utility.printLog('Some error occurred');
  //         // Utility.databaseErrorPopup(context);
  //       }
  //     } else {
  //       throw Exception('Failed to load more data');
  //     }
  //   } catch (error) {
  //     _isVerticalLoading = false;
  //     notifyListeners();
  //     Utility.printLog('Error: $error');
  //     // Utility.databaseErrorPopup(context);
  //   }
  // }

  //Get product Data Function
  Future<void> getProductData(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _userId = prefs.getString('user_id') ?? "";
    _productList.clear();
    _isSearching = false;
    _isLoading = false;
    _offset = 0;
    // _appslider.clear();
    final userId = Application.userId;
    final offset = _offset;
    final languageId = Application.languageId;
    final selectedCategory = _selectedCategory;
    final selectedSubCategory = _selectedSubCategory;
    final url = '${Constants.baseUrl}product.php';
    Utility.showProgress(true);
    Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
        requestType: RequestType.GET,
        // url: _selectedCategory == 'All' || _selectedCategory.isEmpty
        //     ? '$url/getUserProduct?offset=$_offset&user_id=$userId&language_id=${Application.languageId}'
        //     // '$url/getUserProduct/${Application.userId}/$_offset?language_id=${Application.languageId}'
        //     : '$url/getCategoryProduct/$userId/$selectedCategory/$_offset?language_id=${Application.languageId}'
        // // '$url/getCategoryProduct/$_selectedCategory/${Application.userId}/$_offset?language_id=${Application.languageId}',

        url: _selectedCategory == 'All' || _selectedCategory.isEmpty
            ? '$url?offset=$_offset&user_id=$userId&language_id=${Application.languageId}'
            : '$url?category=$selectedCategory&subcategory=$selectedSubCategory&user_id=$userId&offset=$_offset&language_id=${Application.languageId}');
    print("Sending request to backend: $url");
    print("Sending GET request to backend: $_getNews");
    print("Base URL: $url");
    print("User ID: $userId");
    print("Offset: $offset");
    print("Language ID: $languageId");
    print("Selected Category: $selectedCategory");
    print("Selected sub Category: $selectedSubCategory");
    bool _status = _getNews['status'];
    var _data = _getNews['data'];
    print("Response status code: ${_status}");
    print("Response body: ${_data}");
    if (_status) {
      _productList.clear();
      var jsonResult = _data[ApiKeys.data];
      jsonResult.forEach((product) => {
            _productList.add(
              Products.fromJson(product),
            ),
            // print("Response product: $_productList"),
          });

      // _data[ApiKeys.slider].forEach((slider) => {
      //       _appslider.add(
      //         AppSlider(
      //           id: slider[ApiKeys.id].toString(),
      //           category: slider[ApiKeys.category].toString(),
      //           image_path: slider[ApiKeys.path].toString(),
      //           thumbnail: slider[ApiKeys.thumbnail].toString(),
      //           linked_category: slider[ApiKeys.linked_category].toString(),
      //           linked_array: slider[ApiKeys.linked_array].toString(),
      //         ),
      //       )
      //     });

      _isLoading = true;
      notifyListeners();
      Utility.showProgress(false);
    } else {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Some error occurred');
      // Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getProductData(BuildContext context) async {
  //   _isSearching = false;
  //   _isLoading = false;
  //   _offset = 0;
  //   _appslider.clear();
  //   final userId = Application.userId;
  //   final offset = _offset;
  //   final selectedCategory = _selectedCategory;
  //   final url = '${Constants.baseUrl}product.php'; // Your API base URL

  //   Utility.showProgress(true);

  //   // Prepare the correct URL for the API call based on the selected category
  //   String requestUrl;
  //   if (selectedCategory == 'All' || selectedCategory.isEmpty) {
  //     requestUrl =
  //         '$url/getUserProduct?offset=$_offset&user_id=$userId&language_id=${Application.languageId}';
  //   } else {
  //     requestUrl =
  //         '$url/getCategoryProduct/$selectedCategory/$userId/$_offset?language_id=${Application.languageId}';
  //   }

  //   // Perform the GET request using MySqlDBService
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: requestUrl,
  //   );

  //   print("Sending request to backend: $requestUrl");
  //   print("Sending GET request to backend: $_getNews");

  //   bool _status = _getNews['status']; // Check the status from the response
  //   var _data = _getNews['data']; // Get the data from the response

  //   print("Response status code: $_status");
  //   print("Response body: $_data");

  //   if (_status) {
  //     _productList.clear();

  //     // Parse product data and add to product list
  //     var jsonResult = _data['data']; // Assuming 'data' holds the product data
  //     jsonResult.forEach((product) {
  //       _productList.add(Products.fromJson(product));
  //       print("Response product: $_productList");
  //     });

  //     // Parse slider data and add to appslider
  //     _data['slider'].forEach((slider) {
  //       _appslider.add(
  //         AppSlider(
  //           id: slider['id'].toString(),
  //           category: slider['category'].toString(),
  //           image_path: slider['path'].toString(),
  //           thumbnail: slider['thumbnail'].toString(),
  //           linked_category: slider['linked_category'].toString(),
  //           linked_array: slider['linked_array'].toString(),
  //         ),
  //       );
  //     });

  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.showProgress(false);
  //   } else {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Some error occurred');
  //     Utility.databaseErrorPopup(context);
  //   }
  // }

  Future<void> getSliderData() async {
    final url = '${Constants.baseUrl}product.php?slider=true';
    Utility.showProgress(true);

    try {
      Map<String, dynamic> response = await MySqlDBService().runQuery(
        requestType: RequestType.GET,
        url: url,
      );
      print('Slider response: $response');

      // Check if the slider data exists inside response['data']['slider']
      if (response['data'] != null &&
          response['data']['slider'] != null &&
          response['data']['slider'].isNotEmpty) {
        _appslider.clear();
        response['data']['slider'].forEach((slider) {
          _appslider.add(
            AppSlider(
              id: slider[ApiKeys.id].toString(),
              category: slider[ApiKeys.category].toString(),
              image_path: slider[ApiKeys.path].toString(),
              thumbnail: slider[ApiKeys.thumbnail].toString(),
              linked_category: slider[ApiKeys.linked_category].toString(),
              linked_array: slider[ApiKeys.linked_array].toString(),
            ),
          );
        });
        print('Slider data has been added to the list.');
        notifyListeners();
      } else {
        // If no slider data found
        print('No slider data found in the response.');
      }
    } catch (e) {
      Utility.printLog('Error fetching slider data: $e');
    } finally {
      Utility.showProgress(false);
    }
  }

  Future<void> fetchSubCategories(String categoryId) async {
    _isLoading = true; // Set loading state to true while fetching data
    notifyListeners();

    String url = '${Constants.baseUrl}product.php?category_id=$categoryId';
    print('request url : $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('response body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        bool status = responseBody['data']['status'] ??
            false; // Access the status in 'data'

        if (status) {
          List<dynamic> data = responseBody['data']
              ['data']; // Get the array from the 'data' field
          _subCategories.clear();
          _subCategories.addAll(data.map((subcategory) {
            // Ensure correct conversion of fields, e.g., status as int
            return ProductSubCategory.fromJson({
              'id': int.parse(subcategory['id']),
              'name': subcategory['name'],
              'category_id': int.parse(subcategory['category_id']),
              'status':
                  int.parse(subcategory['status']), // Convert status to int
            });
          }).toList());
        } else {
          _subCategories.clear();
        }
      } else {
        // Handle failed response
        _subCategories.clear();
      }
    } catch (error) {
      // Handle error
      print('Error fetching subcategories: $error');
      _subCategories.clear();
    }

    _isLoading = false; // Set loading state to false after fetching data
    notifyListeners();
  }
}
