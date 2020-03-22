import 'package:clock/clock_text.dart';
import 'package:flutter/material.dart';
import 'package:clock/clock_dial_painter.dart';
import 'package:clock/clock_hands.dart';

class ClockFace extends StatelessWidget{

  final DateTime dateTime;
  final ClockText clockText;
  final bool showHourHandleHeartShape;

  ClockFace(
    {this.clockText = ClockText.arabic, 
  this.showHourHandleHeartShape = false, 
  this.dateTime});

  @override
  Widget build(BuildContext context) {

    // pad everything with a 10px space around it
    return new Padding(
      padding: const EdgeInsets.all(10.0),

      // padding has a single child widget, the aspect ratio
      child: new AspectRatio(
        aspectRatio: 1.0,


        // nested container, which has it's own child widget a Container
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(  // finally, the face of the clock. white. expands to fit the space
            shape: BoxShape.circle,
            color: Colors.white,
          ),

          child: new Stack(
            
            // the stack has 3 children
            // QUESTION: how are they arranged by default? vertically?
            children: <Widget>[
             

              // 1...
              // first child is the clock dial, the tic marks for minutes/hours and the text numerals
              new Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),

                child:new CustomPaint(
                  painter: new ClockDialPainter(clockText: clockText),
                ),
              ),


              // 2....
              //centerpoint
              // center of the clock face, just a circle 15px? wide and high.  black in color
              new Center(
                child: new Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),

              // 3.....
              // last child is the hands of the clock, the hour, minute and second hand
              new ClockHands(dateTime:dateTime, showHourHandleHeartShape: showHourHandleHeartShape),
              

            ],
          ),
        ),

      ),
    );
  }
}


