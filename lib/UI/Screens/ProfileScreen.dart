import 'package:flutter/material.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/searchCubit.dart';
import 'package:instagram/UI/Screens/SearchScreen.dart';
import 'package:instagram/UI/Widgets/highlightsWidget.dart';
import 'package:instagram/UI/Widgets/numbersWidget.dart';
import 'package:instagram/UI/Widgets/postWidget.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  UserData userData;
   ProfileScreen({super.key, required this.userData});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowed= false;
  int Followers = 5678;
  final searchCubit = SearchCubit(supabase: Supabase.instance.client);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35, left: 10),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(searchCubit:searchCubit)));
                  },
                      icon:Icon(Icons.arrow_back_ios)),
                  Spacer(),
                  Text(
                    "username ",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(onPressed: (){},
                      icon: Icon(Icons.notifications_none)),
                  IconButton(onPressed: (){},
                      icon:Icon(Icons.more_horiz))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundColor: Colors.white,
                    backgroundImage:AssetImage("assets/default pic.jpg") ,
                    radius: 50,
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        numbersWidget('1,234', 'Posts'),
                        numbersWidget('$Followers', 'Followers'),
                        numbersWidget('9,101', 'Following'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'name',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Column(
                    children: [
                        Text("bla bla")
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            width: 340,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: isFollowed ? colorsManager.greyColor : colorsManager.blueColor,
                            ),

                              child: Center(
                                  child: Text(isFollowed ? "Unfollow" : "Follow",
                              style: TextStyle(
                                color: isFollowed ? Colors.black : Colors.white
                              ),)),
                            ),
                          onTap: (){
                            setState(() {
                              isFollowed = !isFollowed;
                              isFollowed ? Followers ++ : Followers --;
                            });
                          },
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 6,
                      itemBuilder: (context, index) => highlightsWidget(),
                    ),
                  ),
                  postWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
