import 'package:flutter/material.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:news_app/widgets/divider.dart';
import 'package:news_app/widgets/functionbar.dart';
import 'package:news_app/widgets/menus.dart';

import 'Helper/size_config.dart';

class Drawermain extends StatefulWidget {
  @override
  _DrawermainState createState() => _DrawermainState();
}

class _DrawermainState extends State<Drawermain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Appbar(),
          Funtionbar(),
          Container(
            height: 0.8,
            color: Colors.black54,
            width: 100 * AppSizeConfig.widthMultiplier!,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Dividers(),
          ),
          menus1()
        ],
      ),
    );
  }
}
