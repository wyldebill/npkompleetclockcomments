import 'dart:math';

import 'package:flutter/material.dart';




class MinuteHandPainter extends CustomPainter{
  final Paint minuteHandPaint;
  int minutes;
  int seconds;

  MinuteHandPainter({this.minutes, this.seconds}):minuteHandPaint= new Paint(){
    minuteHandPaint.color= const Color(0xFF333333);
    minuteHandPaint.style= PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius= size.width/2;
    canvas.save();

    // move the origin start in the center of this widget's space
    canvas.translate(radius, radius);

    // rotate our canvas to the current angle in rads based on the seconds.
    canvas.rotate(2*pi*((this.minutes+(this.seconds/60))/60));

    Path path= new Path();
    path.moveTo(-1.5, -radius+10.0);  // how far the minute hand goes out from center of clock. has a spacer of 10 units 'short' from the edge of the clock face
    path.lineTo(-5.0, -radius/1.8); // the top half of the 'diamond hand'
    path.lineTo(-2.0, 10.0);        // this too, top half of diamond hand
    path.lineTo(2.0, 10.0);         // yep, same here diamond half
    path.lineTo(5.0, -radius/1.8);   // bottom half of diamond hand
    path.lineTo(1.5, -radius-10.0);  // bottom half of diamond hand
    path.close();  // magic, closes the path automagically.

    canvas.drawPath(path, minuteHandPaint);  // draw the minute hand defined in the path
    canvas.drawShadow(path, Colors.black, 4.0, false);   // draw the shadow under the minute hand


    canvas.restore();

  }

  @override
  bool shouldRepaint(MinuteHandPainter oldDelegate) {
    return true;
  }
}
