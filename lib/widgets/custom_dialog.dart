import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title,
      description,
      primaryButtonText,
      primaryButtonRoute,
      secondaryButtonText,
      secondaryButtonRoute;

  CustomDialog(
      {@required this.title,
      @required this.description,
      @required this.primaryButtonText,
      @required this.primaryButtonRoute,
      this.secondaryButtonText,
      this.secondaryButtonRoute});

  static const double _padding = 20.0;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    //**Creates Dialog**
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_padding),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(_padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: _height * 0.025),
                //**Title Text**
                AutoSizeText(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25),
                ),
                SizedBox(height: _height * 0.025),
                //**Description Text**
                AutoSizeText(
                  description,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 24),
                //**MainButton Text**
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      primaryButtonText,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                    ),
                  ),
                  //**MainButton Route**
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(primaryButtonRoute);
                  },
                ),
                SizedBox(height: _height * 0.025),
                //**SecondaryButton**
                showSecondaryButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  showSecondaryButton(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    //**checks if SecondaryButton data got handed over**
    if (secondaryButtonRoute != null && secondaryButtonText != null) {
      return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        //**SecondaryButton Text**
        child: AutoSizeText(
          secondaryButtonText,
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w100,
            color: Colors.white,
          ),
        ),
        //**SecondaryRoute**
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed(secondaryButtonRoute);
        },
      );
    } else {
      return SizedBox(height: _height * 0.025);
    }
  }
}
