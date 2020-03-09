import 'dart:math';

import 'package:clock/clock_text.dart';
import 'package:flutter/material.dart';

class ClockDialPainter extends CustomPainter{
  final clockText;

  final hourTickMarkLength= 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth= 3.0;
  final minuteTickMarkWidth = 1.5;

  final Paint tickPaint;   // not like cpu clock ticks, ticks around the face of the clock dial?
  final TextPainter textPainter;
  final TextStyle textStyle;

  final romanNumeralList= [ 'XII','I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI'];

  ClockDialPainter({this.clockText = ClockText.roman})  // dart ctor parameter default is clocktext.roman and is evaluated first.
  // more on dart constructors and their behavior  https://dart.dev/guides/language/language-tour#using-constructors

      // instance variable intiailization is next...there are 3 instance variables
      :tickPaint= new Paint(),

        textPainter= new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),

        textStyle= const TextStyle(
          color: Colors.black,
          fontFamily: 'Times New Roman',
          fontSize: 15.0,
        )
  
  // and lastly the ctor body. thank you for your patience
  {
    tickPaint.color= Colors.blueGrey;
  }


  // anytime something 'tied' to the clock state changes, call paint.  ie, every 1 second the timer fires, updates the clock state time via setstate() and that triggers a call to paint() here
  @override
  void paint(Canvas canvas, Size size) {
    var tickMarkLength;
    final angle= 2* pi / 60;   // the clock has 60 minutes on it's face. figure out the angle of each tick mark on the ui face here
    final radius= size.width/2;  // flutter must send in the size of the widget to repaint, so half of the face/dial is the radius. makes sense
    canvas.save();             // QUESTION:  why does it call save() 




    // drawing
    canvas.translate(radius, radius);   // i think this is setting the start point to the center rather than top left?

    // there are 60 1-minute markers on the face of the clock 
    for (var i = 0; i< 60; i++ ) {

      //make the length and stroke of the tick marker longer and thicker depending

      // if it's a minute divisible by 5 (5min, 10min, 15min)...then make it lenth of hourtickmarklength.  otherwise make the mark the shorter minute tickmarklength
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength: minuteTickMarkLength;


      // same with the width of each marker - thicker if it's a hour marker ie divisble by 5.  
      tickPaint.strokeWidth= i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;


      // we know where the clock face minute markers, hour markers will go now
      // we have the angle of each tick mark from the center of the clock face
      // we can tell if it's a minute marker or an hour marker to be painted.  if it's a hour marker, it's width is larger than a minute marker. the length is the same for each though
      //
      // drawline takes a start point, and a end point and the paint object which controls things 
      // so the very first time this runs, when i == 0 the line will be from (0,-radius) to (0, -radius plus tickmarklength)
      // let's assume the radius is 100.
      // the line will be from (starting from the center of the dial which is now at 0,-radius - the 12 oclock position
      // directly 100 pixels up in y, and no change to x.  so about where the 12 is on a clock face
      // it will draw a line from that x and y above to the same x and down a distance of the tickmarklength.
      // so this will draw the initial vertical line at the 12 oclock position of length tickmarklength.  
      // whew   only 59 to go.
      canvas.drawLine(
          new Offset(0.0, -radius), new Offset(0.0, -radius+tickMarkLength), tickPaint);


      //draw the text
      // divisible by 5 means that we are on an 'hour' marker, like 1,2,3,4..12.
      if (i%5==0){
        canvas.save();     // QUESTION:  what does the save() do?
        canvas.translate(0.0, -radius+20.0);      // move the origin of painting to the "1" position, the first time thru when i==0.
                                                  // this is the very outer edge of the clock face

        textPainter.text= new TextSpan(           // the 'digit' on the clock face as text.  
          text: this.clockText==ClockText.roman?  // are we set to using romain numerals?
          '${romanNumeralList[i~/5]}'
              :'${i == 0 ? 12 : i~/5}'   // decimal numbers are used.  if it's the first time thru the loop at i==0, set to "12".  otherwise, 
              //use the modulus of i / 5 to determine what number to set. 
                                          // "1" at i==5, 5 minute mark on the face.  "7" at i==35, 35 minute mark on the face.
          ,
          style: textStyle,
        );

        //helps make the text painted vertically
        canvas.rotate(-angle*i);   // take this line out to see what it actually does!
                                   // as we move thru the i values, we slowy start to curve the around the center point.
                                   // without this rotating correction, the "3" will be printed on it's back fadcing up and
                                   // the "6" would be upside down.  this negative rotation keeps the text vertical
        textPainter.layout();

        // this puts the text on the clock face.  it also does a old school center for the width and the height of the text. 
        // old school center.  if takes the width of the text and divides it by 2 to find the start point to put the textspan
        // it does the same thing for the height.
        textPainter.paint(canvas, new Offset(-(textPainter.width/2), -(textPainter.height/2)));

        canvas.restore();

      }

      canvas.rotate(angle);
    }

    canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

