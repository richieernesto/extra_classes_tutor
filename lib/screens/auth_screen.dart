
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthScreen extends StatefulWidget {
  //const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
   bool _isLoading = false;
   bool _isLogin = true;
  String _username = "";
  String _password = "";
  String _fullName = "";
  final _auth = FirebaseAuth.instance;
  

  void _trySubmit()async{
    UserCredential authResult;
    try{
      setState(() {
        _isLoading = true;
      });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    
    if(isValid){
      _formKey.currentState!.save();
      if(_isLogin){
        authResult = await _auth.signInWithEmailAndPassword(email: _username, password: _password);
      }
      else{
        authResult = await _auth.createUserWithEmailAndPassword(email: _username, password: _password);
        await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'username': _username, 'fullname': _fullName
        });
      }

    }
    
    } on PlatformException catch(err){
      var message = "An Error Occured";

      if (err.message != null){
        message = err.message!;
      }
      Fluttertoast.showToast(msg: message);
      setState(() {
        _isLoading = false;
      });
    }
    catch(err){
      print(err){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  height: size.height,
                  child: Image.asset(
                    'lib/assets/images/bgimage.jpg',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 25, sigmaX: 25),
                            child: Form(
                              key: _formKey,
                              child: SizedBox(
                                width: size.width * .8,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'SIGN IN',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withOpacity(.8),
                                        ),
                                      ),
                                    ),

                                    if (!_isLogin) Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        onSaved: (value){
                                          _fullName = value!;
                                        },
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.9),
                                        ),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            (Icons.person),
                                            color: Colors.white.withOpacity(.8),
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: "Full Name",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                        validator: (value){
                                          if (value == null){
                                            return "Name Not entered";
                                          }
                                          if(value != null && value.length <8 ){
                                            return "Invalid Name";
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        onSaved: (value){
                                          _username = value!;
                                        },
                                        validator: (value){
                                          if (value != null && !value.contains("@") && value.length < 7){
                                            return "Invalid email";
                                          }
                                          if (value == null){
                                            return "No Email Entered";
                                          }
                                        },
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.9),
                                        ),
                                        //obscureText: isPassword,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            (Icons.account_circle_rounded),
                                            color: Colors.white.withOpacity(.8),
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: "Email",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        onSaved: (value){
                                          _password = value!;
                                        },
                                        validator: (value){
                                          if(value==null){
                                            return "No password entered";
                                          }
                                          if (value.length > 7){
                                            return "Password must be at least 7 characters";
                                          }
                                        },
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.9),
                                        ),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            (Icons.password),
                                            color: Colors.white.withOpacity(.8),
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!_isLogin)
                                    Container(
                                      height: size.width / 8,
                                      width: size.width / 1.25,
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(
                                          right: size.width / 30),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: TextFormField(

                                        validator: (value){
                                          if (value == null){
                                            return "Enter Password again!";
                                          }
                                          if (value != _passwordController.text){
                                            return "Paswords dont Match";
                                          }
                                          
                                        },
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(.9),
                                        ),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            (Icons.password),
                                            color: Colors.white.withOpacity(.8),
                                          ),
                                          border: InputBorder.none,
                                          hintMaxLines: 1,
                                          hintText: "Confirm Password",
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        if (_isLogin) GestureDetector(
                                          child: Text(
                                            'Forgotten password!',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                           
                                          ),
                                          onTap: (){},
                                        ),
                                        GestureDetector(
                                          child: Text(
                                            _isLogin? "Sign Up Instead" : "Sign In",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              _isLogin = !_isLogin;
                                            });
                                          }
                                        )
                                      ],
                                    ),
                                    SizedBox(),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: _trySubmit,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          bottom: size.width * .05,
                                        ),
                                        height: size.width / 8,
                                        width: size.width / 2.5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          _isLogin?  'Sign In' : "Sign Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
