class ProductDetailModel {

  int _id;
  String _title;
  String _description;
  String _email;
  String _date;
  String _picture;


  ProductDetailModel(this._title,this._email, this._date,this._picture, [this._description] );

  ProductDetailModel.withId(this._id, this._title,this._email, this._date,this._picture, [this._description]);

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get email=>_email;

  String get date => _date;
  String get picture => _picture;


  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }
  set email(String newEmail) {
      this._email = newEmail;
  }


  set date(String newDate) {
    this._date = newDate;
  }


  set picture(String newPicture) {
    this._picture = newPicture;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['email']=_email;
    map['date'] = _date;
    map['picture'] = _picture;

    return map;
  }

  // Extract a Note object from a Map object
  ProductDetailModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this.email=map['email'];
    this._date = map['date'];
    this._picture = map['picture'];
  }
}








