import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery_app/color_constants.dart';
import 'package:food_delivery_app/loginandreg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBottomPart(),
          _buildTopPart(),
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(color: ColorConstants.primaryColor),
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Loginandregister(),
              ));
            },
            child: Text(
              'Ayo Mulai',
              style: GoogleFonts.varelaRound(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopPart() {
    return Positioned.fill(
      bottom: 70,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset('assets/delivery-boy.png'),
              Text(
                'Pengantaran Express',
                style: GoogleFonts.varelaRound(
                    fontSize: 25, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Pesan makanan kesukaan anda\ndimana pun dan kapan pun,\ndengan fitur pengiriman yang cepat',
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
