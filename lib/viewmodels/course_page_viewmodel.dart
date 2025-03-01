import 'package:chef_taruna_birla/models/course.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_functions.dart';
import '../config/config.dart';
import '../utils/utility.dart';

class CoursePageViewModel with ChangeNotifier {
  List<Course> _courseList = [];
  bool _isLoading = false;
  bool _isVerticalLoading = false;
  bool _isReachedEnd = false;
  bool _isSearching = false;
  int _offset = 0;
  int _totalcount = 0;
  String _userId = '';
  String _selectedCategory = '';

  bool get isLoading => _isLoading;
  bool get isVerticalLoading => _isVerticalLoading;
  bool get isReachedEnd => _isReachedEnd;
  bool get isSearching => _isSearching;
  List<Course> get courseList => _courseList;
  String get selectedCategory => _selectedCategory;
  String deviceToken = Application.deviceToken;

  setOffset() {
    _offset = _offset + 20;
    notifyListeners();
  }

  // setSelectedCategory(String value) {
  //   _selectedCategory = value;
  //   notifyListeners();
  // }
  setSelectedCategory(String value) {
    _selectedCategory = value;
    print('Category set to: $_selectedCategory');
    notifyListeners();
  }

  //Get Search Course Data Function
  Future<void> getSearchedCourses(String value, BuildContext context) async {
    _isSearching = true;
    _isLoading = false;
    _isReachedEnd = false;
    _offset = 0;
    _courseList.clear();
    notifyListeners();
    String url =
        '${Constants.finalUrl}/courses_api/getSearchedCourse/$value?language_id=${Application.languageId}&user_id=${Application.userId}';
    Map<String, dynamic> _getResult =
        await ApiFunctions.getApiResult(url, Application.deviceToken);

    bool _status = _getResult['status'];
    var _data = _getResult['data'];
    if (_status) {
      if (_data['message'] == 'Auth_token_failure') {
        Utility.authErrorPopup(
            context,
            'Sorry for inconvenience. Their is some authentication problem regarding your account contact support: ' +
                Application.adminPhoneNumber);
      } else {
        var jsonResult = _data['courses'];
        jsonResult.forEach((course) => {
              _courseList.add(
                Course.fromJson(course),
              ),
            });
      }
      _isLoading = true;
      notifyListeners();
      Utility.showProgress(false);
    } else {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Some error occurred');
      Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getSearchedCourses(String value, BuildContext context) async {
  //   _isSearching = true;
  //   _isLoading = false;
  //   _isReachedEnd = false;
  //   _offset = 0;
  //   _courseList.clear();
  //   notifyListeners();

  //   // API URL for searched courses
  //   String url =
  //       '${Constants.baseUrl}course.php?action=getSearchedCourses&value=$value&user_id=${Application.userId}';

  //   try {
  //     // Fetch API result
  //     Map<String, dynamic> _getResult =
  //         await ApiFunctions.getApiResult(url, deviceToken);
  //     print("API Response: $_getResult");

  //     bool _status = _getResult['status'];
  //     var _data = _getResult['data'];

  //     if (_status) {
  //       if (_data['message'] == 'Auth_token_failure') {
  //         Utility.authErrorPopup(
  //             context,
  //             'Sorry for inconvenience. There is some authentication problem regarding your account, contact support: ' +
  //                 Application.adminPhoneNumber);
  //       } else {
  //         var jsonResult = _data['courses'];
  //         jsonResult.forEach((course) {
  //           // Update image path by appending base URL
  //           String imageUrl =
  //               'https://dashboard.cheftarunabirla.com${course['image_path']}';
  //           course['image_path'] =
  //               imageUrl; // Add full image URL to course data

  //           _courseList.add(Course.fromJson(course)); // Add course to the list
  //         });
  //       }
  //       _isLoading = true;
  //       notifyListeners();
  //       Utility.showProgress(false);
  //     } else {
  //       _isLoading = true;
  //       notifyListeners();
  //       Utility.printLog('Some error occurred');
  //       // Utility.databaseErrorPopup(context);
  //     }
  //   } catch (e) {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Error: $e');
  //     // Utility.databaseErrorPopup(context);
  //   }
  // }

  //Get Course Data Function
  Future<void> getCourseData(BuildContext context,
      {bool isMoreData = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('id') ?? "";
    _isSearching = false;
    _isReachedEnd = false;
    if (isMoreData) {
      _isVerticalLoading = true;
    } else {
      _offset = 0;
      _isVerticalLoading = false;
      _isLoading = false;
      Utility.showProgress(true);
    }
    notifyListeners();
    String getUrl =
        '${Constants.finalUrl}/courses_api/getCoursesByCategory?language_id=${Application.languageId}&category=$_selectedCategory&offset=$_offset&user_id=${Application.userId}';
    // '${Constants.baseUrl}course.php?action=getCoursesByCategory&category=$_selectedCategory&offset=$_offset&user_id=$_userId';

    Map<String, dynamic> _getResult =
        await ApiFunctions.getApiResult(getUrl, Application.deviceToken);

    bool _status = _getResult['status'];
    var _data = _getResult['data'];
    print(_data);
    if (_status) {
      if (!isMoreData) {
        _courseList.clear();
        _totalcount = _data['total'] ?? 0;
        notifyListeners();
      }
      if (_data['message'] == 'Auth_token_failure') {
        Utility.authErrorPopup(
            context,
            'Sorry for inconvenience. Their is some authentication problem regarding your account contact support: ' +
                Application.adminPhoneNumber);
      } else {
        var jsonResult = _data['courses'];
        jsonResult.forEach((course) => {
              _courseList.add(
                Course.fromJson(course),
              ),
            });
      }
      if (_totalcount == _courseList.length) {
        _isReachedEnd = true;
        notifyListeners();
      }
      if (isMoreData) {
        _isVerticalLoading = false;
        notifyListeners();
      } else {
        _isLoading = true;
        _isReachedEnd = false;
        notifyListeners();
      }
      Utility.showProgress(false);
    } else {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Some error occurred');
      // Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getCourseData(BuildContext context,
  //     {bool isMoreData = false}) async {
  //   print('Selected category: $_selectedCategory');
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _userId = prefs.getString('id') ?? 'Default Name'; // Use _userId here
  //   print("User ID from SharedPreferences: $_userId");

  //   _isSearching = false;
  //   _isReachedEnd = false;

  //   // Set loading state
  //   if (isMoreData) {
  //     _isVerticalLoading = true;
  //   } else {
  //     _offset = 0;
  //     _isVerticalLoading = false;
  //     _isLoading = false;
  //     Utility.showProgress(true);
  //   }

  //   String getUrl =
  //       '${Constants.baseUrl}course.php?action=getCoursesByCategory&category=$_selectedCategory&offset=$_offset&user_id=$_userId';
  //   print("Request URL: $getUrl");

  //   try {
  //     Map<String, dynamic> _getResult = await ApiFunctions.getApiResult(
  //         getUrl, deviceToken); // Check if deviceToken is defined
  //     print("API Response get data: $_getResult");

  //     bool _status = _getResult['status'];
  //     var _data = _getResult['data'];

  //     if (_status) {
  //       if (!isMoreData) {
  //         _courseList.clear();
  //         _totalcount = _data['total'] ?? 0;
  //         notifyListeners();
  //       }

  //       if (_data['message'] == 'Auth_token_failure') {
  //         Utility.authErrorPopup(
  //           context,
  //           'Sorry for inconvenience. There is some authentication problem regarding your account, contact support: ' +
  //               Application.adminPhoneNumber,
  //         );
  //       } else {
  //         var jsonResult = _data['courses'];
  //         jsonResult.forEach((course) {
  //           // Update image path by appending base URL
  //           String imageUrl =
  //               'https://dashboard.cheftarunabirla.com${course['image_path']}';
  //           course['image_path'] =
  //               imageUrl; // Add full image URL to course data

  //           _courseList.add(Course.fromJson(course)); // Add course to the list
  //         });
  //       }

  //       if (_totalcount == _courseList.length) {
  //         _isReachedEnd = true; // No more data to load
  //         notifyListeners();
  //       }

  //       if (isMoreData) {
  //         _isVerticalLoading = false;
  //         notifyListeners();
  //       } else {
  //         _isLoading = true;
  //         _isReachedEnd = false;
  //         notifyListeners();
  //       }

  //       Utility.showProgress(false);
  //     } else {
  //       _isLoading = true;
  //       notifyListeners();
  //       Utility.printLog('Some error occurred');
  //     }
  //   } catch (e) {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Error: $e');
  //   }
  // }
}
