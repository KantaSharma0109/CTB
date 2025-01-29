import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chef_taruna_birla/models/testimonial.dart';
import 'package:chef_taruna_birla/widgets/testimonials_form.dart';
import 'package:chef_taruna_birla/widgets/text_to_html.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
// import '../viewmodels/main_container_viewmodel.dart';
import 'image_placeholder.dart';

class Testimonials extends StatefulWidget {
  const Testimonials({Key? key}) : super(key: key);

  @override
  State<Testimonials> createState() => _TestimonialsState();
}

class _TestimonialsState extends State<Testimonials> {
  // List list = [];
  // bool isLoading = false;
  List<Testimonial> testimonials = [];
  bool isLoading = true;

  // void setImpBooks() {
  //   list.clear();
  //   Provider.of<MainContainerViewModel>(context, listen: false)
  //       .testimonial
  //       .forEach((testimonial) {
  //     list.add(
  //       Testimonial(
  //         id: testimonial.id,
  //         name: testimonial.name,
  //         message: testimonial.message,
  //         image_path: testimonial.image_path,
  //         profile_image: testimonial.profile_image,
  //       ),
  //     );
  //   });
  //   setState(() => isLoading = true);
  // }

  @override
  void initState() {
    super.initState();
    // setImpBooks();
    fetchTestimonials();
  }

  // Future<void> fetchTestimonials() async {
  //   // Replace with your API endpoint
  //   final response =
  //       await http.get(Uri.parse('${Constants.baseUrl}get_testimonials.php'));

  //   if (response.statusCode == 200) {
  //     // Decode the response body to get the testimonials data
  //     final data = json.decode(response.body);
  //     List<Testimonial> loadedTestimonials = [];

  //     for (var item in data['testimonials']) {
  //       loadedTestimonials.add(
  //         Testimonial(
  //           id: item['id'],
  //           name: item['name'],
  //           message: item['message'],
  //           image_path: item['image'],
  //           profile_image: item['profile_image'],
  //         ),
  //       );
  //     }

  //     setState(() {
  //       testimonials = loadedTestimonials;
  //       isLoading = false;
  //     });
  //   } else {
  //     throw Exception('Failed to load testimonials');
  //   }
  // }

  Future<void> fetchTestimonials() async {
    try {
      // Replace with your API endpoint
      final response =
          await http.get(Uri.parse('${Constants.baseUrl}get_testimonials.php'));

      if (response.statusCode == 200) {
        // Decode the response body to get the testimonials data
        final data = json.decode(response.body);
        List<Testimonial> loadedTestimonials = [];

        for (var item in data['testimonials']) {
          loadedTestimonials.add(
            Testimonial(
              id: item['id'],
              name: item['name'],
              message: item['message'],
              image_path: item['image'].isNotEmpty
                  ? item['image']
                  : 'default_placeholder.png', // Use default placeholder if image is empty
              profile_image: item['profile_image'].isNotEmpty
                  ? item['image']
                  : 'default_placeholder.png',
            ),
          );
        }

        setState(() {
          testimonials = loadedTestimonials;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load testimonials');
      }
    } catch (e) {
      print('Error fetching testimonials: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
  // final List<Testimonial> dummyTestimonials = [
  //   Testimonial(
  //     id: "1",
  //     name: "John Doe",
  //     message:
  //         "This is an amazing experience! Highly recommend,This is an amazing experience! Highly recommend.",
  //     image_path: "assets/images/0002.png",
  //     profile_image: "/images/profile1.jpg",
  //   ),
  //   Testimonial(
  //     id: "2",
  //     name: "Jane Smith",
  //     message: "Absolutely loved it! Will come back again for sure.",
  //     image_path: "/images/testimonial2.jpg",
  //     profile_image: "/images/profile2.jpg",
  //   ),
  //   Testimonial(
  //     id: "3",
  //     name: "Robert Brown",
  //     message: "Great service and friendly staff!",
  //     image_path: "/images/testimonial3.jpg",
  //     profile_image: "/images/profile3.jpg",
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(), // Show a loading indicator
          )
        : testimonials.isEmpty
            ? Center(
                child: Text(
                  'No testimonials available.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                    fontFamily: 'CenturyGothic',
                  ),
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // children: const [
                      //   Text(
                      //     'Testimonials',
                      //     style: TextStyle(
                      //       fontFamily: 'CenturyGothic',
                      //       fontSize: 24.0,
                      //       color: Palette.secondaryColor,
                      //     ),
                      //   ),

                      // ],
                      children: [
                        const Text(
                          'Testimonials',
                          style: TextStyle(
                            fontFamily: 'CenturyGothic',
                            fontSize: 24.0,
                            color: Palette.secondaryColor,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => const TestimonialsForm(),
                        //       ),
                        //     );
                        //   },
                        //   // child: const Icon(Icons.arrow_forward_ios,
                        //   //     size: 24.0, color: Palette.secondaryColor),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         'Add Yours',
                        //         style: TextStyle(
                        //           fontFamily: 'CenturyGothic',
                        //           fontSize: 15.0,
                        //           color: Palette.secondaryColor2,
                        //         ),
                        //       ),
                        //       SizedBox(
                        //           width:
                        //               2.0), // Add some space between text and icon
                        //       Icon(
                        //         Icons.arrow_forward_ios,
                        //         size: 15.0,
                        //         color: Palette.secondaryColor2,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the TestimonialsForm page when tapped
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TestimonialsForm(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Add Yours',
                                style: TextStyle(
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 15.0,
                                  color: Palette.secondaryColor2,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      2.0), // Add some space between text and icon
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15.0,
                                color: Palette.secondaryColor2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 400.0,
                    child: CarouselSlider.builder(
                      // itemCount: list.length,
                      itemCount: testimonials.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 1 / 1,
                        viewportFraction: 0.85,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 1500),
                        enlargeCenterPage: false,
                        // enableInfiniteScroll: list.length == 1 ? false : true,
                        enableInfiniteScroll:
                            testimonials.length == 1 ? false : true,
                      ),
                      itemBuilder: (context, index, realIdx) {
                        return Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Palette.shadowColor.withOpacity(0.1),
                                  blurRadius: 5.0, // soften the shadow
                                  spreadRadius: 0.0, //extend the shadow
                                  offset: const Offset(
                                    0.0, // Move to right 10  horizontally
                                    -0.0, // Move to bottom 10 Vertically
                                  ),
                                ),
                              ],
                              color: Palette.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          margin: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8.0),
                          // height: 100.0,
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => VideoPage(
                              //       url: _data['data'][i]['path'].toString(),
                              //     ),
                              //   ),
                              // );
                            },
                            child: Column(
                              children: [
                                // Expanded(
                                //   flex: 4,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(5.0),
                                //     child: ClipRRect(
                                //       borderRadius: BorderRadius.circular(10.0),
                                //       child: CachedNetworkImage(
                                //         imageUrl: Constants.imgBackendUrl +
                                //             dummyTestimonials[index]
                                //                 .image_path
                                //                 .toString(),
                                //         placeholder: (context, url) =>
                                //             const ImagePlaceholder(),
                                //         errorWidget: (context, url, error) =>
                                //             const ImagePlaceholder(),
                                //         fit: BoxFit.cover,
                                //         width: double.infinity,
                                //         height: double.infinity,
                                //         alignment: Alignment.topCenter,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  height: 90.0,
                                  width: 90.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${Constants.baseUrl}${testimonials[index].profile_image}',

                                        // Constants.imgBackendUrl +
                                        //     testimonials[index].profile_image.toString(),
                                        placeholder: (context, url) =>
                                            const ImagePlaceholder(),
                                        errorWidget: (context, url, error) =>
                                            const ImagePlaceholder(),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                width: 15.0,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                testimonials[index].name,
                                                style: const TextStyle(
                                                  color: Palette.black,
                                                  fontSize: 20.0,
                                                  fontFamily:
                                                      'EuclidCircularA Medium',
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 0.0),
                                            child: TextToHtml(
                                              description: testimonials[index]
                                                          .message
                                                          .toString()
                                                          .length >=
                                                      250
                                                  ? '${testimonials[index].message.toString().substring(0, 250)}...'
                                                  : testimonials[index].message,
                                              textColor: Palette.grey,
                                              fontSize: 16.0,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
  }
}
