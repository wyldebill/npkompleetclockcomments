import 'dart:async';

import 'package:clock/clock_text.dart';
import 'package:flutter/material.dart';
import 'package:clock/clock_face.dart';

typedef TimeProducer = DateTime Function();


// aha, finally something that is stateful. well, it's coming. it's not in this widget though.  this is step 1 though on that journey. notice also that
// this class has almost no 'logic' in it
class Clock extends StatefulWidget {

  // variables that aren't stateful, tracked go here. 
  final Color circleColor;
  final bool showBellsAndLegs;
  final Color bellColor;
  final Color legColor;
  final ClockText clockText;
  final bool showHourHandleHeartShape;
  final TimeProducer getCurrentTime;
  final Duration updateDuration;

  Clock({this.circleColor = Colors.black,
         this.showBellsAndLegs = true,
         this.bellColor = const Color(0xFF333333),
         this.legColor = const Color(0xFF555555),
         this.clockText = ClockText.arabic,
         this.showHourHandleHeartShape = false,
         this.getCurrentTime = getSystemTime,
         this.updateDuration = const Duration(seconds: 1)});
 

  static DateTime getSystemTime() {
    return new DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {   // a required method, kind of defines the class that WILL be tracking state. this is step 2 of the state journey
    return _Clock();
  }
}


// hmm, the _Clock is a class that represents the state/ui for the Clock class above.  notice that just about
// all the logic is in this State derived _Clock class instead of the Clock class above.  this is step 3 in the state journey.
class _Clock extends State<Clock> {
  Timer _timer;
  DateTime dateTime;


  // create the initial state.  similar to reactjs, need to make sure the state is
  // initialized so the state object and the ui are tied together
  // the state properities that are tracked are dateTime and _timer.
  // this is step 4 of the state journey.  
  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();

    // every one second, call the setTime() method
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
  }


  // QUESTION:  how does the timer parameter get resolved/injected here?  It is sent in from the .periodic() callback method, flutter provides it.
  void setTime(Timer timer) {

    // to update the state you have to call the setState() method instead of modifiying dateTime directly.  similar to react
    setState(() {
      // this will change the tracked state, which will force a ui paint.  
      // well not exactly like that, it will do the widget tree compare, find differences, and repaint only those with differences.
      // this is step 5 and the final step in the flutter widget state journey.  
      dateTime = new DateTime.now();  
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  // build is called when the state changes.  it is used to create the ui or update it on state changes.
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1.0,
      child: (widget.showBellsAndLegs)?  // ternary evalutor, should we draw the bells and legs?  For this example, we will skip drawing the bells and legs
      
      // this is skipped
       new Stack(
          // children: <Widget>[
          //   new Container(
          //     width: double.infinity,
          //     child: new CustomPaint(
          //       painter: new BellsAndLegsPainter(bellColor: widget.bellColor, legColor: widget.legColor),
          //     ),
          //   ),

          //   buildClockCircle(context)
          // ]
      ) : 
      
      // ternary operator continues.  build the clock face/circle
      buildClockCircle(context),

    );
  }

  Container buildClockCircle(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(   // builds the red clock outline, as wide as the current container will allow
        shape: BoxShape.circle,
        color: widget.circleColor,
        boxShadow: [
          new BoxShadow(               // there is a small dropshadow around the red clock outline
            offset: new Offset(0.0, 2.0),
            blurRadius: 5.0,
          )
        ],
      ),

      child: new ClockFace(           // the content of the Container is the ClockFace
          clockText : widget.clockText,
          showHourHandleHeartShape: widget.showHourHandleHeartShape,
          dateTime: dateTime,
      ),

    );
  }

}



