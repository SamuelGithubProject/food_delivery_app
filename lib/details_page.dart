import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:food_delivery_app/color_constants.dart';
import 'package:food_delivery_app/widgets/food_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:food_delivery_app/models/category.dart';
import 'package:food_delivery_app/models/food_item.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Color(0xffF79955),
        elevation: 0,
        actions: [
          searchBar.getSearchAction(context),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.shopping_cart,
                  size: 26.0,
                ),
              )),
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
        ),
        FoodItem(
          id: 2,
          name: 'Sop Ayam Bening',
          price: 12.99,
        ),
        FoodItem(
          id: 3,
          name: 'Cumi Telur Asin',
          price: 12.99,
        ),
        FoodItem(
          id: 4,
          name: 'Gurami Goreng',
          price: 12.99,
        ),
        FoodItem(
          id: 5,
          name: 'Gurami Telur Asin',
          price: 12.99,
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
        FoodItem(
          id: 6,
          name: 'Sawi Nenas',
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
