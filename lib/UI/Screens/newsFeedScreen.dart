import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/postModel.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/createProfileCubit.dart';
import 'package:instagram/Logic/Cubit/searchCubit.dart';
import 'package:instagram/Logic/Cubit/storyCubit.dart';
import 'package:instagram/Logic/Providers/ThemeProviders.dart';
import 'package:instagram/UI/Screens/MyProfileScreen.dart';
import 'package:instagram/UI/Screens/SearchScreen.dart';
import 'package:instagram/UI/Screens/createPostScreen.dart';
import 'package:instagram/UI/Screens/createStoryScreen.dart';
import 'package:instagram/UI/Widgets/BottomBar.dart';
import 'package:instagram/UI/Widgets/postView.dart';
import 'package:instagram/UI/Widgets/storyWidget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'ReelsScreen.dart';

class newsFeedScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;
   newsFeedScreen({super.key, required this.supabase,
     required this.userData, required this.pickedImage
   });

  @override
  newsFeedScreenState createState() => newsFeedScreenState();
}

class newsFeedScreenState extends State<newsFeedScreen> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  final searchCubit = SearchCubit(supabase: Supabase.instance.client);

  int _selectedIndex = 0;
  List<Post> posts = [
    Post(
      description: "Welcome to Instagram!",
      username: "Instagram",
      likes: 0,
      postId: "post123",
      datePublished: DateTime.now(),
      postUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzWL38t2zy5lZ927BYUMZzCj9h7Kwnb_m-yg&s",
      profImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg6k1Wb6YMIVdxnvh9VErbhOqmY5-USUFlwA&s",
    ),
  ];
  @override
  bool get wantKeepAlive => true;

  void addPost(Post newPost) {
    setState(() {
      posts.insert(0, newPost);
    });
  }



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    super.build(context);

    return BlocProvider(
      create: (context) => StoryCubit()..getStories(),

      child: Scaffold(
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          themeProvider.themeMode == ThemeMode.light?
                          "assets/instagram text logo.png" :
                          "assets/Dark logo.png",
                          width: 104,
                          height: 30,),
                        Spacer(),
                        IconButton(onPressed: (){},
                            icon: Icon(Icons.favorite_outline_rounded,
                              size: 35,
                            )
                        ),
                        IconButton(onPressed:() {
                          showMenu<String>(
                              context: context,
                              position: RelativeRect.fromLTRB(100, 100, 100, 100),
                              items: [
                                PopupMenuItem<String>(
                                  value: 'create_post',
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      SizedBox(width: 8),
                                      Text('Create Post'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'create_story',
                                  child: Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      SizedBox(width: 8),
                                      Text('Create Story'),
                                    ],
                                  ),
                                )
                              ],
                          ).then((value) {
                            if (value == 'create_post') {
                         Navigator.push(context,  MaterialPageRoute(
                           builder: (context) => BlocProvider<CreateProfileCubit>(
                             create: (context) => CreateProfileCubit(),
                             child: createPostScreen(
                               supabase: widget.supabase,
                               userData: widget.userData,
                               pickedImage: widget.pickedImage,
                               onPostCreated: addPost,
                             ),
                           ),
                         ),
                         );
                            } else if (value == 'create_story') {
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>createStoryScreen()));
                            }
                          });
                        },
                            icon: Icon(Icons.add_box_outlined,
                              size: 35,
                            )
                        ),
                      ],
                    ),
                  ),
                  storyWidget(),
                  SizedBox(height: 10,),
                  SizedBox(
                    height:500,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top:  10),
                      scrollDirection: Axis.vertical,
                      itemBuilder:  (context, index) {
                        return PostViewWidget(post: posts[index]);
                      },
                      itemCount: posts.length,
                    ),
                  )
                ],
              ),
            ),
            SearchScreen(searchCubit: searchCubit),
            ReelsScreen(),
            MyProfileScreen(userData:widget.userData, pickedImage:widget.pickedImage, supabase:widget.supabase)
          ],
        ),
        bottomNavigationBar: BottomBar(
          pageController: _pageController,
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
