import 'dart:math';

import 'package:flutter/material.dart';



class SecondHandPainter extends CustomPainter{
  final Paint secondHandPaint;
  final Paint secondHandPointsPaint;

  int seconds;

  SecondHandPainter({this.seconds}):
        secondHandPaint= new Paint(),
        secondHandPointsPaint= new Paint(){
          secondHandPaint.color= Colors.red;
          secondHandPaint.style= PaintingStyle.stroke;
          secondHandPaint.strokeWidth= 2.0;

          secondHandPointsPaint.color=Colors.red;
          secondHandPointsPaint.style= PaintingStyle.fill;

  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius= size.width/2;  // find the radius, which is half of the container width we are inside?
    canvas.save();  // takes a snapshot of the current canvas, so we can 'pop' back to it as a reset


    // origin is upper left of the canvas. unless you translate it.....
    // postive values of x, move to the right - from the current origin
    // positive values of y, move down - from the current origin
    canvas.translate(radius, radius);  // move the origin to the center of the dial

    canvas.rotate(2*pi*this.seconds/60);  // 'line up' the second hand to be drawn with the current elapsed 'seconds' by rotating the canvas?  

    Path path1= new Path();  // the second hand 'paint' path.
    Path path2 = new Path();  // the circle paint paths, on the end of second hand and the circle in the middle of the clock
    path1.moveTo(0.0, -radius );  // set up the origin to draw from.  so at 0 seconds, this is at the 12'oclock marker...
    path1.lineTo(0.0, radius/3);  // at zero seconds, paths a line from top down thru the center and a bit past the center.

    //path2.addOval(new Rect.fromCircle(radius: 8.0, center: new Offset(0.0, -radius)));  // me, put a circle out on the end of the minutehand. just because...
    path2.addOval(new Rect.fromCircle(radius: 5.0, center: new Offset(0.0, 0.0)));  // put the cirlce in the middle of the clock face, only so the second hand shows a rotation spot

    canvas.drawPath(path1, secondHandPaint);  // path1 is the second hand, draws the second hand based on the path created above
    canvas.drawPath(path2, secondHandPointsPaint);  // draw the second hand pivot point, a circle in middle of clock


    canvas.drawShadow(path1, Colors.green, 1.0, false);  // draw a shadow under the minute hand.  i can't get this to work, or my dispalay doesn't show it even thought it's being drawn

    canvas.restore();  // put the canvas back to it's 'normal' oriention, restore orgin, etc.  reset
  }

  @override
  bool shouldRepaint(SecondHandPainter oldDelegate) {
    return this.seconds != oldDelegate.seconds; // if the time has changed, the current time is different that the time passed in regardig seconds, repaint
  }
}