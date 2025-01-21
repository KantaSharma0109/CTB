import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/config.dart';
import '../models/cart_item.dart';
import '../models/products.dart';
import '../pages/product/each_product.dart';
import '../pages/product/product_buy_page.dart';
import '../services/mysql_db_service.dart';
import '../utils/utility.dart';
import '../viewmodels/main_container_viewmodel.dart';
import 'image_placeholder.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({Key? key}) : super(key: key);

  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  List<Products> featuredProducts = [];
  bool isLoading = false;
  String user_id = '';
  String url = Constants.isDevelopment
      ? Constants.devBackendUrl
      : Constants.prodBackendUrl;

  void setFeaturedProducts() {
    // featuredProducts.clear();
    // Provider.of<MainContainerViewModel>(context, listen: false)
    //     .featured_products
    //     .forEach((featuredProduct) {
    //   featuredProducts.add(
    //     Products(
    //       id: featuredProduct.id,
    //       name: featuredProduct.name,
    //       description: featuredProduct.description,
    //       c_name: featuredProduct.c_name,
    //       category_id: featuredProduct.category_id,
    //       price: featuredProduct.price,
    //       discount_price: featuredProduct.discount_price,
    //       stock: featuredProduct.stock,
    //       image_path: featuredProduct.image_path,
    //       // count: featuredProduct.count,
    //       // whislistcount: featuredProduct.whislistcount,
    //     ),
    //   );
    // });
    setState(() => isLoading = true);
  }

  Future<void> updateWhislist(id, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id') ?? '';
    setState(() {
      user_id = userId;
    });
    Map<String, dynamic> _updateCart = await MySqlDBService().runQuery(
      requestType: RequestType.POST,
      url: value == 'add'
          ? '$url/users/addtowhislist'
          : '$url/users/removefromwhislist',
      body: {
        'user_id': user_id,
        'category': 'product',
        'id': id,
      },
    );

    bool _status = _updateCart['status'];
    var _data = _updateCart['data'];
    // print(_data);
    if (_status) {
    } else {
      Utility.printLog('Something went wrong.');
    }
  }

  // Future<void> updateWhislist(String id, String value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('id') ?? '';

  //   // Build the correct API URL based on the action
  //   final apiUrl = value == 'add'
  //       ? '${Constants.baseUrl}userCartWishlist.php?action=addtowhislist'
  //       : '${Constants.baseUrl}userCartWishlist.php?action=removefromwhislist';

  //   // Define the body of the POST request
  //   final requestBody = {
  //     'user_id': userId,
  //     'category':
  //         'product', // Change 'product' to other categories dynamically if needed
  //     'id': id,
  //   };

  //   try {
  //     // Make the POST request
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(requestBody),
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);

  //       if (responseData['message'] == 'success') {
  //         print('Operation successful.');
  //       } else {
  //         print('Error: ${responseData['message']}');
  //       }
  //     } else {
  //       print('HTTP Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Exception occurred: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    setFeaturedProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Container()
        : LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SizedBox(
                height: constraints.maxWidth < 576
                    ? 200.0
                    : 200.0, // Adjust card height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // return GridView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //     crossAxisCount: constraints.maxWidth < 576
                  //         ? 2
                  //         : constraints.maxWidth < 768
                  //             ? 3
                  //             : constraints.maxWidth < 992
                  //                 ? 4
                  //                 : 6,
                  //     childAspectRatio: constraints.maxWidth < 576
                  //         ? 0.72
                  //         : constraints.maxWidth < 768
                  //             ? 0.8
                  //             : constraints.maxWidth < 992
                  //                 ? 0.8
                  //                 : constraints.maxWidth < 1024
                  //                     ? 0.7
                  //                     : constraints.maxWidth < 1220
                  //                         ? 0.7
                  //                         : 0.9,
                  //     mainAxisSpacing: 0.0,
                  //     crossAxisSpacing: 10.0,
                  //   ),
                  itemCount: Provider.of<MainContainerViewModel>(context,
                          listen: false)
                      .featured_products
                      .length,
                  itemBuilder: (context, index) {
                    int counter = 0;
                    int whislistCounter = 0;
                    Provider.of<MainContainerViewModel>(context, listen: false)
                        .cart
                        .forEach((element) {
                      if (element.item_id ==
                              Provider.of<MainContainerViewModel>(context,
                                      listen: false)
                                  .featured_products[index]
                                  .id &&
                          element.item_category == 'product' &&
                          element.cart_category == 'cart') {
                        counter++;
                      }
                    });
                    Provider.of<MainContainerViewModel>(context, listen: false)
                        .whislist
                        .forEach((element) {
                      if (element.item_id ==
                              Provider.of<MainContainerViewModel>(context,
                                      listen: false)
                                  .featured_products[index]
                                  .id &&
                          element.item_category == 'product' &&
                          element.cart_category == 'whislist') {
                        whislistCounter++;
                      }
                    });
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == 0
                            ? 18
                            : 0.0, // No margin for the first card
                        right: 5.0, // Standard margin for all other cards
                      ),
                      //  ClipRRect(
                      //   borderRadius: BorderRadius.circular(10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EachProduct(
                                    id: Provider.of<MainContainerViewModel>(
                                            context,
                                            listen: false)
                                        .featured_products[index]
                                        .id)),
                          );
                        },
                        child: Container(
                          width: constraints.maxWidth *
                              0.5, // Adjust the width as needed
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Palette.white,
                            boxShadow: [
                              BoxShadow(
                                color: Palette.shadowColor.withOpacity(0.1),
                                blurRadius: 5.0,
                                spreadRadius: 0.0,
                                offset: const Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          // child: Container(
                          //   margin: EdgeInsets.fromLTRB(
                          //       constraints.maxWidth < 576
                          //           ? index % 2 == 0
                          //               ? 24.0
                          //               : 0.0
                          //           : constraints.maxWidth < 768
                          //               ? index % 3 == 0
                          //                   ? 24.0
                          //                   : 0.0
                          //               : constraints.maxWidth < 992
                          //                   ? index % 4 == 0
                          //                       ? 24.0
                          //                       : 0.0
                          //                   : index % 6 == 0
                          //                       ? 24.0
                          //                       : 0.0,
                          //       5.0,
                          //       constraints.maxWidth < 576
                          //           ? index % 2 == 1
                          //               ? 24.0
                          //               : 0.0
                          //           : constraints.maxWidth < 768
                          //               ? index % 3 == 2
                          //                   ? 24.0
                          //                   : 0.0
                          //               : constraints.maxWidth < 992
                          //                   ? index % 4 == 3
                          //                       ? 24.0
                          //                       : 0.0
                          //                   : index % 6 == 5
                          //                       ? 24.0
                          //                       : 0.0,
                          //       5.0),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     color: Palette.white,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Palette.shadowColor.withOpacity(0.1),
                          //         blurRadius: 5.0, // soften the shadow
                          //         spreadRadius: 0.0, //extend the shadow
                          //         offset: const Offset(
                          //           0.0, // Move to right 10  horizontally
                          //           0.0, // Move to bottom 10 Vertically
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EachProduct(
                                                    id: Provider.of<
                                                                MainContainerViewModel>(
                                                            context,
                                                            listen: false)
                                                        .featured_products[
                                                            index]
                                                        .id)),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                            imageUrl: Provider.of<
                                                        MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .featured_products[index]
                                                .image_path,
                                            placeholder: (context, url) =>
                                                const ImagePlaceholder(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const ImagePlaceholder(),
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            Provider.of<MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .featured_products[index]
                                                .name,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Palette.black,
                                              fontSize: 16.0,
                                              fontFamily:
                                                  'EuclidCircularA Regular',
                                            ),
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.all(0.0),
                                        //   child: Text(
                                        //     'Rs ${Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].discount_price}',
                                        //     style: const TextStyle(
                                        //       color: Palette.contrastColor,
                                        //       fontSize: 16.0,
                                        //       fontFamily:
                                        //           'EuclidCircularA Medium',
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Rs ${Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].discount_price}',
                                                style: const TextStyle(
                                                  color: Palette.contrastColor,
                                                  fontSize: 20.0,
                                                  fontFamily:
                                                      'EuclidCircularA Medium',
                                                ),
                                              ),
                                              // Text(
                                              //   Provider.of<MainContainerViewModel>(
                                              //                   context,
                                              //                   listen: false)
                                              //               .featured_products[
                                              //                   index]
                                              //               .discount_price ==
                                              //           Provider.of<MainContainerViewModel>(
                                              //                   context,
                                              //                   listen: false)
                                              //               .featured_products[
                                              //                   index]
                                              //               .price
                                              //       ? ''
                                              //       : 'Rs ${Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].price}',
                                              //   style: const TextStyle(
                                              //     color: Palette.grey,
                                              //     fontSize: 16.0,
                                              //     fontFamily:
                                              //         'EuclidCircularA Regular',
                                              //     decoration: TextDecoration
                                              //         .lineThrough,
                                              //   ),
                                              // ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Text(
                                                Provider.of<MainContainerViewModel>(
                                                                context,
                                                                listen: false)
                                                            .featured_products[
                                                                index]
                                                            .discount_price ==
                                                        Provider.of<MainContainerViewModel>(
                                                                context,
                                                                listen: false)
                                                            .featured_products[
                                                                index]
                                                            .price
                                                    ? ''
                                                    : '${(((int.parse(Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].price) - int.parse(Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].discount_price)) / int.parse(Provider.of<MainContainerViewModel>(context, listen: false).featured_products[index].price)) * 100).toString().substring(0, 4)} %',
                                                style: const TextStyle(
                                                  color: Palette.secondaryColor,
                                                  fontSize: 14.0,
                                                  fontFamily:
                                                      'EuclidCircularA Medium',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ProductBuyPage(
                                                      price: Provider.of<
                                                                  MainContainerViewModel>(
                                                              context,
                                                              listen: false)
                                                          .featured_products[
                                                              index]
                                                          .discount_price,
                                                      id: Provider.of<
                                                                  MainContainerViewModel>(
                                                              context,
                                                              listen: false)
                                                          .featured_products[
                                                              index]
                                                          .id)),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Palette.secondaryColor2,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0)),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              child: Center(
                                                child: Text(
                                                  'Buy Now',
                                                  style: TextStyle(
                                                    color: Palette.white,
                                                    fontSize: 14.0,
                                                    fontFamily:
                                                        'EuclidCircularA Medium',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () {
                                    Utility.printLog('whislist pressed');
                                    setState(() {
                                      if (whislistCounter >= 1) {
                                        Provider.of<MainContainerViewModel>(
                                                context,
                                                listen: false)
                                            .whislist
                                            .removeWhere((element) =>
                                                element.item_id ==
                                                    Provider.of<MainContainerViewModel>(
                                                            context,
                                                            listen: false)
                                                        .featured_products[
                                                            index]
                                                        .id &&
                                                element.item_category ==
                                                    'product' &&
                                                element.cart_category ==
                                                    'whislist');
                                        context
                                            .read<MainContainerViewModel>()
                                            .setWhislist(Provider.of<
                                                        MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .whislist);
                                        whislistCounter = 0;
                                        updateWhislist(
                                            Provider.of<MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .featured_products[index]
                                                .id,
                                            'remove');
                                      } else {
                                        var newItem = CartItem(
                                          cart_id: '',
                                          item_id: Provider.of<
                                                      MainContainerViewModel>(
                                                  context,
                                                  listen: false)
                                              .featured_products[index]
                                              .id,
                                          name: Provider.of<
                                                      MainContainerViewModel>(
                                                  context,
                                                  listen: false)
                                              .featured_products[index]
                                              .name,
                                          price: int.parse(Provider.of<
                                                      MainContainerViewModel>(
                                                  context,
                                                  listen: false)
                                              .featured_products[index]
                                              .discount_price),
                                          cart_category: 'whislist',
                                          image_path: Provider.of<
                                                      MainContainerViewModel>(
                                                  context,
                                                  listen: false)
                                              .featured_products[index]
                                              .image_path,
                                          quantity: 0,
                                          item_category: 'product',
                                        );
                                        Provider.of<MainContainerViewModel>(
                                                context,
                                                listen: false)
                                            .whislist
                                            .add(newItem);
                                        context
                                            .read<MainContainerViewModel>()
                                            .setWhislist(Provider.of<
                                                        MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .whislist);
                                        whislistCounter = 1;
                                        updateWhislist(
                                            Provider.of<MainContainerViewModel>(
                                                    context,
                                                    listen: false)
                                                .featured_products[index]
                                                .id,
                                            'add');
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: BoxDecoration(
                                      color: Palette.white,
                                      borderRadius: BorderRadius.circular(50.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Palette.shadowColor
                                              .withOpacity(0.1),
                                          blurRadius: 5.0, // soften the shadow
                                          spreadRadius: 0.0, //extend the shadow
                                          offset: const Offset(
                                            0.0, // Move to right 10  horizontally
                                            0.0, // Move to bottom 10 Vertically
                                          ),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      whislistCounter >= 1
                                          ? MdiIcons.heart
                                          : MdiIcons.heartOutline,
                                      size: 20.0,
                                      color: Palette.contrastColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
  }
}
