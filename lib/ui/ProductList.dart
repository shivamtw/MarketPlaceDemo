import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:register_local_data/model/ProductModel.dart';
import 'package:register_local_data/ui/ProductPage.dart';
import 'package:register_local_data/util/DatabaseHelper.dart';
import 'package:register_local_data/value/MyColor.dart';
import 'package:register_local_data/value/MyTextSize.dart';

import 'package:sqflite/sqflite.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductListState();
  }
}

class ProductListState extends State<ProductList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ProductDetailModel> todoList = new List<ProductDetailModel>();
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState

    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<ProductDetailModel>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.darkblueColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dashboard'),
            GestureDetector(
                onTap: () {
                  debugPrint('FAB clicked');
                  navigateToDetail(
                      ProductDetailModel(
                        '',
                        '',
                        '',
                        '',
                        '',
                      ),
                      'Add Product');
                },
                child: Icon(
                  Icons.add,
                ))
          ],
        ),
      ),
      body: getTodoListView(),
      /*floatingActionButton: FloatingActionButton(backgroundColor: MyColor.darkblueColor,
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Todo('', '', '','','',), 'Register');
        },
        tooltip: 'Hello',
        child: Icon(Icons.add),
      ),*/
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: todoList.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                    backgroundColor: MyColor.darkblueColor,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: todoList[position].picture != null
                              ? FileImage(File(todoList[position].picture))
                              : AssetImage('images/user.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )

                    // Text(getFirstLetter(this.todoList[position].title),
                    //     style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                title: Column(
                  children: [
                    Row(
                      children: [
                        Text("Title : ",
                            style: TextStyle(
                                fontSize: MyTextSize.smallText,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(this.todoList[position].title,
                            style: TextStyle(fontSize: MyTextSize.smallText)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Date : ",
                            style: TextStyle(
                                fontSize: MyTextSize.smallText,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(this.todoList[position].email,
                            style: TextStyle(fontSize: MyTextSize.smallText)),
                      ],
                    ),
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text("LaunchSite : ",
                            style: TextStyle(
                                fontSize: MyTextSize.smallText,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(this.todoList[position].description,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: TextStyle(fontSize: MyTextSize.smallText)),
                      ],
                    ),
                    Row(
                      children: [
                        Text("LaunchRating : ",
                            style: TextStyle(
                                fontSize: MyTextSize.smallText,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        Text(this.todoList[position].date,
                            style: TextStyle(fontSize: MyTextSize.smallText)),
                      ],
                    )
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.edit,
                        color: MyColor.darkblueColor,
                      ),
                      onTap: () {
                        navigateToDetail(
                            this.todoList[position], 'Edit Product');
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: MyColor.darkblueColor,
                        ),
                        onTap: () {
                          // _delete(context, todoList[position]);

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              // return object of type Dialog
                              return AlertDialog(
                                title: new Text("Alert"),
                                content: new Text("Do you want to delete product?"),
                                actions: <Widget>[
                                  // usually buttons at the bottom of the dialog
                                  // ignore: deprecated_member_use
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      FlatButton(
                                        color: MyColor.whiteColor,
                                        child: new Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        color: MyColor.whiteColor,
                                        child: new Text("Yes"),
                                        onPressed: () {
                                          _delete(context, todoList[position]);
                                          Navigator.pop(context);
                                          updateListView();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        })
                  ],
                ),
                onTap: () {
                  debugPrint("ListTile Tapped");
                  navigateToDetail(this.todoList[position], 'Edit Product');
                },
              ),
            ],
          ),
        );
      },
    );
  }


  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, ProductDetailModel todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Product Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(ProductDetailModel todo, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<ProductDetailModel>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }
}
