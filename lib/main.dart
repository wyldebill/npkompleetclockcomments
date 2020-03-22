import 'package:flutter/material.dart';
import 'package:clock/clock.dart';
import 'package:clock/clock_text.dart';

// this is the entry point to the app, what flutter looks for to start your app
void main() => runApp(new MyApp());


// the main application which contains the clock stuff.  the main application doesn't have
// any VISIBLE state changes/UI changes so it derives from stateless widget.  BUT, and this is important MyApp contains other 
// widgets that WILL maintain state.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // the build method is like the render() in react.  this is what the app creates
  @override
  Widget build(BuildContext context) {

    // materialapp has support for googles Material Design, Title and Home are the important ones
    return new MaterialApp(
      title: 'Flutter Clock',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),

      // the entire app will consist of just this AppClock widget.  this could be a Scaffold holding 1+ widgets but it isn't here
      home: new AppClock(),  
    );
  }
}

// another widget, and still stateless??? hmmm.  Yes, nothing for state in this widget either.  But keep following down the rabbit hole here...
class AppClock extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    // scaffold provides some standard app ui.  like a floatingactionbutton, an appbar at the top, and body content
    return new Scaffold(

      // the meat of the application is here in the body
      // and the body is a padding widget that wraps the clock widget. padding insets it's 'child' widget
      body: new Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),

        // the child is a single column holding the clock widget
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,

          // finally, the clock widget!!
          children: <Widget>[

            new Clock(
                circleColor: Colors.red,
                showBellsAndLegs: false,
                bellColor: Colors.green,
                clockText: ClockText.arabic,
                showHourHandleHeartShape: false,
            ),
          ],
        ),
      ),
    );
  }
}


