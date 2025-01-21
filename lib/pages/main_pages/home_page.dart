import 'package:chef_taruna_birla/viewmodels/product_page_viewmodel.dart';
import 'package:chef_taruna_birla/widgets/courses.dart';
import 'package:chef_taruna_birla/widgets/featured_courses.dart';
import 'package:chef_taruna_birla/widgets/featured_products.dart';
import 'package:chef_taruna_birla/widgets/feedback.dart';
import 'package:chef_taruna_birla/widgets/gallery.dart';
import 'package:chef_taruna_birla/widgets/our_social_links.dart';
import 'package:chef_taruna_birla/widgets/our_store.dart';
import 'package:chef_taruna_birla/widgets/product.dart';
import 'package:chef_taruna_birla/widgets/slider.dart';
import 'package:chef_taruna_birla/widgets/testimonials.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../config/config.dart';
import '../../viewmodels/course_page_viewmodel.dart';
import '../../viewmodels/main_container_viewmodel.dart';
import '../../widgets/books.dart';
import '../common/gallery_page.dart';
import '../common/webview_page.dart';
import '../profile/my_books.dart';
import '../profile/my_courses.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .appslider
              //               .isNotEmpty
              //           ? 20.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .appslider
              //         .isNotEmpty
              //     ? const AppSliderWidget()
              //     : const SizedBox(),
              const AppSliderWidget(),

              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 24.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyCourses(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Palette.contrastColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 0.0),
                              child: Text(
                                'My courses',
                                style: TextStyle(
                                  fontFamily: 'EuclidCircularA Regular',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyBooks(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Palette.contrastColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 0.0),
                              child: Text(
                                'My Books',
                                style: TextStyle(
                                  fontFamily: 'EuclidCircularA Regular',
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .courseCategories
              //               .isNotEmpty
              //           ? 20.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .courseCategories
              //         .isNotEmpty
              //     ? Padding(
              //         padding: EdgeInsets.symmetric(
              //           vertical: 0.0,
              //           horizontal: 24.0,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               'Our Courses',
              //               style: TextStyle(
              //                 fontFamily: 'CenturyGothic',
              //                 fontSize: 22.0,
              //                 color: Palette.secondaryColor,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Provider.of<CoursePageViewModel>(context,
              //                         listen: false)
              //                     .setSelectedCategory(
              //                         Provider.of<MainContainerViewModel>(
              //                                 context,
              //                                 listen: false)
              //                             .courseCategories[0]
              //                             .name);
              //                 Provider.of<MainContainerViewModel>(context,
              //                         listen: false)
              //                     .setIndex(2);
              //               },
              //               child: Row(
              //                 children: [
              //                   Text(
              //                     'See All',
              //                     style: TextStyle(
              //                       fontFamily: 'CenturyGothic',
              //                       fontSize: 15.0,
              //                       color: Palette.secondaryColor2,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                       width:
              //                           2.0), // Add some space between text and icon
              //                   Icon(
              //                     Icons.arrow_forward_ios,
              //                     size: 15.0,
              //                     color: Palette.secondaryColor2,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .courseCategories
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .courseCategories
              //         .isNotEmpty
              //     ? const Courses()
              //     : const SizedBox(),

              SizedBox(
                height: 20.0, // Space for the image between the two sections
              ),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  // Check if courseCategories are empty or still loading
                  if (model.courseCategories.isEmpty) {
                    return const Center(
                      child:
                          CircularProgressIndicator(), // Show loading indicator
                    );
                  }

                  return model.courseCategories.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 24.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Our Courses',
                                style: TextStyle(
                                  fontFamily: 'CenturyGothic',
                                  fontSize: 22.0,
                                  color: Palette.secondaryColor,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<CoursePageViewModel>(context,
                                          listen: false)
                                      .setSelectedCategory(
                                          model.courseCategories[0].name);
                                  Provider.of<MainContainerViewModel>(context,
                                          listen: false)
                                      .setIndex(2);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'See All',
                                      style: TextStyle(
                                        fontFamily: 'CenturyGothic',
                                        fontSize: 15.0,
                                        color: Palette.secondaryColor2,
                                      ),
                                    ),
                                    const SizedBox(width: 2.0),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15.0,
                                      color: Palette.secondaryColor2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                },
              ),

              SizedBox(
                height: 10.0, // Space for the image between the two sections
              ),
              SizedBox(
                height:
                    Provider.of<MainContainerViewModel>(context, listen: false)
                            .courseCategories
                            .isNotEmpty
                        ? 12.0
                        : 0.0,
              ),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  return model.courseCategories.isNotEmpty
                      ? const Courses()
                      : const SizedBox();
                },
              ),

              SizedBox(
                height: 20.0, // Space for the image between the two sections
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.0,
                  horizontal: 24.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      14.0), // Adjust the radius as needed
                  child: Image.asset(
                    'assets/images/home_img.png', // Replace with the path to your image
                    height: 150, // Set the desired height for the image
                    width: double
                        .infinity, // Set the image width to fill the screen
                    fit: BoxFit.cover, // Adjust the image fitting as needed
                  ),
                ),
              ),

              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .featured_courses
              //               .isNotEmpty
              //           ? 24.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .featured_courses
              //         .isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(
              //             left: 24.0, right: 24.0, top: 0.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text(
              //               'Featured Courses',
              //               style: TextStyle(
              //                 fontFamily: 'CenturyGothic',
              //                 fontSize: 22.0,
              //                 color: Palette.secondaryColor,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Provider.of<CoursePageViewModel>(context,
              //                         listen: false)
              //                     .setSelectedCategory(
              //                         Provider.of<MainContainerViewModel>(
              //                                 context,
              //                                 listen: false)
              //                             .courseCategories[0]
              //                             .name);
              //                 Provider.of<MainContainerViewModel>(context,
              //                         listen: false)
              //                     .setIndex(2);
              //               },
              //               child: Row(
              //                 children: [
              //                   Text(
              //                     'See All',
              //                     style: TextStyle(
              //                       fontFamily: 'CenturyGothic',
              //                       fontSize: 15.0,
              //                       color: Palette.secondaryColor2,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                       width:
              //                           2.0), // Add some space between text and icon
              //                   Icon(
              //                     Icons.arrow_forward_ios,
              //                     size: 15.0,
              //                     color: Palette.secondaryColor2,
              //                   ),
              //                 ],
              //               ),
              //               // child: const Icon(
              //               //   Icons.arrow_forward_ios,
              //               //   size: 24.0,
              //               //   color: Palette.secondaryColor,
              //               // ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .featured_courses
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .featured_courses
              //         .isNotEmpty
              //     ? const FeaturedCourses()
              //     : const SizedBox(),
              const SizedBox(height: 20.0),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  if (model.featured_courses.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Featured Courses',
                              style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 22.0,
                                color: Palette.secondaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<CoursePageViewModel>(context,
                                        listen: false)
                                    .setSelectedCategory(
                                        Provider.of<MainContainerViewModel>(
                                                context,
                                                listen: false)
                                            .courseCategories[0]
                                            .name);
                                Provider.of<MainContainerViewModel>(context,
                                        listen: false)
                                    .setIndex(2);
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 15.0,
                                      color: Palette.secondaryColor2,
                                    ),
                                  ),
                                  SizedBox(width: 2.0),
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
                      const SizedBox(height: 12.0),
                      FeaturedCourses()
                    ],
                  );
                },
              ),
              const SizedBox(height: 20.0),

              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .featured_products
              //               .isNotEmpty
              //           ? 24.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .featured_products
              //         .isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(
              //             left: 24.0, right: 24.0, top: 0.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text(
              //               'Featured Products',
              //               style: TextStyle(
              //                 fontFamily: 'CenturyGothic',
              //                 fontSize: 24.0,
              //                 color: Palette.secondaryColor,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Provider.of<ProductPageViewModel>(context,
              //                         listen: false)
              //                     .setSelectedCategory(
              //                         Provider.of<MainContainerViewModel>(
              //                                 context,
              //                                 listen: false)
              //                             .productCategories[0]
              //                             .name);
              //                 Provider.of<MainContainerViewModel>(context,
              //                         listen: false)
              //                     .setIndex(3);
              //               },
              //               child: const Icon(
              //                 Icons.arrow_forward_ios,
              //                 size: 24.0,
              //                 color: Palette.secondaryColor,
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .featured_products
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .featured_products
              //         .isNotEmpty
              //     ? const FeaturedProducts()
              //     : const SizedBox(),

              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .sociallinks
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .sociallinks
              //         .isNotEmpty
              //     ? const Padding(
              //         padding:
              //             EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
              //         child: Text(
              //           'Our Stores',
              //           style: TextStyle(
              //             fontFamily: 'CenturyGothic',
              //             fontSize: 24.0,
              //             color: Palette.secondaryColor,
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .sociallinks
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .sociallinks
              //         .isNotEmpty
              //     ? const OurStore()
              //     : const SizedBox(),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  // Check if sociallinks is not empty
                  bool hasSocialLinks = model.sociallinks.isNotEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add spacing based on whether sociallinks is not empty
                      SizedBox(
                        height: hasSocialLinks ? 12.0 : 0.0,
                      ),

                      // Show 'Our Stores' title if sociallinks is not empty
                      if (hasSocialLinks)
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 5.0),
                          child: Text(
                            'Our Stores',
                            style: TextStyle(
                              fontFamily: 'CenturyGothic',
                              fontSize: 24.0,
                              color: Palette.secondaryColor,
                            ),
                          ),
                        ),

                      // Add spacing based on whether sociallinks is not empty
                      SizedBox(
                        height: hasSocialLinks ? 12.0 : 0.0,
                      ),

                      // Show 'Our Store' widget if sociallinks is not empty
                      if (hasSocialLinks) const OurStore(),
                    ],
                  );
                },
              ),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .impBooks
              //               .isNotEmpty
              //           ? 18.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .impBooks
              //         .isNotEmpty
              //     ? Container(
              //         // color: Palette.contrastColor,
              //         child: const Books(),
              //       )
              //     : const SizedBox(),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  if (model.impBooks.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return model.impBooks.isNotEmpty
                      ? Container(
                          child: Container(child: const Books()),
                        )
                      : const SizedBox();
                },
              ),

              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .testimonial
              //               .isNotEmpty
              //           ? 24.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .testimonial
              //         .isNotEmpty
              //     ? Container(
              //         color: Palette.contrastColor,
              //         child: const Testimonials(),
              //       )
              //     : const SizedBox(),

              const Testimonials(),

              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .gallery
              //               .isNotEmpty
              //           ? 24.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .gallery
              //         .isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: 0.0,
              //           horizontal: 24.0,
              //         ),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text(
              //               'Our Gallery',
              //               style: TextStyle(
              //                 fontFamily: 'CenturyGothic',
              //                 fontSize: 24.0,
              //                 color: Palette.secondaryColor,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (context) => const GalleryPage(
              //                       itemId: '',
              //                       itemCategory: '',
              //                       isItemGallery: false,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               // child: const Icon(
              //               //   Icons.arrow_forward_ios,
              //               //   size: 24.0,
              //               //   color: Palette.secondaryColor,
              //               // ),
              //               child: Row(
              //                 children: [
              //                   Text(
              //                     'See All',
              //                     style: TextStyle(
              //                       fontFamily: 'CenturyGothic',
              //                       fontSize: 15.0,
              //                       color: Palette.secondaryColor2,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                       width:
              //                           2.0), // Add some space between text and icon
              //                   Icon(
              //                     Icons.arrow_forward_ios,
              //                     size: 15.0,
              //                     color: Palette.secondaryColor2,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .gallery
              //               .isNotEmpty
              //           ? 25.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .gallery
              //         .isNotEmpty
              //     ? const Padding(
              //         padding: EdgeInsets.symmetric(
              //           vertical: 0.0,
              //           horizontal: 24.0,
              //         ),
              //         child: Gallery(),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .gallery
              //               .isNotEmpty
              //           ? 24.0
              //           : 0.0,
              // ),

              const SizedBox(height: 20.0),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  if (model.productCategories.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recommended',
                              style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 22.0,
                                color: Palette.secondaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<ProductPageViewModel>(context,
                                        listen: false)
                                    .setSelectedCategory(
                                        Provider.of<MainContainerViewModel>(
                                                context,
                                                listen: false)
                                            .productCategories[0]
                                            .name);
                                Provider.of<MainContainerViewModel>(context,
                                        listen: false)
                                    .setIndex(2);
                              },
                              child: Row(
                                children: const [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 15.0,
                                      color: Palette.secondaryColor2,
                                    ),
                                  ),
                                  SizedBox(width: 2.0),
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
                      const SizedBox(height: 12.0),
                      Product(),
                      // FeaturedProducts()
                    ],
                  );
                },
              ),

              const SizedBox(height: 20.0),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  if (model.gallery.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Our Gallery',
                              style: TextStyle(
                                fontFamily: 'CenturyGothic',
                                fontSize: 24.0,
                                color: Palette.secondaryColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GalleryPage(
                                      itemId: '',
                                      itemCategory: '',
                                      isItemGallery: false,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontFamily: 'CenturyGothic',
                                      fontSize: 15.0,
                                      color: Palette.secondaryColor2,
                                    ),
                                  ),
                                  const SizedBox(width: 2.0),
                                  const Icon(
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
                      const SizedBox(height: 12.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0), // Adjust padding as needed
                        child:
                            Gallery(), // Assuming this widget displays the gallery
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20.0),
              FeedbackForm(),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const WebviewPage(
              //           url: 'http://www.cheftarunabirla.com/feedback1',
              //           title: 'Feedback',
              //         ),
              //       ),
              //     );
              //   },
              //   child: Container(
              //     margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10.0),
              //       border:
              //           Border.all(width: 2.0, color: Palette.secondaryColor2),
              //       color: Palette.secondaryColor2,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Palette.shadowColor.withOpacity(0.1),
              //           blurRadius: 5.0, // soften the shadow
              //           spreadRadius: 0.0, //extend the shadow
              //           offset: const Offset(
              //             0.0, // Move to right 10  horizontally
              //             0.0, // Move to bottom 10 Vertically
              //           ),
              //         ),
              //       ],
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //           top: 20.0, bottom: 15.0, left: 15.0, right: 15.0),
              //       child: Center(
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Text(
              //                 'Give Feedback/Enquiry',
              //                 style: TextStyle(
              //                   color: Palette.white,
              //                   fontSize: 20.0,
              //                   fontFamily: 'EuclidCircularA Medium',
              //                 ),
              //               ),
              //             ),
              //             Icon(
              //               MdiIcons.arrowRight,
              //               color: Palette.white,
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20.0,
              ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .sociallinks
              //         .isNotEmpty
              //     ? const Padding(
              //         padding:
              //             EdgeInsets.only(left: 24.0, right: 24.0, top: 0.0),
              //         child: Text(
              //           'Our Social Links',
              //           style: TextStyle(
              //             fontFamily: 'CenturyGothic',
              //             fontSize: 24.0,
              //             color: Palette.secondaryColor,
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
              // SizedBox(
              //   height:
              //       Provider.of<MainContainerViewModel>(context, listen: false)
              //               .sociallinks
              //               .isNotEmpty
              //           ? 12.0
              //           : 0.0,
              // ),
              // Provider.of<MainContainerViewModel>(context, listen: false)
              //         .sociallinks
              //         .isNotEmpty
              //     ? const Padding(
              //         padding: EdgeInsets.only(left: 24.0, right: 24.0),
              //         child: OurSocialLinks(),
              //       )
              //     : const SizedBox(),
              Consumer<MainContainerViewModel>(
                builder: (context, model, child) {
                  // Check if social links are available
                  if (model.sociallinks.isEmpty) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our Social Links',
                          style: TextStyle(
                            fontFamily: 'CenturyGothic',
                            fontSize: 24.0,
                            color: Palette.secondaryColor,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        // Display social links using OurSocialLinks widget
                        const OurSocialLinks(),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Center(
                child: Text(
                  'ⓒ cheftarunabirla, Inc.All rights reserved',
                  style: TextStyle(
                    fontFamily: 'Euclid Regular',
                    fontSize: 15.0,
                    color: Palette.secondaryColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
