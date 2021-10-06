import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width / 100;
    height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'TO DO',
        ),
        leading: IconButton(
          icon: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Card(
          color: Colors.blueAccent,
          shape: CircleBorder(),
          child: TextButton(
              onPressed: () {},
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 4, vertical: height * 2),
            child: Column(
              children: List.generate(25, (index) => taskWidget()),
            )),
      ),
    );
  }

  Widget taskWidget() {
    return InkWell(
      child: Card(
        elevation: 10,
        color: Colors.greenAccent,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: width * 2, vertical: height),
          child: Container(
              width: double.maxFinite,
              child: Text(
                'TEXT',
                textAlign: TextAlign.center,
              )),
        ),
      ),
    );
  }
}
