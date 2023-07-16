
import 'package:Administration/presenation/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/components/MyFormField.dart';
import '../../../core/utils/components/PublicButton.dart';
import '../../../core/utils/components/constats.dart';
import '../../../core/utils/components/loading_manager.dart';
import '../layout/board.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _groupController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text('Add User'),
          centerTitle: true,
          leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_sharp,color: Colors.white,),),
        ),


        backgroundColor: Colors.blue.shade900,


        body: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
          if (state is RegisterSuccessState) {


            navigateAndKill(context, Board(groupTitle: "MANAGER"));

          }
        }, builder: (context, state) {
          return LoadingManager(
            color: Colors.white,
            isLoading: state is RegisterLoadingState,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Image.asset(
                        'assets/logo.png',
                        height: 175,



                      ),

                      MyFormField(
                        textCapitalization: TextCapitalization.none,

                        maxLines: 1,
                        title: ' ',
                        readonly: false,
                        controller: _nameController,
                        type: TextInputType.text,
                        hint: 'Full name',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return " user name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MyFormField(
                        textCapitalization: TextCapitalization.none,

                        maxLines: 1,
                        title: ' ',
                        readonly: false,
                        controller: _emailController,
                        type: TextInputType.text,
                        hint: 'email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return " email cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MyFormField(
                        textCapitalization: TextCapitalization.none,

                        maxLines: 1,
                        suffixIcon: LoginCubit.get(context).suffix,
                        isPassword: LoginCubit.get(context).isPassword,
                        suffixIconPressed: () {

                          LoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        title: ' ',
                        readonly: false,
                        controller: _passwordController,
                        type: TextInputType.text,
                        hint: 'Enter Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return " password cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MyFormField(
                        textCapitalization: TextCapitalization.characters,

                        maxLines: 1,
                        title: ' ',
                        readonly: false,
                        controller: _groupController,
                        type: TextInputType.text,
                        hint: 'Group',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty ) {
                            return " group cannot be empty";
                          }
                          else if (!RegExp(r'^[A-Z]+$').hasMatch(value)) {
                            // Check if value contains only capital letters
                            return "Group name must contain only capital letters";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16,),

                      SizedBox(
                        height: 50.0,
                        child: PublicButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.blue,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              await LoginCubit.get(context).addUser(
                                email: _emailController.text,
                                password: _passwordController.text,

                                co: context, name: _nameController.text, Group: _groupController.text,
                              );
                            }
                          },
                          text: 'Register',
                        ),
                      ),


                      const SizedBox(height: 40),

                      Text(
                        "Tasks Team",
                        style: GoogleFonts.actor(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Administration",
                        style: GoogleFonts.actor(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),




                    ],
                  ),
                ),
              ),
            ),
          );
        }));

  }
}
