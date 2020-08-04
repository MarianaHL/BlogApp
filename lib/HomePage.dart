import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/LoginPage.dart';
import 'package:flutter_firebase/PhotoUpload.dart';
import 'package:flutter_firebase/Posts.dart';
import 'package:flutter_firebase/SingIn.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  void initState() {
    super.initState();
    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");
    postsRef.once().then((DataSnapshot snap) {
      var key = snap.value.keys;
      var data = snap.value;

      postList.clear();

      for (var individualKey in key) {
        Posts posts = Posts(
          data[individualKey]['image'],
          data[individualKey]['description'],
          data[individualKey]['date'],
          data[individualKey]['time'],
        );
        postList.add(posts);
      }
      setState(() {
        print('Length: $postList.length');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color.fromRGBO(77, 38, 122, 48),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              signOutGoogle();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                return LoginPage();
              }), ModalRoute.withName('/'));
            },
            child: Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Container(
        child: postList.length == 0
            ? Text("No Blog Available")
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return postsUI(
                    postList[index].image,
                    postList[index].description,
                    postList[index].date,
                    postList[index].time,
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromRGBO(77, 38, 122, 48),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                'New post',
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 30,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PhotoUpload();
                  }));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget postsUI(String image, String description, String date, String time) {
    return Card(
      elevation: 30.0,
      margin: EdgeInsets.all(14.0),
      child: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                  radius: 20,
                  backgroundColor: Colors.transparent,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 15, shadows: <Shadow>[
                      Shadow(
                          blurRadius: 18.0,
                          color: Colors.black87,
                          offset: Offset.fromDirection(120, 8))
                    ]),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.subtitle2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
