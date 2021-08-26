import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';

class AppBarBackground extends CustomPainter {

  Size setSize;
  AppBarBackground(this.setSize);

  @override
  void paint(Canvas canvas, Size size) {
    size = setSize;
    print(size);
    var paint = Paint();
    paint.color = DefaultColors.mainColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    /* path.moveTo(0, 0); // origin
    path.lineTo(0, size.height*0.3325); // origin --> point 1
    path.quadraticBezierTo(size.width*0.0895250, size.height*0.1591714, size.width*0.19368, size.height*0.277925); // point 1 --> point 2
    path.cubicTo(size.width*0.3193167,size.height*0.1708571,size.width*0.2789583,size.height*0.6142857, size.width*0.5, size.height); // point 2 --> point 3
    path.cubicTo(size.width*0.7177083,size.height*0.6164286,size.width*0.6614583,size.height*0.1739286, size.width*0.80632, size.height*0.277925); // point 3 --> point 4
    path.quadraticBezierTo(size.width*0.9120833, size.height*0.1585714, size.width, size.height*0.3325); // point 4 --> point 5
    path.lineTo(size.width, 0); // point 5 --> point 6
    path.lineTo(0, 0); // point 6 --> origin
    path.close(); */
    
    Path path = Path();
    path.moveTo(0,0);
    path.lineTo(0,size.height*0.3542857);
    path.quadraticBezierTo(size.width*0.1235417,size.height*0.2992857,size.width*0.1966667,size.height*0.4528571);
    path.cubicTo(size.width*0.2643750,size.height*0.5764286,size.width*0.2512500,size.height,size.width*0.5000000,size.height);
    path.cubicTo(size.width*0.7483333,size.height*1.0007143,size.width*0.7316667,size.height*0.5767857,size.width*0.8033333,size.height*0.4557143);
    path.quadraticBezierTo(size.width*0.8800000,size.height*0.3132143,size.width,size.height*0.3542857);
    path.lineTo(size.width,0);
    path.lineTo(0,0);
    path.close();




    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}