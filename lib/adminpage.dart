import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selamat Datang, Admin"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.amber,
      ),
    );
  }
}

class BerandaPage extends StatelessWidget {
  const BerandaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataUserPage extends StatelessWidget {
  const DataUserPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DataPesananPage extends StatelessWidget {
  const DataPesananPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
