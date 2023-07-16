import 'dart:core';

import 'package:flutter/cupertino.dart';

class TextWidget extends StatelessWidget {
   TextWidget({Key? key, required this.title, required this.color, required this.textSize,this.isTitle = false,this.maxLine=10}) : super(key: key);
final String title;
final Color color;
final double textSize;
bool isTitle;
int maxLine=10;
  @override
  Widget build(BuildContext context) {
    return  Text(' $title ',
      maxLines:maxLine,
      overflow:TextOverflow.ellipsis,
        style: TextStyle(fontSize: textSize,color: color,fontWeight:isTitle? FontWeight.bold:FontWeight.normal),);
  }
}
