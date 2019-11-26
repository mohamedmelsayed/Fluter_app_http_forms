import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_world/services/contact.dart';
import 'package:hello_world/services/httpservice.dart';
import 'package:intl/intl.dart';

class FifthFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      // title: 'Flutter Form Demo',
      // theme: new ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      child: new MyHomePage(title: 'إدخال طلب تنظيف'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];
  String _color = '';
  Job newJob = new Job();

  final TextEditingController _controller = new TextEditingController();

  Future<Null> _chooseDate(
      BuildContext context, String initialDateString) async {
    var now = new DateTime.now();
    var initialDate = convertToDate(initialDateString) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);

    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now());

    if (result == null) return;

    setState(() {
      _controller.text = new DateFormat.yMd().format(result);
    });
  }

  bool isValidDob(String dob) {
    if (dob.isEmpty) return true;
    var d = convertToDate(dob);
    return d != null && d.isBefore(new DateTime.now());
  }

  DateTime convertToDate(String input) {
    try {
      var dateFormat = new DateFormat.yMd();
      var d = dateFormat.parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  bool isValidPhoneNumber(String input) {
    // final RegExp regex = new RegExp(r'^\(\d\d\d\)\d\d\d\-\d\d\d\d$');

    final RegExp regex = new RegExp(r'^\d\d\d\d\d\d\d\d\d\d$');
    return regex.hasMatch(input);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Name: ${newJob.customername}');
      print('Dob: ${newJob.entrydate}');
      print('Phone: ${newJob.customerphone}');
      // print('Email: ${newCustomer.email}');
      // print('Favorite Color: ${newContact.favoriteColor}');
      print('========================================');
      print('Submitting to back end...');
      var contactService = new HttpService();
      log(contactService.getToken());
      contactService.login({
        "method": "login",
        "table": "users",
        "tokenlifetime": 200,
        "where": "phone,eq,1234567^pwd,eq,123"
      }).then((value) => printr(value));
    }
  }

  void printr(String order) {
    HttpService contactService=new HttpService();
    List<dynamic> object = json.decode(order);

contactService.setToken(object[0]["token"]);

       contactService.post("jobs",contactService.jobToJson(newJob)).then((value) => log(value));
    showMessage(object[0]["token"], Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'أدخل إسم العميل',
                      labelText: 'إسم العميل',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val.isEmpty ? 'هذا الحقل ضروري  ' : null,
                    onSaved: (val) => newJob.customername = val,
                  ),
                  new Row(children: <Widget>[
                    new Expanded(
                        child: new TextFormField(
                      decoration: new InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: 'الموعد المناسب',
                        labelText: 'وقت العمل',
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.datetime,
                      validator: (val) =>
                          isValidDob(val) ? null : 'Not a valid date',
                      onSaved: (val) => newJob.entrydate = convertToDate(val),
                    )),
                    new IconButton(
                      icon: new Icon(Icons.date_range),
                      tooltip: 'Choose date',
                      onPressed: (() {
                        _chooseDate(context, _controller.text);
                      }),
                    )
                  ]),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'جوال العميل',
                      labelText: 'الجوال',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      new WhitelistingTextInputFormatter(
                          new RegExp(r'^[()\d -]{1,15}$')),
                    ],
                    validator: (value) => isValidPhoneNumber(value)
                        ? null
                        : 'فقط أدخل ارقام لا تزيد عن 15 خانة',
                    onSaved: (val) => newJob.customerphone = val,
                  ),
                  new TextFormField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.description),
                      hintText: ' أكتب وصفا للعمل المطلوب  ',
                      labelText: 'وصف',
                    ),
                    // keyboardType: TextInputType.emailAddress,
                    // validator: (value) => isValidEmail(value)
                    //     ? null
                    //     : 'أكتب وصف طلب التنظيف',
                     validator: (value) =>
                        value.isEmpty ? 'هذا الحقل ضروري  ' : null,
                    onSaved: (value) => newJob.jobdesc = value,
                  ),
                       new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.money_off),
                      hintText: ' تكلفة الطلب',
                      labelText: 'السعر',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      new WhitelistingTextInputFormatter(
                          new RegExp(r'^[()\d -]{1,15}$')),
                    ],
                    // validator: (value) => 
                    //     ? null
                    //     : 'أرقام فقط',
                    onSaved: (val) => newJob.cost = val ,
                  ),
                  // new FormField<String>(
                  //   builder: (FormFieldState<String> state) {
                  //     return InputDecorator(
                  //       decoration: InputDecoration(
                  //         icon: const Icon(Icons.color_lens),
                  //         labelText: 'Color',
                  //         errorText: state.hasError ? state.errorText : null,
                  //       ),
                  //       isEmpty: _color == '',
                  //       child: new DropdownButtonHideUnderline(
                  //         child: new DropdownButton<String>(
                  //           value: _color,
                  //           isDense: true,
                  //           onChanged: (String newValue) {
                  //             setState(() {
                  //               newContact.favoriteColor = newValue;
                  //               _color = newValue;
                  //               state.didChange(newValue);
                  //             });
                  //           },
                  //           items: _colors.map((String value) {
                  //             return new DropdownMenuItem<String>(
                  //               value: value,
                  //               child: new Text(value),
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   validator: (val) {
                  //     return val != '' ? null : 'Please select a color';
                  //   },
                  // ),
                  new Container(
                      padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new RaisedButton(
                        child: const Text('Submit'),
                        onPressed: _submitForm,
                      )),
                ],
              ))),
    );
  }
}
