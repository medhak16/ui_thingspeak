import 'package:flutter/material.dart';
import 'package:ui_thingspeak/model/data_model.dart';
import 'package:ui_thingspeak/screens/result.dart';
import 'package:ui_thingspeak/services/network.dart';
import 'dart:convert';
import 'package:ui_thingspeak/constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ui_thingspeak/services/database_services.dart';

class WriteForm extends StatefulWidget {
  @override
  _WriteFormState createState() => _WriteFormState();
}

class _WriteFormState extends State<WriteForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  Model model = Model();
  NetworkService _networkService = NetworkService();
  DatabaseService _databaseService = DatabaseService();

  //String channelId;
  String writeKey;

  void extractCredentials() async {
    //var mChannel = await _databaseService.getChannelId();
    var mwriteKey = await _databaseService.getWriteKey();
    setState(() {
      //channelId = mChannel;
      writeKey = mwriteKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                  //flex: 1,
                      child: MyTextFormField(
                        hintText: 'Enter Field Id',
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter a Field id';
                          }
                          return null;
                        },
                        onChange: (value) {
                          model.field = value;
                        },
                      )),
              Expanded(
                //flex: 2,
                  child: MyTextFormField(
                    hintText: 'Enter Data Value',
                    onChange: (value) {
                      model.data = value;
                    },
                  ),
              ),
              //WriteContainer(),
              //WriteContainer(),
              //WriteContainer(),
              //WriteContainer(),
              //WriteContainer(),
              //WriteContainer(),
              FlatButton(
                onPressed: () async {
                  var response;
                  setState(() {

                    _isLoading = true;
                  });
                  //write call function
                  debugPrint('Data added ');
                  response = await _networkService.writeInField(
                      writeKey: writeKey , fieldValue: model.field, data:model.data);

                  if (response != null) {
                    print('response: $response');
                    var recData = jsonDecode(response);
                    model.response=recData;
                    showAlertDialog(context, res: model.response);
                    //debugPrint('Response is : $recData');
                    setState(() {
                      _isLoading = false;
                    });

                  } else {
                    print('response error');
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(18.0)),
                  child: Text(
                    'Write',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void showAlertDialog(BuildContext context, {var res}){
    // set up the button
    Widget homeButton = FlatButton(
      child: Text("Home"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/home');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Entry Added!"),
      content: Text("Entry id: $res "),
      actions: [
        homeButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}

/*
class WriteContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.50),
                  ),
                  child: MyTextFormField(
                    hintText: 'Enter Field Id',
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Enter a Field id';
                      }
                      return null;
                    },
                    onChange: (value) {
                      //model.data = value;
                    },
                  ))),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.50),
              ),
              margin: EdgeInsets.all(2.5),
              child: MyTextFormField(
                hintText: 'Enter Data Value',
                onChange: (value) {
                  //model.data = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onChange;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(15.0),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
      onChanged: onChange,
    );
  }
}
