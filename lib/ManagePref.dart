// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures, unnecessary_this, file_names

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:news_app/Helper/Constant.dart';

import 'Helper/Color.dart';
import 'Helper/Session.dart';
import 'Helper/String.dart';
import 'Model/Category.dart';

class ManagePref extends StatefulWidget {
  final int? from;

  const ManagePref({Key? key, this.from}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return StateManagePref();
  }
}

class StateManagePref extends State<ManagePref> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isNetworkAvail = true;
  bool _isLoading = true;
  List<Category> catList = [];
  String catId = "";
  List<String> selectedChoices = [];
  String selCatId = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
    getSetting().then((value) {
      getCat();
      getUserByCat();
    });
  }

  getUserDetails() async {
    CUR_USERID = await getPrefrence(ID) ?? "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey, appBar: getAppBar(), body: contentView());
  }

  //get settings api
  Future<void> getSetting() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var param = {
          ACCESS_KEY: access_key,
        };
        Response response =
            await post(Uri.parse(getSettingApi), body: param, headers: headers)
                .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getData = json.decode(response.body);
          String error = getData["error"];
          if (error == "false") {
            var data = getData["data"];
            category_mode = data[CATEGORY_MODE];
            comments_mode = data[COMM_MODE];
            breakingNews_mode = data[BREAK_NEWS_MODE];
            liveStreaming_mode = data[LIVE_STREAM_MODE];
            subCategory_mode = data[SUBCAT_MODE];
            if (data.toString().contains(FB_REWARDED_ID)) {
              fbRewardedVideoId = data[FB_REWARDED_ID];
            }
            if (data.toString().contains(FB_INTER_ID)) {
              fbInterstitialId = data[FB_INTER_ID];
            }
            if (data.toString().contains(FB_BANNER_ID)) {
              fbBannerId = data[FB_BANNER_ID];
            }
            if (data.toString().contains(FB_NATIVE_ID)) {
              fbNativeUnitId = data[FB_NATIVE_ID];
            }
            if (data.toString().contains(IOS_FB_REWARDED_ID)) {
              iosFbRewardedVideoId = data[IOS_FB_REWARDED_ID];
            }
            if (data.toString().contains(IOS_FB_INTER_ID)) {
              iosFbInterstitialId = data[IOS_FB_INTER_ID];
            }
            if (data.toString().contains(IOS_FB_BANNER_ID)) {
              iosFbBannerId = data[IOS_FB_BANNER_ID];
            }
            if (data.toString().contains(IOS_FB_NATIVE_ID)) {
              iosFbNativeUnitId = data[IOS_FB_NATIVE_ID];
            }
          }
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      setSnackbar(getTranslated(context, 'internetmsg')!);
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
      print("get data cat id************$getdata");

      String error = getdata["error"];
      if (error == "false") {
        var data = getdata["data"];

        for (int i = 0; i < data.length; i++) {
          catId = data[i]["category_id"];
        }
        setState(() {
          selectedChoices = catId == "" ? catId.split('') : catId.split(',');
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      setSnackbar(getTranslated(context, 'internetmsg')!);
    }
  }

  Future<void> getCat() async {
    if (category_mode == "1") {
      _isNetworkAvail = await isNetworkAvailable();
      if (_isNetworkAvail) {
        var param = {
          ACCESS_KEY: access_key,
        };
        Response response =
            await post(Uri.parse(getCatApi), body: param, headers: headers)
                .timeout(Duration(seconds: timeOut));
        var getdata = json.decode(response.body);

        String error = getdata["error"];

        if (error == "false") {
          catList.clear();
          var data = getdata["data"];
          catList = (data as List)
              .map((data) => new Category.fromJson(data))
              .toList();
          catList
              .removeWhere((element) => element.categoryName == 'Latest News');
          catList.removeWhere((element) => element.categoryName == 'तजा ख़बरें');

          if (mounted)
            setState(() {
              _isLoading = false;
            });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        setSnackbar(getTranslated(context, 'internetmsg')!);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //set skip login btn
  skipBtn() {
    return widget.from == 2
        ? Padding(
            padding: EdgeInsetsDirectional.only(end: 10.0),
            child: InkWell(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      height: 44,
                      width: 43,
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.boxColor,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: colors.tempfontColor1.withOpacity(0.4),
                                blurRadius: 2.0,
                                offset: Offset(0.0, 0.3),
                                spreadRadius: 0.1)
                          ],
                          borderRadius: BorderRadius.circular(15.0)),
                      child: SvgPicture.asset(
                        "assets/images/skip_icon.svg",
                        semanticsLabel: 'skip icon',
                      ))),
              onTap: () {
                setState(() {
                  _isLoading = false;
                });
                _setUserCat();
              },
            ))
        : Container();
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

  //set appbar
  getAppBar() {
    return PreferredSize(
        preferredSize: Size(double.infinity, 45),
        child: AppBar(
          leadingWidth: 50,
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            getTranslated(context, 'manage_prefrences')!,
            style: Theme.of(context).textTheme.headline6?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          actions: [skipBtn()],
          leading: Builder(builder: (BuildContext context) {
            return widget.from == 1
                ? Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 15.0, top: 5.0, bottom: 5.0),
                    child: Container(
                        height: 38,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.boxColor,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 10.0,
                                  offset: const Offset(5.0, 5.0),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .fontColor
                                      .withOpacity(0.1),
                                  spreadRadius: 1.0),
                            ],
                            borderRadius: BorderRadius.circular(6.0)),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            "assets/images/back_icon.svg",
                            semanticsLabel: 'back icon',
                            color: Theme.of(context).colorScheme.fontColor,
                          ),
                        )))
                : Container();
          }),
        ));
  }

  contentView() {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.only(
          start: 15.0, end: 15.0, top: 30.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [selectCatTxt(), catListContent(), saveBtn()],
      ),
    );
  }

  selectCatTxt() {
    return Center(
        child: Text(
      getTranslated(context, 'sel_pref_cat')!,
      style: Theme.of(context).textTheme.headline6?.copyWith(
          color: Theme.of(context).colorScheme.fontColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5),
    ));
  }

  catListContent() {
    return !_isLoading
        ? Padding(
            padding: EdgeInsetsDirectional.only(top: 25.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: catList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (selectedChoices.contains(catList[index].id)) {
                        selectedChoices.remove(catList[index].id);
                        setState(() {});
                      } else {
                        selectedChoices.add(catList[index].id!);
                        setState(() {});
                      }

                      if (selectedChoices.length == 0) {
                        setState(() {
                          selectedChoices.add("0");
                        });
                      } else {
                        if (selectedChoices.contains("0")) {
                          selectedChoices = List.from(selectedChoices)
                            ..remove("0");
                        }
                      }
                      print("select choise*****$selectedChoices");
                    },
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              children: [
                                Container(
                                    height: 70,
                                    width:
                                        MediaQuery.of(context).size.width / 3.5,
                                    child: Image(
                                      fit: BoxFit.fitWidth,
                                      image: NetworkImage(
                                          catList[index].image == null
                                              ? ''
                                              : catList[index].image!),
                                    )),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .boxColor,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10.0,
                                            offset: const Offset(5.0, 5.0),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .fontColor
                                                .withOpacity(0.1),
                                            spreadRadius: 1.0),
                                      ],
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .boxColor,
                                      child: InkWell(
                                        highlightColor: Theme.of(context)
                                            .colorScheme
                                            .boxColor,
                                        splashColor: colors.primary,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Container(
                                          color: selectedChoices
                                                  .contains(catList[index].id)
                                              ? colors.primary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .boxColor,
                                          height: 25,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.5,
                                          // padding: EdgeInsetsDirectional.only(
                                          //     start: 20.0,
                                          //     end: 15.0,
                                          //     top: 10.0,
                                          //     bottom: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(catList[index].categoryName!,
                                                  textAlign: TextAlign.center,
                                                  style: selectedChoices.contains(
                                                          catList[index].id)
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .lightColor,
                                                              fontWeight: FontWeight
                                                                  .w600,
                                                              letterSpacing:
                                                                  0.5,
                                                              fontSize: 12)
                                                      : Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .fontColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              letterSpacing: 0.5,
                                                              fontSize: 12)),
                                              // Spacer(),
                                              // Container(
                                              //   height: 40.0,
                                              //   width: 40.0,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius:
                                              //         BorderRadius.circular(10),
                                              //     color: selectedChoices.contains(
                                              //             catList[index].id)
                                              //         ? colors.primary
                                              //         : Theme.of(context)
                                              //             .colorScheme
                                              //             .boxColor,
                                              //   ),
                                              //   child: Icon(
                                              //     Icons.check,
                                              //     color: selectedChoices.contains(
                                              //             catList[index].id)
                                              //         ? colors.primary
                                              //         : Theme.of(context)
                                              //             .colorScheme
                                              //             .boxColor,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          if (selectedChoices
                                              .contains(catList[index].id)) {
                                            selectedChoices
                                                .remove(catList[index].id);
                                            setState(() {});
                                          } else {
                                            selectedChoices
                                                .add(catList[index].id!);
                                            setState(() {});
                                          }

                                          if (selectedChoices.length == 0) {
                                            setState(() {
                                              selectedChoices.add("0");
                                            });
                                          } else {
                                            if (selectedChoices.contains("0")) {
                                              selectedChoices =
                                                  List.from(selectedChoices)
                                                    ..remove("0");
                                            }
                                          }
                                          print(
                                              "select choise*****$selectedChoices");
                                        },
                                      ),
                                    )),
                              ],
                            )),
                      ],
                    ),
                  );
                }))
        : Padding(
            padding: EdgeInsets.only(top: kToolbarHeight),
            child: CircularProgressIndicator());
  }

  saveBtn() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: InkWell(
          child: Container(
            height: 45.0,
            width: 190.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              getTranslated(context, 'save_lbl')!,
              style: Theme.of(this.context).textTheme.headline6?.copyWith(
                  color: Theme.of(context).colorScheme.boxColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 21),
            ),
          ),
          onTap: () async {
            _setUserCat();
          }),
    );
  }

  _setUserCat() async {
    if (selectedChoices.length == 1) {
      setState(() {
        selCatId = selectedChoices.join();
      });
    } else {
      setState(() {
        selCatId = selectedChoices.join(',');
      });
    }

    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      var param = {
        ACCESS_KEY: access_key,
        USER_ID: CUR_USERID,
        CATEGORY_ID: selCatId,
      };
      Response response =
          await post(Uri.parse(setUserCatApi), body: param, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      String error = getdata["error"];
      String msg = getdata["message"];

      if (error == "false") {
        setSnackbar(getTranslated(context, 'prefrence_save')!);

        if (selCatId == "0") {
          String catId = "";
          setPrefrence(cur_catId, catId);
        } else {
          String catId = selCatId;
          setPrefrence(cur_catId, catId);
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
      } else {
        setSnackbar(getTranslated(context, 'prefrence_save')!);

        String catId = selCatId;
        setPrefrence(cur_catId, catId);

        Navigator.of(context)
            .pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);
      }
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        setSnackbar(getTranslated(context, 'internetmsg')!);
      });
    }
  }
}
