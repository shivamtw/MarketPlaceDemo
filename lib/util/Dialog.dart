import 'package:flutter/material.dart';

class Dialogs {
  static showWaitDialog(BuildContext context){

    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              //backgroundColor: Colors.black54,
                backgroundColor: Colors.transparent,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10,),
                      //Text("Please Wait....",style: TextStyle(color: Colors.white),)
                    ]),
                  )
                ])

        );
      },
    );
  }
}