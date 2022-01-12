// ignore_for_file: file_names, unnecessary_new

import 'dart:convert';
import 'dart:io';

import 'package:apple_sign_in_safety/apple_sign_in.dart' as ap;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import 'package:news_app/Helper/Color.dart';
import 'package:news_app/Helper/Constant.dart';
import 'package:news_app/Helper/Session.dart';
import 'package:news_app/ManagePref.dart';
import 'package:news_app/SignUp.dart';
import 'package:news_app/Helper/String.dart';
import 'package:news_app/RequestOtp.dart';
import 'package:news_app/select_channel.dart';
import 'Privacy.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  bool _isNetworkAvail = true;
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? id, name, email, pass, mobile, type, status, profile, confpass;
  String? uid;
  String? userEmail;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //show snackbar msg
  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: isDark! ? colors.tempdarkColor : colors.bgColor,
      elevation: 1.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: [
                // Image.network(
                //   "https://image.freepik.com/free-vector/mobile-login-concept-illustration_114360-83.jpg",
                //   height: 300,
                //   fit: BoxFit.cover,
                // ),
                showContent(),
              ],
            ),
            showCircularProgress(isLoading, colors.primary)
          ],
        ));
  }

  //show form content
  showContent() {
    return SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
            top: 0.0, bottom: 20.0, start: 20.0, end: 20.0),
        child: Form(
            key: _formkey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  loginTxt(),
                  emailSet(),
                  passSet(),
                  forgotPassSet(),
                  loginBtn(),
                  skipBtn(),
                  dontHaveAccTxt(),
                  dividerOr(),
                  bottomBtn(),
                  termPolicyTxt(),
                ])));
  }

  //set skip login btn
  skipBtn() {
    return InkWell(
      child: Align(
          alignment: Alignment.center,
          child: Container(
              margin: EdgeInsets.only(top: 8),
              height: 44,
              width: deviceWidth! * 0.6,
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.boxColor,
                  // boxShadow: <BoxShadow>[
                  //   BoxShadow(
                  //       color: colors.tempfontColor1.withOpacity(0.4),
                  //       blurRadius: 2.0,
                  //       offset: Offset(0.0, 0.3),
                  //       spreadRadius: 0.1)
                  // ],
                  borderRadius: BorderRadius.circular(15.0)),
              child: Center(child: Text("Skip"))
              // SvgPicture.asset(
              //   "assets/images/skip_icon.svg",
              //   semanticsLabel: 'skip icon',
              // )
              )),
      onTap: () {
        setPrefrenceBool(ISFIRSTTIME, true);
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
      },
    );
  }

  loginTxt() {
    return Padding(
      padding: EdgeInsets.only(top: 35.0),
      child: Column(
        children: [
          Text(
            "Bharat Metro",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Login to your existing account",
                style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          ),
        ],
      ),
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  emailSet() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: TextFormField(
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        controller: emailC,
        style: Theme.of(this.context)
            .textTheme
            .subtitle1
            ?.copyWith(color: Theme.of(context).colorScheme.fontColor),
        validator: (val) => emailValidation(val!, context),
        onChanged: (String value) {
          setState(() {
            email = value;
          });
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, emailFocus, passFocus);
        },
        decoration: InputDecoration(
          hintText: getTranslated(context, 'email_lbl')!,
          hintStyle: Theme.of(this.context)
              .textTheme
              .subtitle1
              ?.copyWith(color: Theme.of(context).colorScheme.fontColor),
          filled: true,
          fillColor: Theme.of(context).colorScheme.boxColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(60.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(60.0),
          ),
        ),
      ),
    );
  }

  passSet() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          focusNode: passFocus,
          textInputAction: TextInputAction.done,
          controller: passC,
          style: Theme.of(this.context).textTheme.subtitle1?.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
              ),
          validator: (val) => passValidation(val!, context),
          onChanged: (String value) {
            setState(() {
              pass = value;
            });
          },
          decoration: InputDecoration(
            hintText: getTranslated(context, 'pass_lbl'),
            hintStyle: Theme.of(this.context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                ),
            suffixIcon: Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/eye_icon.svg",
                    semanticsLabel: 'eye icon',
                    height: 11.0,
                    width: 11.0,
                    color: Theme.of(context).colorScheme.fontColor,
                  ),
                  onPressed: () {},
                )),
            filled: true,
            fillColor: Theme.of(context).colorScheme.boxColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 17),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(60.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ));
  }

  forgotPassSet() {
    return Padding(
        padding: EdgeInsets.only(top: 15.0),
        child: Align(
          alignment: Alignment.topRight,
          child: InkWell(
            child: Text(
              getTranslated(context, 'forgot_pass_lbl')!,
              style: Theme.of(this.context).textTheme.subtitle1?.copyWith(
                    color: colors.primary,
                  ),
            ),
            onTap: () {},
          ),
        ));
  }

  //sign in with email and password in firebase
  signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // checking if uid or email is null
        assert(user.uid != null);
        assert(user.email != null);

        uid = user.uid;
        userEmail = user.email;

        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User? currentUser = _auth.currentUser;
        assert(user.uid == currentUser?.uid);

        String? name = user.displayName;

        if (name == null || name.trim().length == 0) {
          name = email.split("@")[0];
        }
        print("uid***${user.uid}");
        setState(() {
          isLoading = false;
        });
        if (userCredential.user!.emailVerified) {
          getLoginUser(user.uid, name, login_email, email, "", "", false);
        } else {
          setSnackbar(getTranslated(context, 'verify_email_msg')!);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('**Error: $e');
      String _errorMessage = e.toString();
      setSnackbar(_errorMessage);
    }
  }

  //sign in with google
  signInWithGoogle() async {
    try {
      await Firebase.initializeApp();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous);

        assert(await user.getIdToken() != null);

        final User? currentUser = _auth.currentUser;
        assert(user.uid == currentUser?.uid);

        String? name = user.displayName != null ? user.displayName : "";

        String? mobile = user.phoneNumber != null ? user.phoneNumber : "";

        String? profile = user.photoURL != null ? user.photoURL : "";

        String? email = user.email != null ? user.email : "";

        getLoginUser(
            user.uid, name!, login_gmail, email!, mobile!, profile!, true);
      }
    } catch (e) {
      String _errorMessage = e.toString();
      setSnackbar(_errorMessage);
    }
  }

  Future<String?> _SignInWithFB() async {
    FacebookLogin _login = FacebookLogin();
    if (await _login.isLoggedIn) _login.logOut();

    final result = await _login.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (result.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken accessToken = result.accessToken!;

        AuthCredential authCredential =
            FacebookAuthProvider.credential(accessToken.token);
        User? mainuser =
            (await _auth.signInWithCredential(authCredential)).user;

        if (mainuser != null) {
          assert(mainuser.uid != null);
          assert(mainuser.displayName != null);

          String? name =
              mainuser.displayName != null ? mainuser.displayName : "";

          String? mobile =
              mainuser.phoneNumber != null ? mainuser.phoneNumber : "";

          String? profile = mainuser.photoURL != null ? mainuser.photoURL : "";

          String? email = mainuser.email != null ? mainuser.email : "";

          getLoginUser(
              mainuser.uid, name!, login_fb, email!, mobile!, profile!, true);
        }
        break;
      case FacebookLoginStatus.error:
        setState(() {
          isLoading = false;
        });
        setSnackbar(result.error.toString());
        break;
      case FacebookLoginStatus.cancel:
        setState(() {
          isLoading = false;
        });
        setSnackbar(getTranslated(context, 'cancle_login')!);
        break;
    }
    return null;
  }

  void updateFCM(String? token) async {
    if (CUR_USERID != null && CUR_USERID != "") {
      try {
        Map<String, String> body = {
          ACCESS_KEY: access_key,
          USER_ID: CUR_USERID,
          "fcm_id": token!,
        };
        Response response =
            await post(Uri.parse(updateFCMIdApi), body: body, headers: headers)
                .timeout(Duration(seconds: timeOut));
        var getdata = json.decode(response.body);
        token1 = token;
        print("getdata***noti************$getdata");
      } on Exception catch (_) {}
    }
  }

  //login user using api
  Future<void> getLoginUser(String firebase_id1, String name1, String type1,
      String email1, String mobile1, String profile1, bool loading) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        FIREBASE_ID: firebase_id1,
        NAME: name1,
        EMAIL: email1,
        TYPE: type1,
        ACCESS_KEY: access_key,
      };

      setState(() {
        isLoading = true;
      });

      if (mobile1 != "") {
        param[MOBILE] = mobile1;
      }
      if (profile1 != "") {
        param[PROFILE] = profile1;
      }

      Response response =
          await post(Uri.parse(getUserSignUpApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getData = json.decode(response.body);

      String error = getData["error"];
      String msg = getData["message"];

      if (error == "false") {
        var i = getData["data"];
        id = i[ID];
        name = i[NAME];
        email = i[EMAIL];
        mobile = i[MOBILE];
        profile = i[PROFILE];
        type = i[TYPE];
        status = i[STATUS];
        String isFirstLogin = i["is_login"];
        CUR_USERID = id!;
        CUR_USERNAME = name!;
        CUR_USEREMAIL = email!;
        saveUserDetail(id!, name!, email!, mobile!, profile!, type!, status!);

        if (status == "0") {
          setSnackbar(getTranslated(context, 'deactive_msg')!);
        } else {
          setSnackbar(getTranslated(context, 'login_msg')!);
          FirebaseMessaging.instance.getToken().then((token) async {
            print("token*************$token");
            if (token != token1) {
              updateFCM(token);
            }
          });
          if (isFirstLogin == "1") {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ManagePref(
                          from: 2,
                        )),
                (Route<dynamic> route) => false);
          } else {
            getUserByCat().whenComplete(() {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute<void>(
              //         builder: (BuildContext context) => const SelectChannel()),
              //     (route) => false);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  "/home", (Route<dynamic> route) => false);
            });
          }
        }
      } else {
        if (_auth != null) _auth.signOut();
        setSnackbar(msg);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      });
    }
  }

  Future<void> getUserByCat() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
      };
      Response response = await post(Uri.parse(getUserByCatIdApi),
              body: param, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      String error = getdata["error"];
      if (error == "false") {
        var data = getdata["data"];
        setState(() {
          String catId = data[0]["category_id"];
          setPrefrence(cur_catId, catId);
        });
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  //check validation of form data
  bool validateAndSave() {
    final form = _formkey.currentState;
    form!.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  //set forgot password bottomsheet
  forgotPassBottomSheet() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (builder) {
          return Container(
              padding: EdgeInsetsDirectional.only(
                  bottom: 20.0, top: 5.0, start: 20.0, end: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Theme.of(context).colorScheme.boxColor),
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                      key: _formkey2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  child: SvgPicture.asset(
                                    "assets/images/close_icon.svg",
                                    semanticsLabel: 'close icon',
                                    height: 23,
                                    width: 23,
                                    color:
                                        Theme.of(context).colorScheme.darkColor,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  })),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 10.0),
                              child: Text(
                                getTranslated(context, 'forgt_pass_head')!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                    ),
                              )),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 10.0),
                              child: Text(
                                getTranslated(context, 'forgot_pass_sub')!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                    ),
                              )),
                          Padding(
                              padding: EdgeInsetsDirectional.only(top: 25.0),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: emailC,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor),
                                validator: (val) =>
                                    emailValidation(val!, context),
                                onChanged: (String value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      getTranslated(context, 'email_enter_lbl'),
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor),
                                  filled: true,
                                  fillColor:
                                      Theme.of(context).colorScheme.boxColor,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 17),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .borderColor
                                            .withOpacity(0.7)),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .borderColor
                                            .withOpacity(0.7),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              )),
                          Center(
                            child: InkWell(
                              child: Container(
                                height: 48.0,
                                width: deviceWidth! * 0.6,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(7.0)),
                                child: Text(
                                  getTranslated(context, 'submit_btn')!,
                                  style: Theme.of(this.context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          color: colors.tempboxColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 21,
                                          letterSpacing: 0.6),
                                ),
                              ),
                              onTap: () async {
                                final form = _formkey2.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  _isNetworkAvail = await isNetworkAvailable();
                                  if (_isNetworkAvail) {
                                    Future.delayed(Duration(seconds: 1))
                                        .then((_) async {
                                      _auth.sendPasswordResetEmail(
                                          email: email!.trim());
                                      setSnackbar(getTranslated(
                                          context, 'pass_reset')!);
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    Future.delayed(Duration(seconds: 1))
                                        .then((_) async {
                                      setSnackbar(getTranslated(
                                          context, 'internetmsg')!);
                                    });
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ))));
        });
  }

  //set login with email and password btn
  loginBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: InkWell(
        child: Container(
          height: 48.0,
          width: deviceWidth! * 0.6,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius: BorderRadius.circular(60.0),
          ),
          child: Text(
            getTranslated(context, 'login_btn')!,
            style: Theme.of(this.context).textTheme.headline6?.copyWith(
                color: colors.tempboxColor,
                fontWeight: FontWeight.w600,
                fontSize: 21,
                letterSpacing: 0.6),
          ),
        ),
        onTap: () async {
          if (validateAndSave()) {
            _isNetworkAvail = await isNetworkAvailable();
            if (_isNetworkAvail) {
              setState(() {
                isLoading = true;
              });
              signInWithEmailPassword(email!.trim(), pass!);
            } else {
              setSnackbar(getTranslated(context, 'internetmsg')!);
            }
          }
        },
      ),
    );
  }

//set have not account text
  dontHaveAccTxt() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsetsDirectional.only(top: 30.0),
      child: Column(
        children: <Widget>[
          Text(getTranslated(context, 'donthaveacc_lbl')!,
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .fontColor
                      .withOpacity(0.8))),
          InkWell(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SignUp()));
              },
              child: Text(
                getTranslated(context, 'create_acc_lbl')!,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    color: colors.primary, fontWeight: FontWeight.w600),
              ))
        ],
      ),
    );
  }

  //set divider on text
  dividerOr() {
    return Padding(
        padding: EdgeInsetsDirectional.only(top: 40.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Divider(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              endIndent: 20,
              thickness: 1.0,
            )),
            Text(
              getTranslated(context, 'or_lbl')!,
              style: Theme.of(context).textTheme.subtitle1?.merge(TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .fontColor
                        .withOpacity(0.7),
                  )),
            ),
            Expanded(
                child: Divider(
              color: Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
              indent: 20,
              thickness: 1.0,
            )),
          ],
        ));
  }

  googleBtn() {
    return InkWell(
      child: Container(
        height: 54,
        width: 54,
        padding: EdgeInsets.all(9.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).colorScheme.boxColor,
            border: Border.all(
                color:
                    Theme.of(context).colorScheme.borderColor.withOpacity(0.7),
                width: 1.8)),
        child: SvgPicture.asset(
          "assets/images/google_button.svg",
          semanticsLabel: 'Google Btn',
        ),
      ),
      onTap: () {
        signInWithGoogle();
      },
    );
  }

  fbBtn() {
    return Padding(
        padding: EdgeInsetsDirectional.only(start: 10.0),
        child: InkWell(
          child: Container(
            height: 54,
            width: 54,
            padding: EdgeInsets.all(9.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).colorScheme.boxColor,
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .borderColor
                        .withOpacity(0.7),
                    width: 1.8)),
            child: SvgPicture.asset(
              "assets/images/facebook_button.svg",
              semanticsLabel: 'facebook Btn',
            ),
          ),
          onTap: () {
            _SignInWithFB();
          },
        ));
  }

  phoneBtn() {
    return Padding(
        padding: EdgeInsetsDirectional.only(start: 10.0),
        child: InkWell(
          child: Container(
            height: 54,
            width: 54,
            padding: EdgeInsets.all(9.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Theme.of(context).colorScheme.boxColor,
                border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .borderColor
                        .withOpacity(0.7),
                    width: 1.8)),
            child: SvgPicture.asset(
              "assets/images/phone_button.svg",
              semanticsLabel: 'phone Btn',
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => RequestOtp()));
          },
        ));
  }

  appleBtn() {
    return Platform.isIOS
        ? Padding(
            padding: EdgeInsetsDirectional.only(start: 10.0),
            child: InkWell(
              child: Container(
                height: 54,
                width: 54,
                padding: EdgeInsets.all(9.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Theme.of(context).colorScheme.boxColor,
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .borderColor
                            .withOpacity(0.7),
                        width: 1.8)),
                child: SvgPicture.asset(
                  "assets/images/apple_logo.svg",
                  semanticsLabel: 'apple logo',
                ),
              ),
              onTap: () {
                signInWithApple();
              },
            ))
        : Container();
  }

  Future<String?> signInWithApple() async {
    try {
      final ap.AuthorizationResult appleResult =
          await ap.AppleSignIn.performRequests([
        ap.AppleIdRequest(requestedScopes: [ap.Scope.email, ap.Scope.fullName])
      ]);
      String? name;
      User? user;
      if (appleResult.status == AuthorizationStatus.authorized) {
        final appleIdCredential = appleResult.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        name = appleIdCredential.fullName!.familyName != "" &&
                appleIdCredential.fullName!.familyName != null
            ? appleIdCredential.fullName!.familyName
            : "Apple User";
        final authResult = await _auth.signInWithCredential(credential);
        user = authResult.user;
      } else if (appleResult.status == ap.AuthorizationStatus.error) {
        setSnackbar(appleResult.error.toString());
      } else if (appleResult.status == ap.AuthorizationStatus.cancelled) {
        setSnackbar('Sign in aborted by user');
      } else {
        setSnackbar('Sign in failed');
      }
      if (user != null) {
        assert(user.uid != null);
        String? email = user.email != null ? user.email : "";

        print("name****$name");

        getLoginUser(user.uid, name!, login_apple, email!, "", "", true);
      }
    } catch (error) {}
    return null;
  }

  bottomBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          googleBtn(),
          // fbBtn(),
          phoneBtn(),
          appleBtn(),
        ],
      ),
    );
  }

//set term and policy text
  termPolicyTxt() {
    return Padding(
        padding: EdgeInsets.only(bottom: 30.0, top: 25.0),
        child: Column(children: <Widget>[
          Text(
            getTranslated(context, 'agreeTermPolicy_lbl')!,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color:
                      Theme.of(context).colorScheme.fontColor.withOpacity(0.7),
                ),
          ),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Text(
                    getTranslated(context, 'term_lbl')!,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PrivacyPolicy(
                                  title: getTranslated(context, 'term_cond')!,
                                  from: getTranslated(context, 'login_lbl'),
                                )));
                  },
                ),
                Text(
                  getTranslated(context, 'and_lbl')!,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .fontColor
                            .withOpacity(0.7),
                      ),
                ),
                InkWell(
                  child: Text(
                    getTranslated(context, 'pri_policy')!,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: colors.primary,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PrivacyPolicy(
                                  title:
                                      getTranslated(context, 'privacy_policy')!,
                                  from: getTranslated(context, 'login_lbl'),
                                )));
                  },
                ),
              ])
        ]));
  }
}
