
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mux_flutter/streaming.dart';
import 'package:mux_flutter/watch_stream.dart';
import 'package:mux_flutter/model/liveStream.dart';
import 'package:rtmp_publisher/camera.dart';

Future <void> main() async {

  // Fetch the available cameras before initializing the app.
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  List streamData = [];


  getListOfAsset() async{
    print("getAsset");
    try{
    var url = Uri.parse("https://a4c7575036de.ngrok.io/assets");
    http.Response response = await http.get(url);
    debugPrint(response.body);
    }catch(err){
      debugPrint(err.toString());
    }
  }

  getListOfStream() async{
    print("getStream");
    try{
    var url = Uri.parse("https://313a7ce66ff5.ngrok.io/live-streams");
    http.Response response = await http.get(url);
    debugPrint(response.body);
    List data = jsonDecode(response.body);
    setState(() {
      streamData = data;
    });
    }catch(err){
      debugPrint(err.toString());
    }
  }

  changeToWatchStream(String roomID){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>WatchStream(playbackID: roomID,)),
          );
  }

  createNewStream() async{
    print("create a new stream");
    Map data;
    try{
      var url = Uri.parse("https://313a7ce66ff5.ngrok.io/newStream");
    http.Response response = await http.post(url);
    data = json.decode(response.body);

    Navigator.push(context, MaterialPageRoute(builder: (context)=>CameraApp(streamingUrl: data['stream_key'],cams : cameras)),
          );
    debugPrint(response.body);
    }catch(err){
      debugPrint(err.toString());
    }
  }

  Future <List> getStreamList() async{
    print("getStream");
    try{
    var url = Uri.parse("https://313a7ce66ff5.ngrok.io/live-streams");
    http.Response response = await http.get(url);
    debugPrint(response.body);
    List data = jsonDecode(response.body);
    return data;
    }catch(err){
      debugPrint(err.toString());
    }
    return [];
  }

  Future<Null> _refresh() {
  return getStreamList().then((_data) {
    setState(() => streamData = _data);
  });
}

  getListUsingModelClass() async{
     try{
    var url = Uri.parse("https://a4c7575036de.ngrok.io/live-streams");
    http.Response response = await http.get(url);
    debugPrint(response.body);
    List data = jsonDecode(response.body);
    List<LiveStream> list = [];
    data.forEach((element) { list.add(LiveStream.fromJson(element)); });

    }catch(err){
      debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfStream();
    print('length of camera description is $cameras.length');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator( 
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
          child: ListView.builder(
              itemCount:streamData.length,
              itemBuilder: (context,index){
                return Card(
                  child: ListTile(
                    onTap: (){var tmp = streamData[index]['playback_ids'];  changeToWatchStream(tmp[0]['id']);},
                    title: Text("Stream ${index+1}"),
                    subtitle: Text(streamData[index]["status"]),
                  ),
                );
              },
            ),
      ),
      floatingActionButton: FloatingActionButton(
       // onPressed: _incrementCounter,
        onPressed: (){
          createNewStream();
         // getListUsingModelClass();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

List<CameraDescription> cameras = [];