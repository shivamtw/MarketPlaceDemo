import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:register_local_data/model/ProductModel.dart';
import 'package:register_local_data/util/DatabaseHelper.dart';

import 'package:register_local_data/value/MyColor.dart';
import 'package:register_local_data/value/MyTextSize.dart';

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductDetail extends StatefulWidget {
  final String appBarTitle;
  final ProductDetailModel todo;

  ProductDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ProductDetailState(this.todo, this.appBarTitle);
  }
}

class ProductDetailState extends State<ProductDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  ProductDetailModel todo;
  var mUserPic;
  File mImage;

  var _mFormKey1 = GlobalKey<FormState>();

  double _ratingStar = 2.0;





  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController mDate = TextEditingController();
  TextEditingController mAddress = TextEditingController();


  Pattern mPattern = r'(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?$';


  ProductDetailState(this.todo, this.appBarTitle);
  openGallery() async {
    // imagePicker.dismissDialog();
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    print(image);

    setState(() {
      mImage = image as File;
    });

    String file_name;

    try {
      file_name = mImage.path.split('/').last;
    } catch (e) {
      print(e);
    }

    if (file_name != null) {
     // without croped
    }
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    mDate.text=todo.email;
   // _ratingStar =double.parse(todo.date);

    if (!todo.date.isEmpty){
      _ratingStar =double.parse(todo.date);
    }


    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: MyColor.darkblueColor,
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _mFormKey1,
              child: ListView(
                children: <Widget>[


                /*  Container(alignment: Alignment.center,
                      child:Text("Add Product",style: TextStyle(fontSize:MyTextSize.header),)),
*/


                  Center(
                    child: Container(
                        margin: EdgeInsets.only( top: 25.0,),
                        //   top: 60.0,
                        //  left: (MediaQuery.of(context).size.width / 2 - 70.0),
                        child: new Stack(
                            children: [
                              GestureDetector(
                                child: Container(alignment: Alignment.center,
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,border: Border.all(color: Colors.grey),
                                    image: DecorationImage(
                                      image: todo.picture != null
                                          ? FileImage(File(todo.picture))
                                          : AssetImage('images/user.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  await ImagePicker()
                                      .getImage(source: ImageSource.gallery)
                                      .then((file) {
                                    if (file == null) return;
                                    setState(() {
                                      todo.picture = file.path;
                                    });
                                  });
                                },
                              ),
                            ])),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('TITLE',
                                style: TextStyle(
                                  fontSize: MyTextSize.smallText,
                                  color: Colors.black,
                                ))),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: titleController,
                            onChanged: (value) {
                              debugPrint('Something changed in Title Text Field');
                              updateTitle();
                            },
                            decoration: InputDecoration(
                              fillColor: MyColor.whiteColor,
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                fontSize: MyTextSize.smallText,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(12),
                            ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This can not be empty";
                                }
                              }
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('LAUNCH SITE ',
                                style: TextStyle(
                                  fontSize: MyTextSize.smallText,
                                  color: Colors.black,
                                ))),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: descriptionController,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(
                              fillColor: MyColor.whiteColor,
                              hintText: 'Site',
                              hintStyle: TextStyle(
                                fontSize: MyTextSize.smallText,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(12),
                            ),
                            onChanged: (value) {
                              debugPrint(
                                  'Something changed in Description Text Field');
                              updateDescription();
                            },
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This can not be empty";
                                }

                                RegExp regex = new RegExp(mPattern);
                                if (!regex.hasMatch(value)) {
                                  return 'Enter Valid Url';
                                }

                              }
                          ),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('LAUNCH DATE ',
                                style: TextStyle(
                                  fontSize: MyTextSize.smallText,
                                  color: Colors.black,
                                ))),

                        Container(
                          height: 50.0,
                          margin: EdgeInsets.only(top: 5.0),
                          child: TextFormField(
                            controller: mDate,
                            showCursor: false,
                            readOnly: true,
                            //keyboardType: TextInputType.emailAddress,

                            decoration: InputDecoration(
                              fillColor: MyColor.whiteColor,
                              hintText: 'Date',
                              hintStyle: TextStyle(
                                fontSize: MyTextSize.smallText,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(12),

                              suffixIcon: GestureDetector(
                                onTap: (){


                                  showCupertinoModalPopup<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              left: 40.0, right: 40.0),
                                          height: 150.0,
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.white,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDateTime: DateTime.now(),
                                            onDateTimeChanged: (DateTime newDate) {
                                              if (mounted) {
                                                var selectdate = newDate;
                                                //  var formatter = new DateFormat('dd-MMM-yyyy');
                                                var formatter = new DateFormat('M/d/y');
                                                String formattedDate = formatter.format(selectdate);

                                                print(formattedDate); // something l

                                                // setState(() => mDate = date[1-6]);
                                                mDate.text=formattedDate;
                                                todo.email=formattedDate;
                                                print(mDate.text);
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );

                                },
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40.0,
                                  color: MyColor.themeColor,

                                ),
                              ),
                            ),

                            onChanged: (value) {
                              debugPrint(
                                  'Something changed in Description Text Field');
                              updateEmail();


                            },

                              validator: (String value) {
                                if (value.isEmpty) {
                                  return "This can not be empty";
                                }
                            }
                          ),
                        )
                      ],
                    ),
                  ),

                 Column(
                   children: [
                     Text(
                       'Rating : $_ratingStar',

                      // style: Theme.of(context).textTheme.subhead,
                     ),
                     SizedBox(height: 8),
                     RatingBar(
                       filledIcon: Icons.star,
                       onRatingChanged: (rating) {
                         setState(() {
                           return _ratingStar = rating;
                         });
                         //todo.date=rating.toString();
                         updateRating();
                       },
                       initialRating: _ratingStar,
                       isHalfAllowed: true,
                       halfFilledIcon: Icons.star_half,
                       emptyIcon: Icons.star_border,
                     ),
                     SizedBox(height: 32),
                   ],
                 ),

                 /* Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            child: Text('ADDRESS ',
                                style: TextStyle(
                                  fontSize: MyTextSize.smallText,
                                  color: Colors.black,
                                ))),
                        Container(
                          height: 50.0,
                          margin: EdgeInsets.only(top: 5.0),
                          child: TextField(
                            controller: mAddress,
                            onChanged: (value) {
                              debugPrint(
                                  'Something changed in Description Text Field');
                              updateDescription();
                            },
                            decoration: InputDecoration(
                              fillColor: MyColor.whiteColor,
                              hintText: 'Address',
                              hintStyle: TextStyle(
                                fontSize: MyTextSize.smallText,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),*/



                  GestureDetector(
                    onTap: () {

                        debugPrint("Save button clicked");

                        if(_mFormKey1.currentState.validate()) {
                          _save();
                        }
                    },
                    child: Container(margin: EdgeInsets.only(left: 15.0,right: 15.0,top: 20.0),

                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MyColor.darkblueColor,
                            borderRadius: BorderRadius.circular(10)),
                        height: 50,
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MyTextSize.btnText,
                              fontWeight: FontWeight.bold),
                        )),
                  ),

                  // Padding(
                  //   padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  //   child: Container(height: 50.0,
                  //     child: Row(
                  //       children: <Widget>[
                  //         Expanded(
                  //           child: RaisedButton(
                  //             color: Colors.black,
                  //             textColor: Colors.white,
                  //             child: Text(
                  //               'SUBMIT',
                  //               textScaleFactor: 1.5,
                  //             ),
                  //             onPressed: () {
                  //               // setState(() {
                  //               //   debugPrint("Save button clicked");
                  //               //   _save();
                  //               // });
                  //             },
                  //           ),
                  //         ),
                  //
                  //         Container(width: 5.0,),
                  //
                  //         // Expanded(
                  //         //   child: RaisedButton(
                  //         //     color: Theme.of(context).primaryColorDark,
                  //         //     textColor: Theme.of(context).primaryColorLight,
                  //         //     child: Text(
                  //         //       'Delete',
                  //         //       textScaleFactor: 1.5,
                  //         //     ),
                  //         //     onPressed: () {
                  //         //       setState(() {
                  //         //         debugPrint("Delete button clicked");
                  //         //         _delete();
                  //         //       });
                  //         //     },
                  //         //   ),
                  //         // ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void updateEmail() {
    todo.email =mDate.text.toString();
  }

  void updateRating(){
    todo.date=_ratingStar.toString();
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    int result;
    if (todo.id != null) {
      // Case 1: Update operation
      result = await helper.updateTodo(todo);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertTodo(todo);
    }

    if (result != 0) {
      // Success
    } else {
      // Failure
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (todo.id == null) {
      return;
    }

    int result = await helper.deleteTodo(todo.id);
    if (result != 0) {
    } else {
    }
  }



}


