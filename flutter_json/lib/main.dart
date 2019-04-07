import "package:flutter/material.dart";
import "dart:io";
import "dart:async";
import "dart:convert";
//import "package:http/http.dart" as http;
import "JsonQueries.dart";


void main() => runApp(new MaterialApp(
  home: new HomePage(),
));

class HomePage extends StatefulWidget{
  @override
  HomePageState createState()=> new HomePageState();

}

class HomePageState extends State<HomePage>{
  
  final String url = "https://swapi.co/api/people";
  final String url1 = "http://192.168.0.31:1705";
  List data;
  Socket socket;
  ServerStatus status = new ServerStatus();


  @override
  void initState(){
    super.initState();
    //this.createPost(url1);
    _testConnect();
  }

 /* Future<String> createPost(String url) async {
  }*/

  void _testConnect() async {
    try {
      const Duration ReceiveTimeout = const Duration(milliseconds: 5000);
      socket = await Socket.connect("192.168.0.31", 1705).then((socket) {
        socket.setOption(SocketOption.tcpNoDelay, true);
        socket.timeout(ReceiveTimeout);
        print('Connected to: '
            '${socket.remoteAddress.address}:${socket.remotePort}');
        String str = status.getMessageString() +"\r\n";
        print(str);
        socket.write(status.jsonMessage);
        socket.listen((data) {
          String packetData = (new String.fromCharCodes(data).trim());
          String stringData = json.decode(packetData);
          print(stringData);
        },
        onDone: () {
          print("Done");
          socket.destroy();
        });
        socket.destroy();
      });
    } catch(e){
      print('Failed to Connect');
    }

  }


  /*Future<String> getJsonData() async {

    var response1 = await http.post(
      Uri.encodeFull(url1),
      headers: {"Accept": "application/json"}
    );
    var response = await http.get(
      //Encode URL
      Uri.encodeFull(url),
      //only accept json response
      headers: {"Accept": "application/json"}
    );

    print(response.body);
    print(response1.body);

    setState((){
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson['results'];
    });

    return "Success";

  }*/

  double _volume = 0.0;
  double _sliderValue = 0.0;
  bool _value1 = false;

  void _value1Changed(bool value) => setState(() => _value1 = value);

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Retrieve Json via HTTP Get"),
      ),
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index){
          return new Container(
            child: new Center(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Checkbox(
                    value: _value1,
                    onChanged: _value1Changed,

                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      try {
                        ClientVolume volume = new ClientVolume("b8:27:eb:da:69:d8", false, 100);
                        volume.setVolume();

                      } catch(e) {
                        print('Failed to Connect');
                      }
                      setState(() {
                        _volume+=10;
                      });
                    },
                  ),
                  Text('Volume: $_volume')
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}