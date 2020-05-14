import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  String text;
  String clickText;
  IconData icon;
  Function onClickOK;
  Function onClickCancel;

  InfoDialog({
    @required this.text,
    @required this.icon,
    @required this.onClickOK,
    this.onClickCancel, this.clickText = "OK"
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      title: Center(
        child: Icon(icon, color: Colors.black87, size: 25,),
      ),
      content: Text(
        text,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        )
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => onClickOK(),
          child: Text(
            clickText,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w600
            ),
          ),
        ),
        onClickCancel != null 
          ? FlatButton(
            onPressed: () => onClickCancel(),
            child: Text(
              "Batal",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600
              ),
            ),
          )
          : SizedBox(),
      ],
    );
  }
}