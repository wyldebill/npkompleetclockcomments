import 'dart:async';

import 'package:clock/hand_hour.dart';
import 'package:clock/hand_minute.dart';
import 'package:clock/hand_second.dart';
import 'package:flutter/material.dart';



class ClockHands extends StatelessWidget {
  final DateTime dateTime;
  final bool showHourHandleHeartShape;

  ClockHands({this.dateTime, this.showHourHandleHeartShape = false});

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20.0),
            child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                   CustomPaint( painter:  HourHandPainter(
                      hours: dateTime.hour, minutes: dateTime.minute, showHeartShape: showHourHandleHeartShape),
                  ),
                   CustomPaint(painter:  MinuteHandPainter(
                      minutes: dateTime.minute, seconds: dateTime.second),
                  ),
                   CustomPaint(painter:  SecondHandPainter(seconds: dateTime.second),
                  ),
                ]
            )
        )

    );
  }
}

