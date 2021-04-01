


import 'package:epilappsy/design/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class QuestionsPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Column(children: [
                Icon(Icons.videocam_outlined,
                    size: 30, color: DefaultColors.mainColor),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Column(children: [
                Icon(MdiIcons.microphoneOutline,
                    size: 30, color: DefaultColors.mainColor),
              ]),
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Column(children: [
                Icon(Icons.add_location_outlined,
                    size: 30, color: DefaultColors.mainColor),
              ]),
            ),
          ),
        ]),
      ),
      SizedBox(height: 20),
      Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
      SizedBox(height: 20),
    ]);
  }
}
