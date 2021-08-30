import 'package:flutter/material.dart';
import 'package:food_delivery_app/color_constants.dart';
import 'package:food_delivery_app/models/food_item.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodTile extends StatefulWidget {
  final FoodItem foodItem;

  const FoodTile({Key key, this.foodItem}) : super(key: key);

  @override
  _FoodTileState createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        InkWell(
          onTap: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailProducts(
                  idProduk: widget.foodItem.id,
                  nameProduk: widget.foodItem.name,
                  price: widget.foodItem.price,
                ),
              ),
            )
          },
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            shadowColor: const Color(0xffF7CBAB),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 30,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.foodItem.name,
                          style: GoogleFonts.varelaRound(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '\Rp. ${widget.foodItem.price}',
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DetailProducts extends StatefulWidget {
  final idProduk;
  final nameProduk;
  final price;

  const DetailProducts({Key key, this.idProduk, this.nameProduk, this.price})
      : super(key: key);

  @override
  _DetailProductsState createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.black,
            ),
            Positioned(
              top: 250,
              child: Container(
                color: Colors.amberAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
