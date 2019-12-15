import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:Kisan_Hub/activity.dart';
import 'package:Kisan_Hub/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List list1 = new List<Activity>();
  bool _isLoading = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    setState(() => _isLoading = true);
    fetchActivities(new http.Client());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    makeListTile(Activity activity) => Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    activity.activityId,
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
                Text(
                  activity.date,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            //SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.network(
                  activity.wakeUpImage,
                  width: 50.0,
                  height: 50.0,
                ),
                Text(
                  activity.wakeUp,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(width: 80),
                Image.network(
                  activity.totalStepsImage,
                  width: 50.0,
                  height: 50.0,
                ),
                Text(
                  activity.totalSteps + " Steps",
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ],
        );

    makeCard(Activity activity) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            decoration: BoxDecoration(color: Color(0xffffffff)),
            child: makeListTile(activity),
          ),
        );

    final makeBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: list1.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(list1[index]);
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        key: scaffoldKey,
        title: Text(
          'Activities',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.exitToApp, color: Colors.white),
            onPressed: showConfirmationDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : makeBody,
    );
  }

  void fetchActivities(http.Client client) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      final response = await client
          .get('https://kisanhub.mockable.io/flutter-test/activities');
      parseData(response.body);
    } else {
      signOut();
    }
  }

  void parseData(String res) {
    print(res);

    var parsed = json.decode(res);

    var activities = parsed['activities'];

    var lists = activities.map<Activity>((activities) => new Activity.fromJson(activities)).toList();

    setState(() {
      _isLoading = false;
      list1 = lists;
    });
    print(list1);
  }

  void signOut() async {
    
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
        (Route<dynamic> route) => false);
  }

  void showConfirmationDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(
                'Signout',
                style: new TextStyle(fontSize: 25.0),
              ),
              content: new Text(
                'Please confirm if you would like to signout of the application?',
                style: new TextStyle(fontSize: 15.0),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      signOut();
                    },
                    child: new Text('Yes',
                        style: new TextStyle(
                            color: Color(0xffbbc91a), fontSize: 20))),
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('No',
                        style: new TextStyle(
                            color: Color(0xffbbc91a), fontSize: 20))),
              ],
            ));
  }
}
