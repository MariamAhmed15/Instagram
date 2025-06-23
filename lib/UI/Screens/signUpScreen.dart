import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/Data/userModel.dart';
import 'package:instagram/Logic/Cubit/signUpCubit.dart';
import 'package:instagram/Logic/State/SignUpState.dart';
import 'package:instagram/UI/Screens/createProfileScreen.dart';
import 'package:instagram/UI/Screens/loginScreen.dart';
import 'package:instagram/core/colorsManager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  final SupabaseClient supabase;
  final UserData userData;
  final File? pickedImage;
  const SignUpScreen({super.key, required this.supabase, required this.pickedImage, required this.userData});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController= TextEditingController();
  TextEditingController passwordController= TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>SignUpCubit(Supabase.instance.client),
      child: BlocConsumer<SignUpCubit,signUpStates>(
        listener: (context,state){ if (state is signUpLoadingState){
          Center(
              child: CircularProgressIndicator()
          );
        }
        else if (state is signUpSuccessState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Sign Up is successful")
            ),
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateProfileScreen(supabase: widget.supabase,userData: widget.userData,pickedImage: widget.pickedImage,),
          )
          );
        }else if(state is signUpErrorState){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)
            ),
          );
        }
        },
        builder: (context, state){
          return Scaffold(
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
                      obscureText: obscureText,
                      controller: passwordController,
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
                  Container(
                    width: 350,
                    height: 50,
                    child: InkWell(
                      onTap: (){
                        final email=emailController.text;
                        final password =passwordController.text;
                        context.read<SignUpCubit>().signUp(
                            email: email,
                            password:password
                        );
                      },
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: colorsManager.blueColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  SizedBox(
                      height:15
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an Account?",
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
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>loginScreen(supabase: widget.supabase,userData: widget.userData,pickedImage: widget.pickedImage,)
                          )
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
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