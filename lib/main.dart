import 'package:flutter/material.dart';
import 'package:clock/clock.dart';
import 'package:clock/clock_text.dart';

// this is the entry point to the app, what flutter looks for to start your app
void main() => runApp(new MyApp());


// the main application which contains the clock stuff.  the main application doesn't have
// any VISIBLE state changes/UI changes so it derives from stateless widget.  BUT, and this is important, MyApp contains other 
// widgets that WILL maintain state.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  // the build method is like the render() in react.  this is where the app creates the UI
  @override
  Widget build(BuildContext context) {

    // materialapp has support for googles Material Design, Title and Home are the important ones
    return new MaterialApp(
      title: 'Flutter Clock',
      theme: new ThemeData(

        primarySwatch: Colors.blue,
      ),

      // the entire app will consist of just this AppClock widget. there is no routing support in this app.
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

          // finally, the clock widget!!  it is the child of the body widget and there is only one.  but, the children can 
          // hold an array of widgets too
          children: <Widget>[

            // the clock widget, contains all the widgets that make up the clock.
            new Clock(
                circleColor: Colors.red,  // the ring around the clock face
                showBellsAndLegs: false,  // we are skipping this part of the visual look of the clock.
                bellColor: Colors.green,  // bells are part of the visual design and skipped here
                clockText: ClockText.arabic,  // by default we will use arabic numerals, not roman numerals.
                showHourHandleHeartShape: false,  // fancy visual on the hour hand, skipped here
            ),
          ],
        ),
      ),
    );
  }
}


