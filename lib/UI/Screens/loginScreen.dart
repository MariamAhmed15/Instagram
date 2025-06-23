import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/loginCubit.dart';
import 'package:instagram/Logic/State/loginState.dart';
import 'package:instagram/UI/Screens/newsFeedScreen.dart';
import 'package:instagram/UI/Screens/signUpScreen.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class loginScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;

  loginScreen({super.key,required this.supabase, required this.pickedImage, required this.userData});

  @override
  State<loginScreen> createState() => _loginScreenState();
}
class _loginScreenState extends State<loginScreen> {
  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>loginCubit(Supabase.instance.client),
      child: BlocConsumer<loginCubit, loginStates>(
        listener:  (context,state){
          if (state is loginLoadingState){
          Center(child: CircularProgressIndicator()
          );
        }
        else if (state is loginSuccessState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Login is successful"),
            ),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>newsFeedScreen(supabase:widget.supabase, userData: widget.userData, pickedImage: widget.pickedImage,)
          )
          );
        }else if(state is loginErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)
            ),
          );
        }
        },
        builder: (context, state){
          return  Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top:281
                        ),
                        child: Image.asset("assets/instagram text logo.png"),
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        color: colorsManager.greyColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: " Email",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:Colors.transparent
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 350,
                    height: 50,
                    decoration: BoxDecoration(
                        color: colorsManager.greyColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              }
                              );
                            },
                          ),
                          hintText: "Password",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:Colors.transparent
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  InkWell(
                    onTap: (){
                      final email=emailController.text;
                      final password =passwordController.text;
                      context.read<loginCubit>().login(
                          email: email,
                          password:password
                      );
                    },
                    child: Container(
                      width: 350,
                      height: 50,
                      child:  Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: colorsManager.blueColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(
                      height:15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Do not have an email?",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>SignUpScreen(supabase: widget.supabase,userData: widget.userData,pickedImage: widget.pickedImage,)
                              )
                          );
                        },
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
