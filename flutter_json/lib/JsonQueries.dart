import "dart:convert";
import "dart:async";
import "dart:io";

class JSONVolume{
  var volume = {};
  String volString;

  JSONVolume(bool mute, int percent){
    this.volume["muted"] = mute;
    this.volume["percent"] = percent;
    this.volString = json.encode(this.volume) + "\r\n";
  }

  String getVolString(){
    return this.volString;
  }

}

class JSONParams{
  var params = {};
  String paramString;

  JSONParams(String id, bool mute, int percent){
    this.params["id"] = id;
    this.params["volume"] = JSONVolume(mute, percent).volume;
    this.paramString = json.encode(this.params) + "\r\n";
  }

  String getparamString(){
    return paramString;
  }
}

class ServerRPCVersion{

  var jsonMessage = {};
  String messageString;

  ServerRPCVersion(){
    this.jsonMessage["id"] = 8;
    this.jsonMessage["jsonrpc"] = "2.0";
    this.jsonMessage["method"] = "Server.GetRPCVersion";
    this.messageString = json.encode(this.jsonMessage) + "\r\n";
  }
}

class ServerStatus{

  var jsonMessage = {};
  String messageString;

  ServerStatus(){
    this.jsonMessage["id"] = 1;
    this.jsonMessage["jsonrpc"] = "2.0";
    this.jsonMessage["method"] = "Server.GetStatus";
    this.messageString = json.encode(this.jsonMessage) + "\r\n";
  }

  String getMessageString(){
    return this.messageString;
  }
}

class ClientVolume{
  var jsonMessage = {};
  String messageString;

  ClientVolume(String clientID, bool mute, int percent){
    this.jsonMessage["id"] = 8;
    this.jsonMessage["jsonrpc"] = "2.0";
    this.jsonMessage["method"] = "Client.SetVolume";
    this.jsonMessage["params"] = JSONParams(clientID, mute, percent).params;
    this.messageString = json.encode(this.jsonMessage) + "\r\n";
  }

  String getMessageString(){
    return this.messageString;
  }

  void setVolume(){
    const Duration ReceiveTimeout = const Duration(milliseconds: 5000);
    Socket.connect("192.168.0.31", 1705).then((socket) {
      socket.setOption(SocketOption.tcpNoDelay, true);
      socket.timeout(ReceiveTimeout);
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      String str = this.getMessageString();
      print(str);
      socket.write(str);
      socket.listen((data) {
        String packetData = (new String.fromCharCodes(data).trim());
        print(packetData);
      },
          onDone: () {
            print("Done");
            socket.destroy();
          });
      socket.destroy();
    }
    );}
}
