// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:news_app/Helper/Color.dart';
// import 'package:news_app/Helper/Constant.dart';
// import 'package:news_app/Helper/Session.dart';
// import 'package:news_app/Helper/String.dart';
// import 'package:http/http.dart' as http;


// class SelectChannel extends StatefulWidget {
//   const SelectChannel({Key? key}) : super(key: key);

//   @override
//   _SelectChannelState createState() => _SelectChannelState();
// }

// class _SelectChannelState extends State<SelectChannel> {
//   Future<void> getChannel() async {
//     _isNetworkAvail = await isNetworkAvailable();
//     if (_isNetworkAvail) {
//       try {
//         var param = {
//           ACCESS_KEY: access_key,
//           USER_ID: CUR_USERID,
//         };

//         http.Response response = await http
//             .post(Uri.parse(getChanApi), body: param, headers: headers)
//             .timeout(Duration(seconds: timeOut));
//         var getData = json.decode(response.body);

//         String error = getData["error"];
//         print(response.body);
//         if (error == "false") {
//           tempChannelList.clear();
//           var data = getData["data"];

//           tempChannelList =
//               (data as List).map((data) => new Channel.fromJson(data)).toList();
//           channelList.addAll(tempChannelList);
//           // _tabs.clear();
//           // this._addInitailTab();
//         }
//         if (mounted)
//           setState(() {
//             _isLoading = false;
//           });
//       } on TimeoutException catch (_) {
//         setSnackbar(getTranslated(context, 'somethingMSg')!);
//         setState(() {
//           _isLoading = false;
//           _isLoadingMore = false;
//         });
//       }
//     } else {
//       setSnackbar(getTranslated(context, 'internetmsg')!);
//       setState(() {
//         _isLoading = false;
//         _isLoadingMore = false;
//       });
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: getAppBar(),
//       body: 
//     );
//   }

//   getAppBar() {
//     return PreferredSize(
//         preferredSize: Size(double.infinity, 45),
//         child: AppBar(
//           leadingWidth: 50,
//           elevation: 0.0,
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           title: Text(
//             'Select Channel',
//             style: Theme.of(context).textTheme.headline6?.copyWith(
//                 color: colors.primary,
//                 fontWeight: FontWeight.w600,
//                 letterSpacing: 0.5),
//           ),
//           leading: Builder(builder: (BuildContext context) {
//             return Padding(
//                 padding: EdgeInsetsDirectional.only(
//                     start: 15.0, top: 5.0, bottom: 5.0),
//                 child: Container(
//                     height: 38,
//                     padding: EdgeInsets.all(8.0),
//                     decoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.boxColor,
//                         boxShadow: [
//                           BoxShadow(
//                               blurRadius: 10.0,
//                               offset: const Offset(5.0, 5.0),
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .fontColor
//                                   .withOpacity(0.1),
//                               spreadRadius: 1.0),
//                         ],
//                         borderRadius: BorderRadius.circular(6.0)),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: SvgPicture.asset(
//                         "assets/images/back_icon.svg",
//                         semanticsLabel: 'back icon',
//                         color: Theme.of(context).colorScheme.fontColor,
//                       ),
//                     )));
//           }),
//         ));
//   }
// }
