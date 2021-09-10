import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/details_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CheckoutPage extends StatefulWidget {
  final idUser;

  CheckoutPage({Key key, this.idUser}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<dynamic> _dataItem;
  double subTotal = 0.0;

  void selectAllDataItem() async {
    var url = Uri.parse(
        'https://apinurmaya.adriel-creation.tech/configAPI/order.php');
    var response = await http.post(url, body: {
      'task': 'selectAllItem',
      'idUser': widget.idUser,
    });
    if (response.statusCode == 200) {
      if (response.body == "Failed") {
        print("Data Kosong");
        setState(() {
          _dataItem = [];
        });
      } else {
        var jsonData = response.body;
        var parsingData = json.decode(jsonData);
        setState(() {
          _dataItem = parsingData;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error : ${response.statusCode}"),
      ));
    }
    showData();
  }

  void showData() {
    double bagTotal = 0.0;
    for (var i = 0; i < _dataItem.length; i++) {
      double totalHarga = double.parse(_dataItem[i]['harga_menu']) *
          int.parse(_dataItem[i]['jumlah_item']);
      bagTotal += totalHarga;
    }
    setState(() {
      subTotal = bagTotal;
    });
  }

  @override
  void initState() {
    super.initState();
    selectAllDataItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SubTotal :",
                      style: GoogleFonts.varelaRound(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Rp. ${subTotal.toString()}",
                      style: GoogleFonts.varelaRound(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffF79955),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  child: MaterialButton(
                    onPressed: () => {},
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: new Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DetailProducts(
                          idUser: widget.idUser,
                          idProduk: _dataItem[index]['id_menu'],
                          nameProduk: _dataItem[index]['nama_menu'],
                          price: _dataItem[index]['harga_menu'],
                        ),
                      ),
                    )
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _dataItem[index]['nama_menu'],
                            style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Text(
                            _dataItem[index]['harga_menu'],
                            style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            "Items : ${_dataItem[index]['jumlah_item']}",
                            style: GoogleFonts.varelaRound(fontSize: 18),
                          ),
                          Text(
                            "Keterangan : ${_dataItem[index]['keterangan']}",
                            style: GoogleFonts.varelaRound(fontSize: 18),
                          ),
                          Text(
                            "Total Harga : ${double.parse(_dataItem[index]['harga_menu']) * int.parse(_dataItem[index]['jumlah_item'])}",
                            style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: _dataItem.length,
            ),
          ),
        ),
      ),
    );
  }
}
