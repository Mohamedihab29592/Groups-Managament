
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/components/MyFormField.dart';
import '../../../core/utils/components/PublicButton.dart';
import '../../../core/utils/components/constats.dart';
import '../../../core/utils/components/loading_manager.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';
import 'login.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade900,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text('Change Password'),
          centerTitle: true,
        ),
        body: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            if (state is ChangePasswordState) {
              navigateAndKill(context, LoginScreen());
            }
          },
          builder: (context, state) => LoadingManager(
            color: Colors.white,
            isLoading: state is LoadingPasswordState,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 20,top: 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo.png',

                        height: 175,



                      ),

                      MyFormField(
                        textCapitalization: TextCapitalization.none,
                        maxLines: 1,
                        title: ' ',
                        readonly: false,
                        controller: _emailController,
                        type: TextInputType.text,
                        hint: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return " Email cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MyFormField(
                        textCapitalization: TextCapitalization.none,
                        title: " ",
                        maxLines: 1,
                        suffixIcon: LoginCubit.get(context).suffix,
                        isPassword: LoginCubit.get(context).isPassword,
                        suffixIconPressed: () {

                          LoginCubit.get(context)
                              .changePasswordVisibility();
                        },
                        readonly: false,
                        controller: _currentPasswordController,
                        type: TextInputType.text,
                        hint: 'Current Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return " Current Password cannot be empty";
                          }
                          return null;
                        },
                      ),
                      MyFormField(
                        textCapitalization: TextCapitalization.none,
                        isPassword: LoginCubit.get(context).isPassword,
                        title: '',
                        maxLines: 1,

                        readonly: false,
                        controller: _newPasswordController,
                        type: TextInputType.text,
                        hint: 'New Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        validation: (value) {
                          if (value.isEmpty) {
                            return "New Password cannot be empty";
                          }
                          if (value.length < 8) {
                            return "Password must be at least 8 characters long";
                          }
                          if (!value.contains(RegExp(r'\d'))) {
                            return "Password must contain at least 1 number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      SizedBox(
                        height: 50.0,
                        child: PublicButton(
                          backgroundColor: Colors.white,
                          textColor: Colors.blue,
                          function: () async {
                            if (_formKey.currentState!.validate()) {
                              await LoginCubit.get(context).changePassword(
                                email: _emailController.text,
                                co: context,
                                OldPass: _currentPasswordController.text,
                                NewPass: _newPasswordController.text,
                              );
                            }
                          },
                          text: 'Change Password',
                        ),
                      ),

                      const SizedBox(height: 60),

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
          ),
        ));
  }
}
