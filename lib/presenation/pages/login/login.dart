
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/components/MyFormField.dart';
import '../../../core/utils/components/PublicButton.dart';
import '../../../core/utils/components/constats.dart';
import '../../../core/utils/components/loading_manager.dart';
import '../layout/board.dart';
import 'changePass.dart';
import 'cubit/cubit.dart';
import 'cubit/state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

    systemOverlayStyle: SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    ),
    title: Text('Login'),
    centerTitle: true,
    ),


      backgroundColor: Colors.blue.shade900,


      body: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
        if (state is LoginSuccessState) {
          String group = state.group;

          navigateAndKill(context, Board(
            groupTitle: group,
          ),);

        }
      }, builder: (context, state) {
        return LoadingManager(
          color: Colors.white,
          isLoading: state is LoginLoadingState,
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
                      controller: _usernameController,
                      type: TextInputType.text,
                      hint: 'email',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      validation: (value) {
                        if (value.isEmpty) {
                          return " userName cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MyFormField(
                      maxLines: 1,
                      textCapitalization: TextCapitalization.none,

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

                    SizedBox(height: 16,),

                    SizedBox(
                      height: 50.0,
                      child: PublicButton(
                        backgroundColor: Colors.white,
                        textColor: Colors.blue,
                        function: () async {
                          if (_formKey.currentState!.validate()) {
                            await LoginCubit.get(context).userLogin(
                              email: _usernameController.text,
                              password: _passwordController.text,
                              co: context,
                            );
                          }
                        },
                        text: 'Login',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: (){
                          navigateTo(context, ChangePasswordScreen());
                        }, child: Text("Change Password",style: TextStyle(color: Colors.white,),))
                      ],),

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
        );
      }));

  }
}
