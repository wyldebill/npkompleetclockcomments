import 'dart:async';
import 'dart:math';

import 'package:clock/clock_text.dart';
import 'package:flutter/material.dart';
import 'package:clock/clock_face.dart';

typedef TimeProducer = DateTime Function();


// aha, finally something that is stateful.  that means it will be updating ui and holding ui state
class Clock extends StatefulWidget {

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
         //this.updateDuration = const Duration(milliseconds: 1)});

  static DateTime getSystemTime() {
    return new DateTime.now();
  }

  @override
  State<StatefulWidget> createState() {
    return _Clock();
  }
}


// hmm, the _Clock is a class that represents the state/ui for the Clock class above.  notice that just about
// all the logic is in this State derived class instead of the Clock class above.
class _Clock extends State<Clock> {
  Timer _timer;
  DateTime dateTime;


  // standard class required to work with state.  similar to the reactjs, need to make sure the state is
  // initialized so the state object and the ui are tied together
  // the state properities that are tracked are dateTime and _timer.
  @override
  void initState() {
    super.initState();
    dateTime = new DateTime.now();

    // every one second, call the setTime() method
    this._timer = new Timer.periodic(widget.updateDuration, setTime);
  }


  // QUESTION:  how does the timer parameter get resolved/injected here?
  void setTime(Timer timer) {

    // to update the state you have to call the setState() method instead of modifiying dateTime directly.  just like react
    setState(() {
      dateTime = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1.0,
      child: (widget.showBellsAndLegs)?  // ternary evalutor, should we draw the bells and legs?
      
      // draw the legs and bells....
       new Stack(
          children: <Widget>[
            new Container(
              width: double.infinity,
              child: new CustomPaint(
                painter: new BellsAndLegsPainter(bellColor: widget.bellColor, legColor: widget.legColor),
              ),
            ),

            buildClockCircle(context)
          ]
      ) : 
      
      // otherwise, just build the clock face/circle
      buildClockCircle(context),

    );
  }

  Container buildClockCircle(BuildContext context) {
    return new Container(
      width: double.infinity,
      decoration: new BoxDecoration(   // builds the red clock outline, fills the space
        shape: BoxShape.circle,
        color: widget.circleColor,
        boxShadow: [
          new BoxShadow(               // there is a small dropshadow 
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


class BellsAndLegsPainter extends CustomPainter{
  final Color bellColor;
  final Color legColor;
  final Paint bellPaint;
  final Paint legPaint;

  BellsAndLegsPainter({this.bellColor = const Color(0xFF333333), this.legColor = const Color(0xFF555555)}):
      bellPaint= new Paint(),
      legPaint= new Paint() {
      bellPaint.color= bellColor;
      bellPaint.style= PaintingStyle.fill;

    legPaint.color= legColor;
    legPaint.style= PaintingStyle.stroke;
    legPaint.strokeWidth= 10.0;
    legPaint.strokeCap= StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    canvas.save();

    canvas.translate(radius, radius);

    //draw the handle
    Path path = new Path();
    path.moveTo(-60.0, -radius-10);
    path.lineTo(-50.0, -radius-50);
    path.lineTo(50.0, -radius-50);
    path.lineTo(60.0, -radius-10);

    canvas.drawPath(path, legPaint);

    //draw right bell and left leg
    canvas.rotate(2*pi/12);
    drawBellAndLeg(radius, canvas);

    //draw left bell and right leg
    canvas.rotate(-4*pi/12);
    drawBellAndLeg(radius, canvas);

    canvas.restore();

  }

  //helps draw the leg and bell
  void drawBellAndLeg(radius, canvas){
    //bell
    Path path1 = new Path();
    path1.moveTo(-55.0, -radius-5);
    path1.lineTo(55.0, -radius-5);
    path1.quadraticBezierTo(0.0, -radius-75, -55.0, -radius-10);

    //leg
    Path path2= new Path();
    path2.addOval(new Rect.fromCircle(center: new Offset(0.0, -radius-50), radius: 3.0));
    path2.moveTo(0.0, -radius-50);
    path2.lineTo(0.0, radius+20);

    //draw the bell on top on the leg
    canvas.drawPath(path2, legPaint);
    canvas.drawPath(path1, bellPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
