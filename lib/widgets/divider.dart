import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Helper/size_config.dart';

class Dividers extends StatefulWidget {
  const Dividers({Key? key}) : super(key: key);

  @override
  _DividersState createState() => _DividersState();
}

class _DividersState extends State<Dividers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Text("Category",style: GoogleFonts.openSans(color: Colors.black54,fontSize:1.5*AppSizeConfig.textMultiplier!,fontWeight: FontWeight.bold),),
    );
  }
}
