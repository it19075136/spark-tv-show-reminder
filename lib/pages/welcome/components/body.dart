import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spark_tv_shows/constants.dart';
import './background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO SPARK TV SHOWS",
              style: GoogleFonts.robotoSlab(
                fontSize: 23.0,
                color: kPrimaryColor,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/tvShows');
                },
                child: Text('Tv Shows'),
                style: TextButton.styleFrom(
                    primary: kPrimaryLightColor,
                    backgroundColor: kPrimaryColor)),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/channels');
              },
              child: Text('Channels'),
              style: TextButton.styleFrom(
                  primary: kPrimaryLightColor, backgroundColor: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
