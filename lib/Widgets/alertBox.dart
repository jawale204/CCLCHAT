import 'package:flutter/material.dart';

Future showDialogStructure(context, title, Function first,firstText, Function second,secondText,content) {
  bool cancelpressed = false;
   bool sendpressed = false;
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Text(content),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child:  Text(secondText),
                    onPressed: () {
                      if (!cancelpressed) {
                        cancelpressed = true;
                        second();
                      }
                    },
                  ),
                  FlatButton(
                    child:  Text(firstText),
                    onPressed: () {
                      if (!sendpressed) {
                        sendpressed = true;
                        first();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        );
      });
}
