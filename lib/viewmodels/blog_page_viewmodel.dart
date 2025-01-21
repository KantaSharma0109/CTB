import 'package:chef_taruna_birla/models/blog.dart';
import 'package:flutter/material.dart';

import '../common/common.dart';
import '../config/config.dart';
import '../services/mysql_db_service.dart';
import '../utils/utility.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BlogPageViewModel with ChangeNotifier {
  List<Blogs> _bloglist = [];
  late Blogs _firstBlog;
  bool _isLoading = false;
  bool _isEachBlogLoading = false;
  bool _isVerticalLoading = false;
  bool _isSearching = false;
  int _offset = 0;

  bool get isLoading => _isLoading;
  bool get isEachBlogLoading => _isEachBlogLoading;
  bool get isVerticalLoading => _isVerticalLoading;
  bool get isSearching => _isSearching;
  Blogs? get firstBlog => _firstBlog;
  List<Blogs> get bloglist => _bloglist;

  setOffset() {
    _offset = _offset + 20;
    notifyListeners();
  }

  // setVerticalLoading(bool value) {
  //   _isVerticalLoading = value;
  //   notifyListeners();
  // }

  // Get Blog Images
  // Future<void> getBlogImages(String id, BuildContext context) async {
  //   _isEachBlogLoading = false;
  //   notifyListeners();
  //   Utility.showProgress(true);
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: Constants.isDevelopment
  //         ? '${Constants.devBackendUrl}/getBlogImages/$id'
  //         : '${Constants.prodBackendUrl}/getBlogImages/$id',
  //   );

  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];
  //   if (_status) {
  //     _isEachBlogLoading = true;
  //     notifyListeners();
  //     Utility.showProgress(false);
  //   } else {
  //     _isEachBlogLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Some error occurred');
  //     Utility.databaseErrorPopup(context);
  //   }
  // }

  Future<void> getBlogImages(String id, BuildContext context) async {
    _isEachBlogLoading = false;
    notifyListeners();
    Utility.showProgress(true);

    final url =
        '${Constants.baseUrl}blog.php?action=getBlogImages&id=$id'; // Your PHP API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> _getImages = json.decode(response.body);
        bool _status = _getImages['status'];
        var _data = _getImages['data'];

        if (_status) {
          // Process the images as needed
          _isEachBlogLoading = true;
          notifyListeners();
          Utility.showProgress(false);
        } else {
          _isEachBlogLoading = true;
          notifyListeners();
          Utility.printLog('Some error occurred');
          // Utility.databaseErrorPopup(context);
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      _isEachBlogLoading = true;
      notifyListeners();
      Utility.printLog('Error: $error');
      // Utility.databaseErrorPopup(context);
    }
  }

  // Future<void> getSearchedBlogs(String value, BuildContext context) async {
  //   _isSearching = true;
  //   _isLoading = false;
  //   _offset = 0;
  //   _bloglist.clear();
  //   notifyListeners();

  //   final url =
  //       '${Constants.baseUrl}blog.php?search=$value'; // Your API endpoint

  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> _getNews = json.decode(response.body);
  //       bool _status = _getNews['status'];
  //       var _data = _getNews['data'];

  //       if (_status) {
  //         _data.forEach((blog) {
  //           _bloglist.add(Blogs(
  //             id: blog['id'].toString(),
  //             title: blog['title'].toString(),
  //             description: blog['description'].toString(),
  //             image_path: blog['path'].toString(),
  //             pdflink: blog['pdf'].toString(),
  //             created_at: blog['created_at'].toString(),
  //             share_url: blog['share_url'].toString(),
  //           ));
  //         });
  //         _firstBlog = _bloglist[0];
  //         _isLoading = true;
  //         notifyListeners();
  //       } else {
  //         _isLoading = true;
  //         notifyListeners();
  //         Utility.printLog('Some error occurred');
  //         Utility.databaseErrorPopup(context);
  //       }
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Error: $error');
  //     Utility.databaseErrorPopup(context);
  //   }
  // }

  Future<void> getSearchedBlogs(String value, BuildContext context) async {
    _isSearching = true;
    _isLoading = false;
    _offset = 0;
    _bloglist.clear();
    notifyListeners();

    final url =
        '${Constants.baseUrl}blog.php?action=getSearchedBlogs&search=$value'; // Your PHP API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> _getBlogs = json.decode(response.body);
        bool _status = _getBlogs['status'];
        var _data = _getBlogs['data'];

        if (_status) {
          _data.forEach((blog) {
            _bloglist.add(Blogs(
              id: blog['id'].toString(),
              title: blog['title'].toString(),
              description: blog['description'].toString(),
              image_path: blog['path'].toString(),
              pdflink: blog['pdf'].toString(),
              created_at: blog['created_at'].toString(),
              share_url: blog['share_url'].toString(),
            ));
          });
          _firstBlog = _bloglist[0];
          _isLoading = true;
          notifyListeners();
          Utility.showProgress(false);
        } else {
          _isLoading = true;
          notifyListeners();
          Utility.printLog('Some error occurred');
          // Utility.databaseErrorPopup(context);
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Error: $error');
      // Utility.databaseErrorPopup(context);
    }
  }

  // //Get More Blog Data Function
  // Future<void> getMoreBlogData(BuildContext context) async {
  //   _isSearching = false;
  //   _isVerticalLoading = true;
  //   notifyListeners();
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: Constants.isDevelopment
  //         ? '${Constants.devBackendUrl}/getBlogs/$_offset?language_id=${Application.languageId}'
  //         : '${Constants.prodBackendUrl}/getBlogs/$_offset?language_id=${Application.languageId}',
  //   );

  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];
  //   if (_status) {
  //     _data[ApiKeys.data].forEach((blog) => {
  //           _bloglist.add(Blogs(
  //             id: blog[ApiKeys.id].toString(),
  //             title: blog[ApiKeys.title].toString(),
  //             description: blog[ApiKeys.description].toString(),
  //             image_path: blog[ApiKeys.path].toString(),
  //             pdflink: blog[ApiKeys.pdf].toString(),
  //             created_at: blog[ApiKeys.created_at].toString(),
  //             share_url: blog[ApiKeys.share_url].toString(),
  //           ))
  //         });
  //     _isVerticalLoading = false;
  //     notifyListeners();
  //   } else {
  //     notifyListeners();
  //     Utility.printLog('Some error occurred');
  //     Utility.databaseErrorPopup(context);
  //   }
  // }
  //Get More Blog Data Function
  Future<void> getMoreBlogData(BuildContext context) async {
    _isSearching = false;
    _isVerticalLoading = true;
    notifyListeners();

    final url = Constants.isDevelopment
        ? '${Constants.baseUrl}blog.php?action=getBlogs&offset=$_offset'
        : '${Constants.baseUrl}blog.php?action=getBlogs&offset=$_offset';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> _getNews = json.decode(response.body);
        bool _status = _getNews['status'];
        var _data = _getNews['data'];

        if (_status) {
          _data.forEach((blog) {
            _bloglist.add(Blogs(
              id: blog['id'].toString(),
              title: blog['title'].toString(),
              description: blog['description'].toString(),
              image_path: blog['path'].toString(),
              pdflink: blog['pdf'].toString(),
              created_at: blog['created_at'].toString(),
              share_url: blog['share_url'].toString(),
            ));
          });

          _offset += 20; // Increment offset for next batch of blogs
          _isVerticalLoading = false;
          notifyListeners();
        } else {
          _isVerticalLoading = false;
          notifyListeners();
          Utility.printLog('Some error occurred');
          // Utility.databaseErrorPopup(context);
        }
      } else {
        throw Exception('Failed to load more data');
      }
    } catch (error) {
      _isVerticalLoading = false;
      notifyListeners();
      Utility.printLog('Error: $error');
      // Utility.databaseErrorPopup(context);
    }
  }

  // //Get Blog Data Function
  // Future<void> getBlogData(BuildContext context) async {
  //   _isSearching = false;
  //   _isLoading = false;
  //   notifyListeners();
  //   Utility.showProgress(true);
  //   Map<String, dynamic> _getNews = await MySqlDBService().runQuery(
  //     requestType: RequestType.GET,
  //     url: Constants.isDevelopment
  //         ? '${Constants.devBackendUrl}/getBlogs/$_offset?language_id=${Application.languageId}'
  //         : '${Constants.prodBackendUrl}/getBlogs/$_offset?language_id=${Application.languageId}',
  //   );

  //   bool _status = _getNews['status'];
  //   var _data = _getNews['data'];
  //   if (_status) {
  //     _bloglist.clear();
  //     _data[ApiKeys.data].forEach((blog) => {
  //           _bloglist.add(Blogs(
  //             id: blog[ApiKeys.id].toString(),
  //             title: blog[ApiKeys.title].toString(),
  //             description: blog[ApiKeys.description].toString(),
  //             image_path: blog[ApiKeys.path].toString(),
  //             pdflink: blog[ApiKeys.pdf].toString(),
  //             created_at: blog[ApiKeys.created_at].toString(),
  //             share_url: blog[ApiKeys.share_url].toString(),
  //           ))
  //         });
  //     _firstBlog = _bloglist[0];
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

  // Future<void> getBlogs(BuildContext context) async {
  //   _isLoading = false;
  //   notifyListeners();
  //   Utility.showProgress(true);

  //   final url =
  //       '${Constants.baseUrl}blog.php?action=getBlogs&offset=$_offset'; // Your PHP API URL

  //   try {
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> _getBlogs = json.decode(response.body);
  //       bool _status = _getBlogs['status'];
  //       var _data = _getBlogs['data'];

  //       if (_status) {
  //         _data.forEach((blog) {
  //           _bloglist.add(Blogs(
  //             id: blog['id'].toString(),
  //             title: blog['title'].toString(),
  //             description: blog['description'].toString(),
  //             image_path: blog['path'].toString(),
  //             pdflink: blog['pdf'].toString(),
  //             created_at: blog['created_at'].toString(),
  //             share_url: blog['share_url'].toString(),
  //           ));
  //         });
  //         _firstBlog = _bloglist[0];
  //         _isLoading = true;
  //         notifyListeners();
  //         Utility.showProgress(false);
  //       } else {
  //         _isLoading = true;
  //         notifyListeners();
  //         Utility.printLog('Some error occurred');
  //         // Utility.databaseErrorPopup(context);
  //       }
  //     } else {
  //       throw Exception('Failed to load data');
  //     }
  //   } catch (error) {
  //     _isLoading = true;
  //     notifyListeners();
  //     Utility.printLog('Error: $error');
  //     // Utility.databaseErrorPopup(context);
  //   }
  // }
  Future<void> getBlogs(BuildContext context) async {
    _bloglist.clear(); // Clear the existing list to prevent duplicates
    _isLoading = false;
    notifyListeners();
    Utility.showProgress(true);

    final url =
        '${Constants.baseUrl}blog.php?action=getBlogs&offset=$_offset'; // Your PHP API URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> _getBlogs = json.decode(response.body);
        bool _status = _getBlogs['status'];
        var _data = _getBlogs['data'];

        if (_status) {
          _data.forEach((blog) {
            _bloglist.add(Blogs(
              id: blog['id'].toString(),
              title: blog['title'].toString(),
              description: blog['description'].toString(),
              image_path: blog['path'].toString(),
              pdflink: blog['pdf'].toString(),
              created_at: blog['created_at'].toString(),
              share_url: blog['share_url'].toString(),
            ));
          });
          _firstBlog = _bloglist[0];
          _isLoading = true;
          notifyListeners();
          Utility.showProgress(false);
        } else {
          _isLoading = true;
          notifyListeners();
          Utility.printLog('Some error occurred');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      _isLoading = true;
      notifyListeners();
      Utility.printLog('Error: $error');
    }
  }
}
