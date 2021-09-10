import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:food_delivery_app/checkout.dart';
import 'package:food_delivery_app/color_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/models/category.dart';
import 'package:food_delivery_app/models/food_item.dart';
import 'package:http/http.dart' as http;

class FoodTile extends StatefulWidget {
  final FoodItem foodItem;
  final idUser;
  final kategoriMenu;

  const FoodTile({Key key, this.foodItem, this.idUser, this.kategoriMenu})
      : super(key: key);

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
                  idUser: widget.idUser,
                  idProduk: widget.foodItem.id,
                  nameProduk: widget.foodItem.name,
                  price: widget.foodItem.price,
                  kategoriProduk: widget.kategoriMenu,
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
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.foodItem.name,
                          style: GoogleFonts.varelaRound(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '\Rp. ${widget.foodItem.price}',
                          style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: ColorConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/${widget.kategoriMenu}/${widget.foodItem.name}.jpg'),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  )
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
  final idUser;
  final idProduk;
  final nameProduk;
  final price;
  final kategoriProduk;

  const DetailProducts(
      {Key key,
      this.idUser,
      this.idProduk,
      this.nameProduk,
      this.price,
      this.kategoriProduk})
      : super(key: key);

  @override
  _DetailProductsState createState() => _DetailProductsState();
}

class _DetailProductsState extends State<DetailProducts> {
  int _jumlahitem = 0;
  TextEditingController keteranganController = TextEditingController();

  void searchItem() async {
    var url = Uri.parse(
        'https://apinurmaya.adriel-creation.tech/configAPI/order.php');
    var response = await http.post(url, body: {
      'task': 'searchItem',
      'idUser': widget.idUser,
      'namamenu': widget.nameProduk,
    });
    if (response.statusCode == 200) {
      if (response.body == "Failed") {
        print("Data tidak ada");
      } else {
        var dataSearch = response.body;
        var dataSearchParsing = json.decode(dataSearch);
        var jumlahitemint = int.parse(dataSearchParsing[0]['jumlah_item']);
        setState(() {
          _jumlahitem = jumlahitemint;
          keteranganController.text = dataSearchParsing[0]['keterangan'];
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${response.statusCode}"),
      ));
    }
  }

  void tambahItem() async {
    if (_jumlahitem > 0) {
      var url = Uri.parse(
          'https://apinurmaya.adriel-creation.tech/configAPI/order.php');
      var response = await http.post(url, body: {
        'task': 'tambahItem',
        'idUser': widget.idUser,
        'idMenu': widget.idProduk.toString(),
        'namamenu': widget.nameProduk,
        'hargamenu': widget.price.toString(),
        'keterangan': keteranganController.text,
        'jumlahitem': _jumlahitem.toString(),
      });
      if (response.statusCode == 200) {
        if (response.body == "Success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  DetailsPage(idUser: widget.idUser),
            ),
          );
        } else if (response.body ==
            "Error: Duplicate entry '${widget.idProduk}' for key 'id_menu'") {
          var responsedua = await http.post(url, body: {
            'task': 'updateItem',
            'idUser': widget.idUser,
            'idMenu': widget.idProduk.toString(),
            'keterangan': keteranganController.text,
            'jumlahitem': _jumlahitem.toString(),
          });
          if (responsedua.body == "Success") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    DetailsPage(idUser: widget.idUser),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(response.body),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response.body),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: ${response.statusCode}"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Item tidak boleh kosong"),
      ));
    }
  }

  void increment() {
    setState(() {
      _jumlahitem++;
    });
  }

  void decrement() {
    if (_jumlahitem == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Jumlah item tidak boleh minus"),
      ));
    } else {
      setState(() {
        _jumlahitem--;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchItem();
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
                      "Total Harga :",
                      style: GoogleFonts.varelaRound(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Rp. ${widget.price * _jumlahitem}",
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
                    onPressed: () => {tambahItem()},
                    child: Text(
                      "Tambah ke Keranjang",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: new BoxDecoration(
                color: Color(0xffF79955),
                image: new DecorationImage(
                  image: new AssetImage(
                      'assets/${widget.kategoriProduk}/${widget.nameProduk}.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(219, 219, 219, 1),
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.nameProduk.toString(),
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.price.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keterangan",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: keteranganController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Tambah Keterangan',
                        hintText: 'contoh: Tidak pakai nasi',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => {increment()},
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _jumlahitem.toString(),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => {decrement()},
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsPage extends StatefulWidget {
  final idUser;
  final namaUser;

  const DetailsPage({Key key, this.idUser, this.namaUser}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int countingItem = 0;

  void selectDataPesanan() async {
    var url = Uri.parse(
        'https://apinurmaya.adriel-creation.tech/configAPI/order.php');
    var response = await http.post(url, body: {
      'task': 'selectCountItem',
      'idUser': widget.idUser,
    });
    if (response.statusCode == 200) {
      var countItem = json.decode(response.body);
      var intParsingCount = int.parse(countItem[0]['sum_item']);
      setState(() {
        countingItem = intParsingCount;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error : ${response.statusCode}"),
      ));
    }
  }

  void createTable() async {
    var url = Uri.parse(
        'https://apinurmaya.adriel-creation.tech/configAPI/order.php');
    var response = await http.post(url, body: {
      'task': 'createTableCheckout',
      'id_user': widget.idUser,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  void initState() {
    super.initState();
    createTable();
    selectDataPesanan();
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Text(
          "Hi, ${widget.namaUser}",
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        backgroundColor: Color(0xffF79955),
        elevation: 0,
        actions: [
          searchBar.getSearchAction(context),
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(
                        builder: (BuildContext context) => CheckoutPage(
                          idUser: widget.idUser,
                        ),
                      ),
                    );
                  },
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      countingItem == 0
                          ? new Container()
                          : new Positioned(
                              child: new Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.brightness_1,
                                  size: 20.0,
                                  color: Colors.green,
                                ),
                                new Positioned(
                                    top: 3.5,
                                    right: 6.0,
                                    child: new Center(
                                      child: new Text(
                                        countingItem.toString(),
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                    ],
                  ),
                )),
          ),
        ]);
  }

  _DetailsPageState() {
    searchBar = new SearchBar(
        inBar: false,
        setState: setState,
        onSubmitted: searchTrigger,
        buildDefaultAppBar: buildAppBar);
  }

  List<Category> data = [
    Category(
      id: 1,
      name: 'Makanan',
      foodList: <FoodItem>[
        FoodItem(
          id: 1,
          name: 'Ayam Panggang',
          price: 10.99,
          urlImage: 'Ayam Panggang',
        ),
        FoodItem(
          id: 2,
          name: 'Sop Ayam Bening',
          price: 12.99,
          urlImage: 'Sop Ayam Bening',
        ),
        FoodItem(
          id: 3,
          name: 'Cumi Telur Asin',
          price: 12.99,
          urlImage: 'Cumi Telur Asin',
        ),
        FoodItem(
          id: 4,
          name: 'Gurami Goreng',
          price: 12.99,
          urlImage: 'Gurami Goreng',
        ),
        FoodItem(
          id: 5,
          name: 'Gurami Telur Asin',
          price: 12.99,
          urlImage: 'Gurami Telur Asin',
        ),
        FoodItem(
          id: 6,
          name: 'Gurami Tauco Pete',
          price: 12.99,
        ),
        FoodItem(
          id: 7,
          name: 'Gurami Asam Manis',
          price: 12.99,
          urlImage: 'Gurami Asam Manis',
        ),
        FoodItem(
          id: 8,
          name: 'Nasi Putih',
          price: 12.99,
        ),
      ],
    ),
    Category(
      id: 2,
      name: 'Sayuran',
      foodList: <FoodItem>[
        FoodItem(
          id: 1,
          name: 'Tempe Mendoan',
          price: 5.99,
        ),
        FoodItem(
          id: 2,
          name: 'Kangkung Berastagi',
          price: 6.99,
        ),
        FoodItem(
          id: 3,
          name: 'Gado - Gado',
          price: 6.99,
        ),
        FoodItem(
          id: 4,
          name: 'Terong Balado',
          price: 6.99,
        ),
        FoodItem(
          id: 5,
          name: 'Terong Bawang Putih',
          price: 6.99,
        ),
      ],
    ),
    Category(
      id: 3,
      name: 'Minuman',
      foodList: <FoodItem>[
        FoodItem(
          id: 1,
          name: 'Kelapa Jeruk',
          price: 5.99,
        ),
        FoodItem(
          id: 2,
          name: 'Aqua 330 ml',
          price: 4.99,
        ),
        FoodItem(
          id: 3,
          name: 'Kelapa Gelas',
          price: 4.99,
        ),
        FoodItem(
          id: 4,
          name: 'Jus Alpukat',
          price: 4.99,
        ),
        FoodItem(
          id: 4,
          name: 'Jus Sirsak',
          price: 4.99,
        ),
        FoodItem(
          id: 5,
          name: 'Lemon Tea',
          price: 4.99,
        ),
        FoodItem(
          id: 6,
          name: 'Teh Manis',
          price: 4.99,
        ),
        FoodItem(
          id: 7,
          name: 'Lemon Grasstea',
          price: 4.99,
        ),
        FoodItem(
          id: 8,
          name: 'Sawi Nenas',
          price: 6.99,
        ),
      ],
    ),
  ];

  void searchTrigger(value) {
    data.map((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              decoration: new BoxDecoration(
                color: Color(0xffF79955),
                image: new DecorationImage(
                  image: new AssetImage('assets/Chef.gif'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    _buildIntro(),
                    Expanded(
                      child: _buildMenu(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Restoran Sajian Bhinekka',
            style: GoogleFonts.varelaRound(
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Restoran Sajian Bhinekka berlokasi di Jln. Babura Lama No.4, Darat, Kec. Medan Baru, Kota Medan, Sumatera Utara, 20153.',
            style: GoogleFonts.varelaRound(
              fontSize: 15,
              fontWeight: FontWeight.w200,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Container(
      child: DefaultTabController(
        length: data.length,
        child: Column(
          children: <Widget>[
            _buildTabBar(),
            Expanded(
              child: _buildTabBarView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelColor: Colors.black,
      isScrollable: true,
      indicatorColor: ColorConstants.primaryColor,
      unselectedLabelColor: Colors.grey,
      labelStyle: GoogleFonts.varelaRound(fontWeight: FontWeight.w600),
      tabs: List.generate(
        data.length,
        (index) => Tab(
          text: data[index].name,
        ),
      ),
    );
  }

  _buildTabBarView() {
    return Container(
      child: TabBarView(
        children: List.generate(
          data.length,
          (index) {
            ///TabBarView children length = Number of categories
            ///Each category have foodList (ListView)
            return ListView.separated(
                padding: EdgeInsets.all(20),
                itemBuilder: (context, foodIndex) {
                  return FoodTile(
                    kategoriMenu: data[index].name,
                    idUser: widget.idUser,
                    foodItem: data[index].foodList[foodIndex],
                  );
                },
                separatorBuilder: (context, foodIndex) {
                  return SizedBox(
                    height: 20,
                  );
                },
                itemCount: data[index].foodList.length);
          },
        ),
      ),
    );
  }
}
